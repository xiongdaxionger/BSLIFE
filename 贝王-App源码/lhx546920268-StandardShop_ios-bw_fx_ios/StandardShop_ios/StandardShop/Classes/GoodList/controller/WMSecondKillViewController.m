//
//  WMSecondKillViewController.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSecondKillViewController.h"
#import "WMSecondKillListCell.h"
#import "WMGoodInfo.h"
#import "WMSecondKillSectionHeaderView.h"
#import "WMSecondKillHeaderView.h"
#import "WMSecondKillInfo.h"
#import "WMGoodListOperation.h"
#import "WMGoodDetailOperation.h"
#import "WMConfirmOrderOperation.h"
#import "WMShopCarOperation.h"
#import "WMConfirmOrderInfo.h"
#import "ConfirmOrderPageController.h"
#import "WMUserInfo.h"
#import "WMGoodDetailContainViewController.h"
#import "WMHomeOperation.h"
#import "WMServerTimeOperation.h"

@interface WMSecondKillViewController ()<SeaNetworkQueueDelegate,WMSecondKillListCellDelegate,WMSecondKillSectionHeaderViewDelegate>

///网络请求
@property(nonatomic,strong) SeaNetworkQueue *queue;

///商品列表信息 数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *goodInfos;

///表头
@property(nonatomic,strong) WMSecondKillHeaderView *header;

///秒杀时区信息 数组元素是 WMSecondKillInfo
@property(nonatomic,strong) NSArray *secondKillInfos;

///秒杀专区广告 数组元素是 WMHomeAdInfo
@property(nonatomic,strong) NSArray *adInfos;

///轮播广告大小
@property(nonatomic,assign) CGSize adSize;

///section 头部
@property(nonatomic,strong) WMSecondKillSectionHeaderView *sectionHeader;

///是否加载失败
@property(nonatomic,assign) BOOL isFailToLoad;

///选中的秒杀
@property(nonatomic,assign) NSInteger selectedIndex;

//选中的商品信息
@property(strong,nonatomic) WMGoodInfo *selectGoodInfo;

///选中的cell
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

///是否是加载商品列表
@property(nonatomic,assign) BOOL isLoadGoodList;

@end

@implementation WMSecondKillViewController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    if(self.secondKillImageURL)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 109, 25)];
        [imageView sea_setImageWithURL:self.secondKillImageURL];
        
        ///不加这个imageView会被自动调整
        UIView *view = [[UIView alloc] initWithFrame:imageView.bounds];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:imageView];
        
        self.navigationItem.titleView = view;
        
    }
    else
    {
        self.title = @"秒杀专区";
    }
    self.backItem = YES;
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    self.queue.shouldCancelAllRequestWhenOneFail = NO;
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStylePlain;
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMSecondKillListCell" bundle:nil] forCellReuseIdentifier:@"WMSecondKillListCell"];
    self.tableView.rowHeight = WMSecondKillListCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    if(self.adInfos.count > 0)
    {
        ///表头
        self.header = [[WMSecondKillHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.adSize.width, self.adSize.height)];
        self.header.rollInfos = self.adInfos;
        self.header.navigationController = self.navigationController;
        self.tableView.tableHeaderView = self.header;
    }

    self.tableView.sea_emptyViewInsets = UIEdgeInsetsMake(WMSecondKillSectionHeaderViewHeight, 0, 0, 0);
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无秒杀商品";
}

#pragma mark- queue

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    self.requesting = NO;
    
    if([identifier isEqualToString:WMShopCarAddIdentifier])
    {
        [self alerBadNetworkMsg:@"加入购物车失败"];
        return;
    }
    
    if([identifier isEqualToString:WMSecondKillGoodSubScribleIdentifier])
    {
        [self alerBadNetworkMsg:@"操作失败"];
        return;
    }
    
    if([identifier isEqualToString:WMSecondKillGoodCancelSubscribleIdentifier])
    {
        [self alerBadNetworkMsg:@"取消提醒失败"];
        return;
    }
    
    if(self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else
    {
        self.isFailToLoad = YES;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMGoodListIdentifier])
    {
        NSDictionary *dic = [WMGoodListOperation secondKillGoodListFromData:data];
        if(dic)
        {
            self.secondKillInfos = [dic objectForKey:@"goods"];
            self.adInfos = [dic objectForKey:@"ads"];
            self.adSize = [[dic objectForKey:@"adSize"] CGSizeValue];
            
            if(self.secondKillInfos.count > 0)
            {
                ///调到指定秒杀场次
                if(self.secondKillId)
                {
                    for(NSInteger i = 0;i < self.secondKillInfos.count;i++)
                    {
                        WMSecondKillInfo *info  = [self.secondKillInfos objectAtIndex:i];
                        if([info.Id isEqualToString:self.secondKillId])
                        {
                            self.selectedIndex = i;
                        }
                    }
                }
                WMSecondKillInfo *info = [self.secondKillInfos objectAtIndex:self.selectedIndex];
                self.goodInfos = info.goodInfos;
            }
        }
        
        return;
    }
    
    self.requesting = NO;
    
    if([identifier isEqualToString:WMShopCarAddIdentifier])
    {
        
        if ([WMShopCarOperation returnAddShopCarResultWithData:data])
        {
            [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMConfirmOrderOperation returnConfirmOrderParamWithIsFastBuy:@"true" selectGoodsArr:@[[NSString stringWithFormat:@"goods_%@_%@",self.selectGoodInfo.goodId,self.selectGoodInfo.productId]]] identifier:WMCheckOutConfirmOrderIdentifier];
        }
    }
    
    if ([identifier isEqualToString:WMCheckOutConfirmOrderIdentifier])
    {
        WMConfirmOrderInfo *info = [WMConfirmOrderOperation returnConfirmOrderResultWithData:data];
        
        if (info)
        {
            ConfirmOrderPageController *confirmOrder = [[ConfirmOrderPageController alloc] init];
            confirmOrder.isFastBuy = @"true";
            confirmOrder.orderInfo = info;
            
            [self.navigationController pushViewController:confirmOrder animated:YES];
        }
        return;
    }
    
    if([identifier isEqualToString:WMServerTimeIdentifer])
    {
        NSTimeInterval time = [WMHomeOperation serverTimeFromData:data];
        if(time != 0)
        {
            [WMServerTimeOperation sharedInstance].time = time;
        }
        return;
    }
    
    if([identifier isEqualToString:WMSecondKillGoodSubScribleIdentifier])
    {
        if([WMGoodListOperation secondKillGoodSubScribleFromData:data])
        {
            self.selectGoodInfo.isSubscribed = YES;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            WMSecondKillInfo *info = [self.secondKillInfos objectAtIndex:self.selectedIndex];
            [self alertMsg:info.remindmMsg];
        }
    }
    
    if([identifier isEqualToString:WMSecondKillGoodCancelSubscribleIdentifier])
    {
        if([WMGoodListOperation secondKillGoodCancelSubscribleFromData:data])
        {
            self.selectGoodInfo.isSubscribed = NO;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            [self alertMsg:@"取消提醒成功"];
        }
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.isFailToLoad)
    {
        [self failToLoadData];
    }
    else if(self.isLoadGoodList)
    {
        self.isLoadGoodList = NO;
        if(self.tableView)
        {
            [self.tableView reloadData];
        }
        else
        {
            [self initialization];
        }
    }
}

- (void)reloadDataFromNetwork
{
    self.isFailToLoad = NO;
    self.loading = YES;
    [self loadSecondKillGoodList];
}

- (void)beginPullUpLoading
{
    if(self.goodInfos.count > 0)
    {
        self.curPage ++;
    }
    [self loadSecondKillGoodList];
}

///加载秒杀商品信息
- (void)loadSecondKillGoodList
{
    self.isLoadGoodList = YES;
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMHomeOperation serverTimeParams] identifier:WMServerTimeIdentifer];
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodListOperation secondKillGoodListWithPageIndex:self.curPage] identifier:WMGoodListIdentifier];
    [self.queue startDownload];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.secondKillInfos.count > 0 ? WMSecondKillSectionHeaderViewHeight : CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ///秒杀时间
    if(!self.sectionHeader && self.secondKillInfos.count > 0)
    {
        self.sectionHeader = [[WMSecondKillSectionHeaderView alloc] initWithInfos:self.secondKillInfos];
        self.sectionHeader.delegate = self;
        self.sectionHeader.selectedIndex = self.selectedIndex;
    }
    
    
    return self.sectionHeader;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSecondKillListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMSecondKillListCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    WMSecondKillInfo *info = [self.secondKillInfos objectAtIndex:self.selectedIndex];
    cell.isBegan = info.isSecondKillBegan;
    cell.isEnd = info.isSecondKillEnded;
    cell.enableSubscrible = info.enableSunscrible;
    cell.info = [self.goodInfos objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMGoodInfo *goodInfo = [self.goodInfos objectAtIndex:indexPath.row];

    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.goodID = goodInfo.goodId;
    detail.productID = goodInfo.productId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark- WMSecondKillListCell delegate

- (void)secondKillListCellDidSubscrible:(WMSecondKillListCell *)cell
{
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    if([AppDelegate instance].isLogin)
    {
        [self subscribleInfo:cell.info];
    }
    else
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
           
            [weakSelf subscribleInfo:cell.info];
        }];
    }
}

///提醒
- (void)subscribleInfo:(WMGoodInfo*) info
{
    self.selectGoodInfo = info;
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    if(info.isSubscribed)
    {
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodListOperation secondKillGoodCancelSubscribleWithProductId:info.productId] identifier:WMSecondKillGoodCancelSubscribleIdentifier];
    }
    else
    {
        WMSecondKillInfo *secondKillInfo = [self.secondKillInfos objectAtIndex:self.selectedIndex];
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodListOperation secondKillGoodSubScribleWithProductId:info.productId secondKillInfo:secondKillInfo] identifier:WMSecondKillGoodSubScribleIdentifier];
    }
    
    [self.queue startDownload];
}

- (void)secondKillListCellDidShop:(WMSecondKillListCell *)cell
{
    self.selectGoodInfo = cell.info;
    
    ///立即购买
    if (![AppDelegate instance].isLogin)
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [weakSelf buyRightnowGoodID:weakSelf.selectGoodInfo.goodId productID:weakSelf.selectGoodInfo.productId];
        }];
    }
    else
    {
        [self buyRightnowGoodID:self.selectGoodInfo.goodId productID:self.selectGoodInfo.productId];
    }
}

///立即购买
- (void)buyRightnowGoodID:(NSString *)goodID productID:(NSString *)productID
{
    self.showNetworkActivity = YES;
    
    self.requesting = YES;
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMShopCarOperation returnAddShopCarParamWithBuyType:@"is_fastbuy" goodsID:goodID productID:productID buyQuantity:1 adjunctIndex:0 adjunctGoodID:nil adjunctGoodQuantity:0 goodType:@"goods"] identifier:WMShopCarAddIdentifier];
    
    [self.queue startDownload];
}

#pragma mark- WMSecondKillSectionHeaderView delegate

///选择某个时区
- (void)secondKillSectionHeaderView:(WMSecondKillSectionHeaderView *)view didSelectInfo:(WMSecondKillInfo *)info
{
    self.selectedIndex = [self.secondKillInfos indexOfObject:info];
    
    self.goodInfos = info.goodInfos;
    [self.tableView reloadData];
    
    if(self.tableView.contentOffset.y > self.adSize.height)
    {
        self.tableView.contentOffset = CGPointMake(0, self.adSize.height);
    }
}

- (void)secondKillSectionHeaderViewCountDownDidEnd:(WMSecondKillSectionHeaderView *)view
{
    [self.tableView reloadData];
}

@end
