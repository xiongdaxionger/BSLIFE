//
//  WMFoundHomeViewController.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomeViewController.h"
#import "WMFoundHomeInfo.h"
#import "WMFoundListInfo.h"
#import "WMFoundCategoryInfo.h"
#import "WMFoundCommentListViewController.h"
#import "WMFoundViewController.h"
#import "WMFoundHomeAdCell.h"
#import "WMFoundHomePostListCell.h"
#import "WMFoundHomePlateListCell.h"
#import "WMFoundHomeSectionHeaderView.h"
#import "WMFoundHomeMoreSectionFooterView.h"
#import "WMUserInfo.h"
#import "WMFoundOperation.h"
#import "WMFoundListViewController.h"

@interface WMFoundHomeViewController ()<SeaNetworkQueueDelegate,SeaHttpRequestDelegate,WMFoundHomeMoreSectionFooterViewDelegate,WMFoundHomePostListCellDelegate>

///网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///数据 数组元素是 WMFoundHomeInfo
@property(nonatomic,strong) NSArray *infos;

///临时首页信息，用于队列加载时保存数据 数组元素是 WMHomeInfo
@property(nonatomic,strong) NSMutableArray *tmpInfos;

//选中的cell
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

///是否只加载达人推荐
@property(nonatomic,assign) BOOL onlyLoadTalentRecommend;

@end

@implementation WMFoundHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"社区";
    self.infos = [NSMutableArray array];
    self.tmpInfos = [NSMutableArray array];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
    
    ///添加登录监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:WMLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:WMUserDidLogoutNotification object:nil];
    
    ///添加评论监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundCommentDidAdd:) name:WMFoundCommentDidAddNotification object:nil];
    
    ///添加点赞监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundDidPraise:) name:WMFoundDidPraiseNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialization
{
    self.loading = NO;
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    
    [super initialization];
    
    
    [self.collectionView registerClass:[WMFoundHomeAdCell class] forCellWithReuseIdentifier:@"WMFoundHomeAdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMFoundHomePostListCell" bundle:nil] forCellWithReuseIdentifier:@"WMFoundHomePostListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMFoundHomePlateListCell" bundle:nil] forCellWithReuseIdentifier:@"WMFoundHomePlateListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMFoundHomeUserListCell" bundle:nil] forCellWithReuseIdentifier:@"WMFoundHomeUserListCell"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMFoundHomeSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMFoundHomeSectionHeaderView"];
    [self.collectionView registerClass:[WMFoundHomeMoreSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMFoundHomeMoreSectionFooterView"];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    self.enableDropDown = YES;
    
    if(self.infos.count == 0)
    {
        [self setHasNoMsgViewHidden:NO msg:@"暂无信息"];
    }
}

///获取对应的信息
- (id)infoForIndexPath:(NSIndexPath*) indexPath
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    return [info.infos objectAtIndex:indexPath.item];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    ///启动轮播广告
    NSArray *cells = [self.collectionView visibleCells];
    for(WMFoundHomeAdCell *cell in cells)
    {
        if([cell isKindOfClass:[WMFoundHomeAdCell class]])
        {
            [cell.adScrollView startAnimate];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ///停止轮播广告
    NSArray *cells = [self.collectionView visibleCells];
    for(WMFoundHomeAdCell *cell in cells)
    {
        if([cell isKindOfClass:[WMFoundHomeAdCell class]])
        {
            [cell.adScrollView stopAnimate];
        }
    }
}

#pragma mark- 通知

///添加评论
- (void)foundCommentDidAdd:(NSNotification*) notification
{
    NSString *Id = [[notification userInfo] objectForKey:WMFoundListInfoIdKey];
    
    if(Id)
    {
        if(self.infos.count > 0)
        {
            for(WMFoundHomeInfo *info in self.infos)
            {
                if(info.type == WMFoundHomeInfoTypePost)
                {
                    for(WMFoundListInfo *listInfo in info.infos)
                    {
                        if([listInfo.Id isEqualToString:Id])
                        {
                            listInfo.commentCount ++;
                            break;
                        }
                    }
                }
            }
        }
        
        [self.collectionView reloadData];
    }
}

///点赞
- (void)foundDidPraise:(NSNotification*) notification
{
    NSString *Id = [[notification userInfo] objectForKey:WMFoundListInfoIdKey];
    
    if(Id)
    {
        if(self.infos.count > 0)
        {
            for(WMFoundHomeInfo *info in self.infos)
            {
                if(info.type == WMFoundHomeInfoTypePost)
                {
                    for(WMFoundListInfo *listInfo in info.infos)
                    {
                        if([listInfo.Id isEqualToString:Id])
                        {
                            listInfo.isPraised = !listInfo.isPraised;
                            if(listInfo.isPraised)
                            {
                                listInfo.praisedCount ++;
                            }
                            else
                            {
                                listInfo.praisedCount --;
                            }
                            
                            break;
                        }
                    }
                }
            }
        }
        
        [self.collectionView reloadData];
    }
}

///登录成功
- (void)userDidLogin:(NSNotification*) notification
{
    [self.refreshControl beginRefresh];
}

///退出登录
- (void)userDidLogout:(NSNotification*) notification
{
    [self.refreshControl beginRefresh];
}

#pragma mark- queue

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(self.refreshing)
    {
        [self endDropDownRefreshWithMsg:nil];
    }
    else
    {
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMFoundHomeInfoIdentifier])
    {
        NSArray *infos = [WMFoundOperation foundHomeInfoFromData:data];
        if(infos)
        {
            self.infos = infos;
        }
        
        if(!self.collectionView)
        {
            [self initialization];
        }
        else if(self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
            [self.collectionView reloadData];
        }
        
        return;
    }
}

//加载数据
- (void)loadInfo
{
    self.httpRequest.identifier = WMFoundHomeInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMFoundOperation foundHomeInfoParams]];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

#pragma mark- UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.infos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:section];
    switch (info.type)
    {
        case WMFoundHomeInfoTypeBillboards :
        {
            return 1;
        }
            break;
        case WMFoundHomeInfoTypePlate :
        {
            return info.infos.count;
        }
            break;
        case WMFoundHomeInfoTypePost :
        {
            return  info.infos.count;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    switch (info.type)
    {
        case WMFoundHomeInfoTypeBillboards :
        {
            return info.size;
        }
            break;
        case WMFoundHomeInfoTypePlate :
        {
            return WMFoundHomePlateListCellSize;
        }
            break;
        case WMFoundHomeInfoTypePost :
        {
            return WMFoundHomePostListCellSize;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:section];
    switch (info.type)
    {
        case WMFoundHomeInfoTypeBillboards :
        {
            return CGSizeZero;
        }
            break;
        case WMFoundHomeInfoTypePlate :
        case WMFoundHomeInfoTypePost :
        {
            return WMFoundHomeSectionHeaderViewSize;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:section];
    switch (info.type)
    {
        case WMFoundHomeInfoTypeBillboards :
        case WMFoundHomeInfoTypePlate :
        {
            return CGSizeZero;
        }
            break;
        case WMFoundHomeInfoTypePost :
        
        {
            return WMFoundHomeMoreSectionFooterViewSize;
        }
            break;
    }
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WMFoundHomeSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMFoundHomeSectionHeaderView" forIndexPath:indexPath];
        header.title_label.text = info.name;
        return header;
    }
    else
    {
        WMFoundHomeMoreSectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMFoundHomeMoreSectionFooterView" forIndexPath:indexPath];
        footer.delegate = self;
        footer.section = indexPath.section;
        return footer;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHomeAdCell *cell1 = (WMFoundHomeAdCell*)cell;
    if([cell1 isKindOfClass:[WMFoundHomeAdCell class]])
    {
        [cell1.adScrollView startAnimate];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHomeAdCell *cell1 = (WMFoundHomeAdCell*)cell;
    if([cell1 isKindOfClass:[WMFoundHomeAdCell class]])
    {
        [cell1.adScrollView stopAnimate];
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMFoundHomeInfoTypeBillboards :
        {
            WMFoundHomeAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMFoundHomeAdCell" forIndexPath:indexPath];
            cell.rollInfos = info.infos;
            cell.navigationController = self.navigationController;
            
            return cell;
        }
            break;
        case WMFoundHomeInfoTypePost :
        {
            WMFoundHomePostListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMFoundHomePostListCell" forIndexPath:indexPath];
            cell.info = [info.infos objectAtIndex:indexPath.item];
            cell.delegate = self;
            return cell;
        }
            break;
        case WMFoundHomeInfoTypePlate :
        {
            WMFoundHomePlateListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMFoundHomePlateListCell" forIndexPath:indexPath];
            cell.info = [info.infos objectAtIndex:indexPath.item];
            
            return cell;
        }
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMFoundHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMFoundHomeInfoTypePost :
        {
            WMFoundCommentListViewController *comment = [[WMFoundCommentListViewController alloc] initWithInfo:[info.infos objectAtIndex:indexPath.item]];
            [self.navigationController pushViewController:comment animated:YES];
        }
            break;
        case WMFoundHomeInfoTypePlate :
        {
            WMFoundViewController *found = [[WMFoundViewController alloc] init];
            found.infos = info.infos;
            found.selectedFoundCategoryInfo = [info.infos objectAtIndex:indexPath.item];
            [self.navigationController pushViewController:found animated:YES];
        }
            break;
        case WMFoundHomeInfoTypeBillboards :
        {
            
        }
            break;
    }
}

#pragma mark- WMFoundHomeMoreSectionFooterView delegate

- (void)foundHomeMoreSectionFooterViewDidTapMore:(WMFoundHomeMoreSectionFooterView *)view
{
    WMFoundListViewController *found = [[WMFoundListViewController alloc] init];
    
    found.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:found animated:YES];
}

#pragma mark- WMFoundHomePostListCell delegate

- (void)foundHomePostListCellDidComment:(WMFoundHomePostListCell *)cell
{
    [self commentCell:cell];
}

- (void)foundHomePostListCellDidPraise:(WMFoundHomePostListCell *)cell
{
    if([AppDelegate instance].isLogin)
    {
        [self praiseCell:cell];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [self praiseCell:cell];
        }];
    }
}

///评论
- (void)commentCell:(WMFoundHomePostListCell*) cell
{
    ///评论
    WMFoundListInfo *info = cell.info;
    WMFoundCommentListViewController *comment = [[WMFoundCommentListViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:comment animated:YES];
}

///点赞
- (void)praiseCell:(WMFoundHomePostListCell*) cell
{
    WMFoundListInfo *info = cell.info;
    info.isPraised = !info.isPraised;
    if(info.isPraised)
    {
        info.praisedCount ++;
    }
    else
    {
        info.praisedCount --;
    }
    cell.praise_btn.selected = info.isPraised;
    [cell.praise_btn setTitle:[NSString stringWithFormat:@" %d", info.praisedCount] forState:UIControlStateNormal];

    ///点赞
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMFoundOperation foundPraiseParamWithInfo:info] identifier:info.Id];
    [self.queue startDownload];
}



@end
