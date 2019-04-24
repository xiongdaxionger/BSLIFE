//
//  WMGoodCollectListViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCollectListViewController.h"
#import "WMGoodListOperation.h"
#import "WMGoodCollectionInfo.h"
#import "WMGoodCollectListCell.h"
#import "WMGoodDetailContainViewController.h"
#import "WMGoodDetailOperation.h"
#import "WMGoodListSuspensionButton.h"
#import "WMShopCarOperation.h"
#import "WMUserInfo.h"
#import "WMGoodCommitNotifyViewController.h"

@interface WMGoodCollectListViewController ()<SeaHttpRequestDelegate,WMGoodCollectListCellDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///收藏的商品信息 数组元素是 WMGoodCollectionInfo
@property(nonatomic,strong) NSMutableArray *infos;

///选中的cell
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

///购物车图标
@property(nonatomic,strong) WMGoodListSuspensionButton *shopcartButton;

///取消过收藏的商品
@property(nonatomic,strong) WMGoodCollectionInfo *canceledCollectInfo;

@end

@implementation WMGoodCollectListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    ///用户把去掉的收藏商品又加回来了
    if(self.canceledCollectInfo.goodInfo.isCollect)
    {
        [self.infos insertObject:self.canceledCollectInfo atIndex:0];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backItem = YES;
    self.title = @"商品收藏";
    self.infos = [NSMutableArray array];
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStyleGrouped;

    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodCollectListCell" bundle:nil] forCellReuseIdentifier:@"WMGoodCollectListCell"];
    self.tableView.rowHeight = WMGoodCollectListCellHeight;

    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.height -= (isIPhoneX ? 35.0 : 0.0);

    self.enablePullUp = YES;
    ///购物车按钮
//    self.shopcartButton = [[WMGoodListSuspensionButton alloc] initWithFrame:CGRectMake(_width_ - WMGoodListSuspensionButtonSize.width - 15.0, self.tableView.bottom - WMGoodListSuspensionButtonSize.height - 30.0, WMGoodListSuspensionButtonSize.width, WMGoodListSuspensionButtonSize.height)];
//    self.shopcartButton.navigationController = self.navigationController;
//    self.shopcartButton.scrollView = self.scrollView;
//    [self.view addSubview:self.shopcartButton];


    self.tableView.sea_shouldShowEmptyView = YES;

    ///添加商品操作通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodCollectDidChange:) name:WMGoodCollectDidChangeNotification object:nil];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无商品收藏";
}

#pragma mark- 通知

///商品收藏
- (void)goodCollectDidChange:(NSNotification*) notification
{
    BOOL status = [[notification.userInfo objectForKey:WMGoodCollectStatus] boolValue];
    NSString *goodId = [notification.userInfo objectForKey:WMGoodOperationGoodId];

    ///判断用户是否是连续点击收藏按钮
    if([self.canceledCollectInfo.goodInfo.goodId isEqualToString:goodId])
    {
        self.canceledCollectInfo.goodInfo.isCollect = status;
    }
    else
    {
        for(NSInteger i = 0;i < self.infos.count;i ++)
        {
            WMGoodCollectionInfo *info = [self.infos objectAtIndex:i];
            if([info.goodInfo.goodId isEqualToString:goodId])
            {
                info.goodInfo.isCollect = status;

                if(!info.goodInfo.isCollect)
                {
                    self.canceledCollectInfo = info;
                    [self.infos removeObjectAtIndex:i];
                    [self.tableView reloadData];
                }
                
                break;
            }
        }
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{

    if([request.identifier isEqualToString:WMCollectionListIdentifier])
    {
        if(self.loadMore)
        {
            [self endPullUpLoadingWithMoreInfo:YES];
            self.curPage --;
        }
        else
        {
            [self failToLoadData];
        }

        return;
    }

    self.requesting = NO;

    if([request.identifier isEqualToString:WMShopCarAddIdentifier])
    {
        [self alerBadNetworkMsg:@"加入购物车失败"];
        return;
    }

    if([request.identifier isEqualToString:WMGoodCollectIdentifier])
    {
        [self alerBadNetworkMsg:@"删除失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{

    if([request.identifier isEqualToString:WMCollectionListIdentifier])
    {
        long long totalSize = 0;
        NSArray *infos = [WMGoodListOperation collectionListFromData:data totalSize:&totalSize];

        if(infos)
        {
            self.totalCount = totalSize;
            [self.infos addObjectsFromArray:infos];

            if(self.tableView)
            {
                [self.tableView reloadData];
            }
            else
            {
                [self initialization];
            }

            [self endPullUpLoadingWithMoreInfo:self.infos.count < totalSize];
        }
        else if(self.loadMore)
        {
            [self endPullUpLoadingWithMoreInfo:YES];
            self.curPage --;
        }
        else
        {
            [self failToLoadData];
        }
        
        return;
    }

    self.requesting = NO;

    if([request.identifier isEqualToString:WMShopCarAddIdentifier])
    {
        if([WMShopCarOperation returnAddShopCarResultWithData:data])
        {
            [WMShopCarOperation updateShopCarNumberQuantity:[WMUserInfo sharedUserInfo].shopcartCount + 1 needChange:YES];
            
            [self alertMsg:@"已加入购物车"];
        }

        return;
    }

    if([request.identifier isEqualToString:WMGoodCollectIdentifier])
    {
        if([WMGoodListOperation goodCollectResultFromData:data])
        {
            [self.infos removeObjectAtIndex:self.selectedIndexPath.section];

            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }

        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
}

///加载信息
- (void)loadInfo
{
    self.httpRequest.identifier = WMCollectionListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation collectionListParamPageIndex:self.curPage]];
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count > 0 ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.infos.count > 0 ? 10.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodCollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMGoodCollectListCell" forIndexPath:indexPath];

    cell.delegate = self;
    cell.info = [self.infos objectAtIndex:indexPath.section];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMGoodCollectionInfo *info = [self.infos objectAtIndex:indexPath.section];
    if(info.goodInfo.isMarket)
    {
        WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
        detail.productID = info.goodInfo.productId;
        detail.goodID = info.goodInfo.goodId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    WMGoodCollectionInfo *info = [self.infos objectAtIndex:indexPath.section];
    self.showNetworkActivity = YES;
    self.requesting = YES;

    self.httpRequest.identifier = WMGoodCollectIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation goodCollectParamWithType:1 goodId:info.goodInfo.goodId]];
}

#pragma mark- WMGoodCollectListCell delegate

- (void)goodCollectListCellDidAddShopcart:(WMGoodCollectListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedIndexPath = indexPath;
    WMGoodCollectionInfo *info = [self.infos objectAtIndex:indexPath.section];

    self.showNetworkActivity = YES;
    self.requesting = YES;

    self.httpRequest.identifier = WMShopCarAddIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShopCarOperation returnAddShopCarParamWithBuyType:nil goodsID:info.goodInfo.goodId productID:info.goodInfo.productId buyQuantity:1 adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:@"goods"]];
}


- (void)goodCollectListCellDidNotice:(WMGoodCollectListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedIndexPath = indexPath;
    WMGoodCollectionInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    WMGoodCommitNotifyViewController *notice = [[WMGoodCommitNotifyViewController alloc] init];
    notice.goodID = info.goodInfo.goodId;
    notice.productID = info.goodInfo.productId;
    [self.navigationController pushViewController:notice animated:YES];
}

@end
