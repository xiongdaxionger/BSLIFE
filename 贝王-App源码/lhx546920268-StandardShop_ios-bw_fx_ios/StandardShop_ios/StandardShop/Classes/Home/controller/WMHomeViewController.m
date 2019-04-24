//
//  WMHomeViewController.m
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/13.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMHomeViewController.h"
#import "WMHomeFlashAdCell.h"
#import "WMHomeCategoryCell.h"
#import "WMHomeOperation.h"
#import "WMHomeInfo.h"
#import "WMGoodInfo.h"
#import "WMHomeAdInfo.h"
#import "WMHomeLettersView.h"
#import "WMHomeGoodSecondKillView.h"
#import "SeaCollectionViewFlowFillLayout.h"
#import "WMHomeImageAdCell.h"
#import "WMUserInfo.h"
#import "WMTabBarController.h"
#import "WMHomeGoodListCell.h"
#import "WMHomeSectionHeaderView.h"
#import "WMQRCodeScanViewController.h"
#import "WMNavigationBarRedPointButton.h"
#import "WMSearchController.h"
#import "WMGoodListViewController.h"
#import "WMMessageCenterViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMShopCarOperation.h"
#import "WMServerTimeOperation.h"
#import "WMHomeSectionFooterView.h"
#import "WMCustomerServicePhoneInfo.h"
#import "WMHomeAdDialog.h"
#import "WMHomeDialogAdInfo.h"
#import "WMLocationManager.h"

@interface WMHomeViewController ()
<SeaNetworkQueueDelegate,
SeaCollectionViewFlowFillLayoutDelegate,
WMHomeGoodSecondKillViewDelegate>

///网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

///是否加载失败
@property(nonatomic,assign) BOOL isFailToLoad;

///是否是加载商品列表
@property(nonatomic,assign) BOOL isLoadGoodList;

///消息按钮
@property(nonatomic,strong) WMNavigationBarRedPointButton *message_btn;

///搜索控制器
@property(nonatomic,strong) WMSearchController *searchController;

///轮播广告高度
@property(nonatomic,assign) CGFloat adHeight;

///弹窗广告数据
@property (strong,nonatomic) WMHomeDialogAdInfo *adInfo;

@end


@implementation WMHomeViewController

- (instancetype)init
{
    SeaCollectionViewFlowFillLayout *layout = [[SeaCollectionViewFlowFillLayout alloc] init];
    
    self = [super initWithFlowLayout:layout];
    if(self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.collectionView)
    {
        [self scrollViewDidScroll:self.collectionView];
    }
    
    ///消息红点
    if([AppDelegate instance].isLogin)
    {
        WMUserInfo *info = [WMUserInfo sharedUserInfo];
        self.message_btn.redPoint.hidden = info.personCenterInfo.unreadMessageCount == 0;
    }
    else
    {
        self.message_btn.redPoint.hidden = YES;
    }
    
    ///启动轮播广告
    NSArray *cells = [self.collectionView visibleCells];
    for(WMHomeFlashAdCell *cell in cells)
    {
        if([cell isKindOfClass:[WMHomeFlashAdCell class]])
        {
            [cell.adScrollView startAnimate];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.requesting = NO;
    [[WMCustomerServicePhoneInfo shareInstance] cancel];
    
    ///停止轮播广告
    NSArray *cells = [self.collectionView visibleCells];
    for(WMHomeFlashAdCell *cell in cells)
    {
        if([cell isKindOfClass:[WMHomeFlashAdCell class]])
        {
            [cell.adScrollView stopAnimate];
        }
    }
    
    self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WMCustomerServicePhoneInfo shareInstance] loadInfoWithCompletion:nil];
    
    self.adHeight = WMHomeFlashAdCellSize.height;
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.infos = [NSMutableArray array];
    
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    self.queue.shouldCancelAllRequestWhenOneFail = NO;
    
    ///监听登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:WMLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:WMUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAutoLoginDidFail:) name:WMUserAutoLoginDidFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidGet:) name:WMUserInfoDidGetNotification object:nil];

    ///设置导航栏
    [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"qrcode_icon"] action:@selector(qrCode) position:SeaNavigationItemPositionLeft];

    ///拨打客服电话
//    [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"phone_icon"] action:@selector(callCustomerService) position:SeaNavigationItemPositionLeft];
    
    ///消息
    self.message_btn = [[WMNavigationBarRedPointButton alloc] initWithImage:[UIImage imageNamed:@"message_icon"]];
    [self.message_btn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBarItemWithCustomView:self.message_btn position:SeaNavigationItemPositionRight];

    ///搜索栏
    self.searchController = [[WMSearchController alloc] initWithViewController:self];

    WeakSelf(self);
    
    self.searchController.searchDidBeginHandler = ^(void){
        
        [weakSelf setNavigationBarAlpha:1.0];
        [weakSelf.navigationController sea_restoreNavigationBar];
        weakSelf.searchController.alpha = 1.0;
    };
    
    self.searchController.searchHandler = ^(NSString *searchKey){

        WMGoodListViewController *list = [[WMGoodListViewController alloc] init];
        list.titleName = searchKey;
        list.searchKey = searchKey;
        [weakSelf pushViewController:list];
    };

    self.searchController.searchDidEndHandler = ^(void){

            [weakSelf setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"qrcode_icon"] action:@selector(qrCode) position:SeaNavigationItemPositionLeft];
        [weakSelf setBarItemWithCustomView:weakSelf.message_btn position:SeaNavigationItemPositionRight];
        
        if(weakSelf.scrollView)
        {
            [weakSelf.navigationController sea_openNavigationBarAlpha];
            [weakSelf scrollViewDidScroll:weakSelf.scrollView];
        }
    };

    self.loading = YES;
    if(![WMUserInfo isOnceLogin])
    {
        [self loadInfo];
    }
    
    ///定位
    [[WMLocationManager sharedInstance] startLocation];
    
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
    self.loadingIndicator.height = _height_ - self.tabBarHeight - self.navigationBarHeight - self.statusBarHeight;
}

- (CGFloat)contentHeight
{
    return _height_ - self.tabBarHeight;
}

- (void)initialization
{
    self.loading = NO;
    [self.navigationController sea_openNavigationBarAlpha];
    [self scrollViewDidScroll:self.scrollView];
    
    SeaCollectionViewFlowFillLayout *layout = (SeaCollectionViewFlowFillLayout*)self.layout;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0;
    layout.sectionFooterItemSpace = 0;
    layout.sectionHeaderItemSpace = 0;
    
    [super initialization];
    
    [self.collectionView registerClass:[WMHomeFlashAdCell class] forCellWithReuseIdentifier:@"WMHomeFlashAdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeCategoryCell"];
    
    [self.collectionView registerClass:[WMHomeLettersView class] forCellWithReuseIdentifier:@"WMHomeLettersView"];
    [self.collectionView registerClass:[WMHomeGoodSecondKillView class] forCellWithReuseIdentifier:@"WMHomeGoodSecondKillView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeImageAdCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeImageAdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeGoodListCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeGoodListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMHomeSectionHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeSectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMHomeSectionFooterView"];
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    self.enableDropDown = YES;
//    self.enablePullUp = YES;
}

#pragma mark- public method

///获取秒杀图
+ (NSString*)secondKillImageURL
{
    WMHomeViewController *home = [[AppDelegate tabBarController].viewControllers firstObject];
    if([home isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)home;
        home = (WMHomeViewController*)[nav.viewControllers firstObject];
    }
    
    for(WMHomeInfo *info in home.infos)
    {
        if(info.type == WMHomeInfoTypeGoodSecondKill)
        {
            WMHomeSecondKillInfo *secondKillInfo = [info.infos firstObject];
            
            return secondKillInfo.imageURL;
        }
    }
    
    return nil;
}

#pragma mark- touch

///点击导航栏消息按钮
- (void)messageAction
{
    if([AppDelegate instance].isLogin)
    {
        [self seeMessage];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){

            [self seeMessage];
        }];
    }
}

///查看消息
- (void)seeMessage
{
    WMMessageCenterViewController *msg = [[WMMessageCenterViewController alloc] init];
    [self pushViewController:msg];
}

///二维码扫描
- (void)qrCode
{
    WMQRCodeScanViewController *qrCode = [[WMQRCodeScanViewController alloc] init];
    [self pushViewController:qrCode];
}

///拨打客服电话
- (void)callCustomerService
{
    if([WMCustomerServicePhoneInfo shareInstance].loading)
        return;
    NSString *phone = [WMCustomerServicePhoneInfo shareInstance].call;
    if([NSString isEmpty:phone]){
        
        WeakSelf(self);
        self.showNetworkActivity = YES;
        self.requesting = YES;
        [[WMCustomerServicePhoneInfo shareInstance] loadInfoWithCompletion:^(void){
           
            weakSelf.requesting = NO;
            makePhoneCall([WMCustomerServicePhoneInfo shareInstance].call, YES);
        }];
        
    }else{
        
        makePhoneCall(phone, YES);
    }
}

#pragma mark- 通知

///登录成功
- (void)userDidLogin:(NSNotification*) notification
{
    [self loadInfo];
}

///退出登录
- (void)userDidLogout:(NSNotification*) notification
{
    [self loadInfo];
    self.message_btn.redPoint.hidden = YES;
}

///自动登录失败
- (void)userAutoLoginDidFail:(NSNotification*) notification
{
    ///UI还没有创建，并且不是加载失败
    if(!self.collectionView && !self.loadDidFail)
    {
        [self loadInfo];
    }
}

///获取个人信息
- (void)userInfoDidGet:(NSNotification*) notification
{
    WMUserInfo *info = [WMUserInfo sharedUserInfo];
    
    self.message_btn.redPoint.hidden = info.personCenterInfo.unreadMessageCount == 0;
}

#pragma mark- http

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.isLoadGoodList)
    {
        self.isLoadGoodList = NO;
        return;
    }
    
    if(!self.isFailToLoad)
    {
        if(self.refreshing)
        {
            self.curPage = WMHttpPageIndexStartingValue;
        }
    }
    
    //设置广告高度，用于导航栏透明计算
    if(self.infos.count > 0)
    {
        WMHomeInfo *info = [self.infos firstObject];
        if(info.type == WMHomeInfoTypeFlashAd)
        {
            self.adHeight = info.size.height;
        }
        else
        {
            self.adHeight = WMHomeFlashAdCellSize.height;
        }
    }
    
    if (self.adInfo != nil && self.adInfo.needShowAd && self.adInfo.isOpenSetting) {
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(time) forKey:WMHomeDialogTime];
        
        WMHomeAdDialog *adDialog = [WMHomeAdDialog new];
        
        [adDialog.adImageView sea_setImageWithURL:self.adInfo.adInfo.imageURL];
        
        WeakSelf(self);
        
        [adDialog setTapCallBack:^{
            
            [weakSelf pushViewController:[weakSelf.adInfo.adInfo viewController]];
        }];
        
        [adDialog show];
    }
    
    if(self.infos.count == 0 && self.isFailToLoad)
    {
        [self failToLoadData];
    }
    else if(!self.collectionView)
    {
        [self initialization];
    }
    else
    {
        [self endDropDownRefreshWithMsg:nil];
        [self.collectionView reloadData];
    }
}

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMHomeInfosIdentifier])
    {
        self.isFailToLoad = YES;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMHomeInfosIdentifier])
    {
        NSMutableArray *infos = [WMHomeOperation homeInfosFromData:data];
        if(infos.count)
        {
            self.infos = infos;
        }
        
        return;
    }
    
    if ([identifier isEqualToString:WMHomeDialogAdIdentifier]) {
        
        self.adInfo = [WMHomeOperation parseAdDialogInfoWithData:data];
        
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
}

//加载首页数据
- (void)loadInfo
{
    self.isFailToLoad = NO;
    
//    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMHomeOperation serverTimeParams] identifier:WMServerTimeIdentifer];
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMHomeOperation homeInfosParams] identifier:WMHomeInfosIdentifier];
    
    NSInteger time = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:WMHomeDialogTime]).integerValue;
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMHomeOperation homeAdDialogParam:time] identifier:WMHomeDialogAdIdentifier];
    
    [self.queue startDownload];
}

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

#pragma mark- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [self.navigationController setNavigationBarHidden:scrollView.contentOffset.y < 0];
    
    CGFloat height = self.navigationBarHeight + self.statusBarHeight;
    CGFloat y = MAX(scrollView.contentOffset.y - self.adHeight + height, 0);
    CGFloat alpha = y / height;
    [self setNavigationBarAlpha:alpha];
}

///导航栏透明度改变
- (void)setNavigationBarAlpha:(CGFloat) alpha
{
    [self.navigationController sea_setNavigationBarAlpha:alpha];
    if(alpha >= 0.3)
    {
        self.searchController.alpha = 1.0;
        self.iconTintColor = WMTintColor;
        self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
    }
    else
    {
        self.searchController.alpha = 0.65;
        self.iconTintColor = [UIColor whiteColor];
        self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
    }
}

#pragma mark- UICollectionView 大小和间距

- (CGSize)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout itemSizeForIndexPath:(NSIndexPath *)indexPath
{
    WMHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
 
    switch (info.type) {
        case WMHomeInfoTypeHomeCatgory :
        {
            return WMHomeCategoryCellSize;
        }
            break;
        case WMHomeInfoTypeImageAd :
        {
            WMHomeAdInfo *adInfo = [info.infos objectAtIndex:indexPath.item];
            return adInfo.itemSize;
        }
            break;
        case WMHomeInfoTypeLetters :
        {
            return WMHomeLettersViewSize;
        }
            break;
        case WMHomeInfoTypeGoodSecondKill :
        {
            return WMHomeGoodSecondKillViewSize;
        }
            break;
        case WMHomeInfoTypeGoodList :
        {
            return WMHomeGoodListCellSize;
        }
            break;
        case WMHomeInfoTypeFlashAd :
        {
            return info.size;
        }
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}

- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout sectionHeaderHeightAtSection:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];

    if(info.shouldDisplayTitle)
    {
        return WMHomeSectionHeaderViewHeight;
    }
    else if(info.shouldDisplaySeparator)
    {
        return _separatorLineWidth_;
    }

    return 0;
}

- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout sectionFooterHeightAtSection:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];
    
    if(info.shouldDisplayFooter)
    {
        return WMHomeSectionFooterViewHeight;
    }
    
    return 0;
}

- (UIEdgeInsets)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout insetForSectionAtIndex:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];
    switch (info.type) {
        
        case WMHomeInfoTypeLetters :
        case WMHomeInfoTypeGoodSecondKill :
        {
//            if(section + 1 < self.infos.count)
//            {
//                WMHomeInfo *nextInfo = [self.infos objectAtIndex:section + 1];
//                if(nextInfo.type == WMHomeInfoTypeLetters || nextInfo.type == WMHomeInfoTypeGoodSecondKill)
//                {
//                    return UIEdgeInsetsMake(10.0, 0, 0.0, 0);
//                }
//            }
            
            return UIEdgeInsetsMake(0, 0, 10.0, 0);
        }
            break;
        case WMHomeInfoTypeGoodList :
        {
            return UIEdgeInsetsMake(WMHomeGoodListCellInterval, WMHomeGoodListCellInterval, WMHomeGoodListCellInterval, WMHomeGoodListCellInterval);
        }
            break;
        default:
            break;
    }
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];
    return info.minimumLineSpacing;
}

- (CGFloat)collectionViewFlowFillLayout:(SeaCollectionViewFlowFillLayout *)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];
    return info.minimumInteritemSpacing;
}

#pragma mark- UICollectionView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.infos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMHomeInfo *info = [self.infos objectAtIndex:section];
    return info.numberOfCells;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WMHomeInfo *info = [self.infos objectAtIndex:indexPath.section];

    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        WMHomeSectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMHomeSectionFooterView" forIndexPath:indexPath];
        return footer;
    }
    else
    {
        WMHomeSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMHomeSectionHeaderView" forIndexPath:indexPath];
        header.info = info;
        
        return header;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeFlashAdCell *cell1 = (WMHomeFlashAdCell*)cell;
    if([cell1 isKindOfClass:[WMHomeFlashAdCell class]])
    {
        [cell1.adScrollView startAnimate];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeFlashAdCell *cell1 = (WMHomeFlashAdCell*)cell;
    if([cell1 isKindOfClass:[WMHomeFlashAdCell class]])
    {
        [cell1.adScrollView stopAnimate];
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
 
    switch (info.type)
    {
        case WMHomeInfoTypeHomeCatgory :
        {
            WMHomeCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeCategoryCell" forIndexPath:indexPath];
            cell.info = [info.infos objectAtIndex:indexPath.item];
            
            return cell;
        }
            break;
        case WMHomeInfoTypeGoodSecondKill :
        {
            WMHomeGoodSecondKillView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeGoodSecondKillView" forIndexPath:indexPath];
            cell.delegate = self;
            cell.navigationController = self.navigationController;
            cell.info = [info.infos objectAtIndex:indexPath.item];
            
            return cell;
        }
            break;
        case WMHomeInfoTypeLetters :
        {
            WMHomeLettersView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeLettersView" forIndexPath:indexPath];

            cell.navigationController = self.navigationController;
            cell.info = info;
            
            return cell;
        }
            break;
        case WMHomeInfoTypeImageAd :
        {
            WMHomeImageAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeImageAdCell" forIndexPath:indexPath];
            cell.info = [info.infos objectAtIndex:indexPath.item];
            
            return cell;
        }
            break;
        case WMHomeInfoTypeGoodList :
        {
            WMHomeGoodListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeGoodListCell" forIndexPath:indexPath];
            cell.info = [info.infos objectAtIndex:indexPath.item];
            
            return cell;
        }
            break;
        case WMHomeInfoTypeFlashAd :
        {
            WMHomeFlashAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeFlashAdCell" forIndexPath:indexPath];
            cell.rollInfos = info.infos;
            cell.navigationController = self.navigationController;
            return cell;
        }
            break;
        default :
            break;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    WMHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMHomeInfoTypeImageAd :
        case WMHomeInfoTypeHomeCatgory :
        {
            [self dealWithHomeAdInfo:[info.infos objectAtIndex:indexPath.item]];
        }
            break;
        case WMHomeInfoTypeGoodList :
        {
            WMGoodInfo *goodInfo = [info.infos objectAtIndex:indexPath.item];
            WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
            detail.productID = goodInfo.productId;
            detail.goodID = goodInfo.goodId;
            [self pushViewController:detail];
        }
            break;
        default:
            break;
    }
}

#pragma mark- WMHomeGoodSecondKillView delegate

- (void)homeGoodSecondKillViewDidEnd:(WMHomeGoodSecondKillView *)view
{
    ///秒杀结束了
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:view];
    if(indexPath)
    {
        WMHomeInfo *info = [self.infos objectAtIndex:indexPath.section];
        if(info.type == WMHomeInfoTypeGoodSecondKill)
        {
            [self.infos removeObjectAtIndex:indexPath.section];
            [self.collectionView reloadData];
        }
    }
}

/**
 *  处理点击广告事件
 */
- (void)dealWithHomeAdInfo:(WMHomeAdInfo*) info
{
    UIViewController *vc = info.viewController;
    if(vc)
    {
        [self pushViewController:vc];
    }
}

///push
- (void)pushViewController:(UIViewController*) vc
{
    [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:[AppDelegate rootViewController]];
}

@end
