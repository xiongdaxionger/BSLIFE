//
//  WMIntegralSignInViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/18.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMIntegralSignInViewController.h"
#import "WMIntegralOperation.h"
#import "WMIntegralSignInHeaderView.h"
#import "WMIntegralGoodListCell.h"
#import "WMInegralGoodInfo.h"
#import "WMIntegralSignInInfo.h"
#import "WMGoodDetailContainViewController.h"

@interface WMIntegralSignInViewController ()<SeaNetworkQueueDelegate>

///网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

///签到信息
@property(nonatomic,strong) WMIntegralSignInInfo *signInInfo;

///商品列表信息 ，数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *infos;


@end

@implementation WMIntegralSignInViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"签到";
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    self.queue.shouldCancelAllRequestWhenOneFail = NO;
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.layout.minimumInteritemSpacing = WMIntegralGoodListCellMargin;
    self.layout.minimumLineSpacing = WMIntegralGoodListCellMargin;
    self.layout.sectionInset = UIEdgeInsetsMake(0, WMIntegralGoodListCellMargin, WMIntegralGoodListCellMargin, WMIntegralGoodListCellMargin);
    self.layout.headerReferenceSize = CGSizeMake(_width_, self.infos.count > 0 ? WMIntegralSignInHeaderViewHeight : WMIntegralSignInHeaderViewNoGoodsHeight);
    self.layout.itemSize = WMIntegralGoodListCellSize;
    
    [super initialization];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMIntegralGoodListCell" bundle:nil] forCellWithReuseIdentifier:@"WMIntegralGoodListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMIntegralSignInHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMIntegralSignInHeaderView"];
    
    self.enablePullUp = YES;
    
    [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMIntegralGoodListIdentifier])
    {
        if(self.loadMore)
        {
            self.curPage --;
            [self endPullUpLoadingWithMoreInfo:YES];
        }
        
        return;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMIntegralSignInIdentifier])
    {
        self.signInInfo = [WMIntegralOperation integralSignInResultFromData:data];
        return;
    }
    
    if([identifier isEqualToString:WMIntegralGoodListIdentifier])
    {
        long long totalSize = 0;
        NSArray *infos = [WMIntegralOperation integralGoodListFromData:data totalSize:&totalSize];
        
        if(infos)
        {
            self.totalCount = totalSize;
            if(!self.infos)
            {
                self.infos = [NSMutableArray array];
            }
            
            [self.infos addObjectsFromArray:infos];
            
            if(self.loadMore)
            {
                [self.collectionView reloadData];
            }
            
            [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
        }
        
        return;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(!self.collectionView)
    {
        if(self.signInInfo)
        {
            [self initialization];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:self.signInInfo.message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        else
        {
            [self failToLoadData];
        }
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self signIn];
    [self loadIntegralGoodList];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadIntegralGoodList];
}

///签到
- (void)signIn
{
    if(self.signInInfo)
    {
        return;
    }
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMIntegralOperation integralSignInParams] identifier:WMIntegralSignInIdentifier];
    [self.queue startDownload];
}

///获取积分商品
- (void)loadIntegralGoodList
{
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMIntegralOperation integralGoodListParamWithPageIndex:self.curPage] identifier:WMIntegralGoodListIdentifier];
    [self.queue startDownload];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WMIntegralSignInHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMIntegralSignInHeaderView" forIndexPath:indexPath];
    header.info = self.signInInfo;
    header.navigationController = self.navigationController;
    header.good_header_bg_view.hidden = self.infos.count == 0;
    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMIntegralGoodListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMIntegralGoodListCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.isGift = YES;
    WMInegralGoodInfo *info = [self.infos objectAtIndex:indexPath.item];
    detail.goodID = info.goodId;
    detail.productID = info.productId;

    [self.navigationController pushViewController:detail animated:YES];
}

@end
