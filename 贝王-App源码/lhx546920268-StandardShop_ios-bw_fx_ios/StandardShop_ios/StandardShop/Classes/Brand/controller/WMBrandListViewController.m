//
//  WMBrandListViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMBrandListViewController.h"
#import "WMBrandSquareCell.h"
#import "WMCategoryOperation.h"
#import "WMBrandInfo.h"
#import "WMGoodListViewController.h"
#import "WMBrandOperation.h"

@interface WMBrandListViewController ()<SeaNetworkQueueDelegate>

///品牌信息 数组元素是 NSArray，数组元素是 WMBrandInfo
@property(nonatomic,strong) NSMutableArray *brandInfos;

///网络请求
@property(nonatomic,strong) SeaNetworkQueue *queue;

///是否请求失败
@property(nonatomic,assign) BOOL isFailToLoad;

@end

@implementation WMBrandListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.height = self.view.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.layout.itemSize = WMBrandSquareCellSize;
    self.layout.minimumLineSpacing = WMBrandSquareCellMargin;
    self.layout.minimumInteritemSpacing = WMBrandSquareCellMargin;
    self.layout.sectionInset = UIEdgeInsetsMake(WMBrandSquareCellMargin, WMBrandSquareCellMargin, WMBrandSquareCellMargin, WMBrandSquareCellMargin);
    
    [super initialization];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMBrandSquareCell" bundle:nil] forCellWithReuseIdentifier:@"WMBrandSquareCell"];
    self.collectionView.height = self.view.height;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.enablePullUp = YES;
    self.enableDropDown = YES;
    [self endPullUpLoadingWithMoreInfo:self.brandInfos.count < self.totalCount];
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
    self.loadingIndicator.height = _height_ - self.statusBarHeight - self.navigationBarHeight - self.tabBarHeight - _SeaMenuBarHeight_;
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if(self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else if (self.refreshing)
    {
        [self endDropDownRefreshWithMsg:nil];
    }
    else
    {
        self.isFailToLoad = YES;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMBrandListIdentifier])
    {
        long long totalSize = 0;
        NSArray *infos = [WMBrandOperation brandListFromData:data totalSize:&totalSize];

        if(infos)
        {
            self.totalCount = totalSize;

            if(self.loadMore)
            {
                [self.brandInfos addObjectsFromArray:infos];
                [self.collectionView reloadData];
                [self endPullUpLoadingWithMoreInfo:self.brandInfos.count < self.totalCount];
            }
            else if (self.refreshing)
            {
                [self.brandInfos removeAllObjects];
                [self.brandInfos addObjectsFromArray:infos];
                [self.collectionView reloadData];
                [self endDropDownRefreshWithMsg:nil];
                self.curPage = WMHttpPageIndexStartingValue;
                [self endPullUpLoadingWithMoreInfo:self.brandInfos.count < self.totalCount];
            }
            else
            {
                self.brandInfos = [NSMutableArray arrayWithArray:infos];
            }
        }
        else if (self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
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
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.isFailToLoad)
    {
        [self failToLoadData];
    }
    else
    {
        if(!self.collectionView)
        {
            [self initialization];
        }
    }
}

///加载数据
- (void)loadInfo
{
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMBrandOperation brandListParamsWithPageIndex:self.refreshing ? WMHttpPageIndexStartingValue : self.curPage] identifier:WMBrandListIdentifier];

    [self.queue startDownload];
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

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.brandInfos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMBrandInfo *info = [self.brandInfos objectAtIndex:indexPath.item];
    WMBrandSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMBrandSquareCell" forIndexPath:indexPath];
    [cell.imageView sea_setImageWithURL:info.imageURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMBrandInfo *info = [self.brandInfos objectAtIndex:indexPath.item];
    
    WMGoodListViewController *brand = [[WMGoodListViewController alloc] initWithBrandInfo:info];
    [self.navigationController pushViewController:brand animated:YES];
}

@end
