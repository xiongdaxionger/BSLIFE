//
//  WMMeViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMMeViewController.h"
#import "WMCustomerServiceViewController.h"
#import "WMRefundViewController.h"
#import "WMDistributionViewController.h"
#import "WMSettingPageViewController.h"
#import "WMMeOrderInfoFooter.h"
#import "WMMeHeaderView.h"
#import "WMMeListInfo.h"
#import "WMMeFuncCell.h"
#import "WMUserInfo.h"
#import "WMMeInfo.h"
#import "WMMyIntegralViewController.h"
#import "WMMeOtherInfoFooter.h"
#import "WMFeedBackPageController.h"
#import "WMShakeViewController.h"
#import "WMShippingAddressListViewController.h"
#import "WMOrderCenterViewController.h"
#import "WMNavigationBarRedPointButton.h"
#import "WMHelpCenterViewController.h"
#import "WMActivityListViewController.h"
#import "WMBalanceViewController.h"
#import "WMBindPhoneNumberViewController.h"
#import "WMRefundViewController.h"
#import "WMMessageCenterViewController.h"
#import "WMUserOperation.h"
#import "WMShopCarOperation.h"
#import "WMTabBarController.h"
#import "WMMeHeaderFooterView.h"
#import "WMGoodBrowseHistoryViewController.h"
#import "WMGoodCollectListViewController.h"
#import "WMDrawCouponsViewController.h"
#import "WMMeBindPhoneCell.h"
#import "WMBrowseHistoryDataBase.h"
#import "WMPartnerListViewController.h"
#import "WMStatisticalViewController.h"
#import "WMCollectMoneyViewController.h"
#import "WMStoreToJoinViewController.h"
#import "WMGoodsAccessRecordViewController.h"

@interface WMMeViewController ()<SeaNetworkQueueDelegate>

///列表信息 数组元素是 WMMeInfo
@property(nonatomic,strong) NSMutableArray *infos;

///顶部背景
@property(nonatomic,strong) UIView *headerBackgroundView;

///网络请求
@property(nonatomic,strong) SeaNetworkQueue *queue;

///拨打电话
@property(nonatomic,strong) UIWebView *calloutWebView;

///消息按钮
@property(nonatomic,strong) WMNavigationBarRedPointButton *message_btn;

///我的足迹数量
@property(nonatomic,assign) int historyBrowseCount;

@end

@implementation WMMeViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.shouldChangeStatusBarStyle = YES;
        ///监听登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:WMLoginSuccessNotification object:nil];
        self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
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
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
    self.shouldChangeStatusBarStyle = YES;
    
    if([AppDelegate instance].isLogin)
    {
        
        [self loadUserInfo];
    }
    
    [self reladData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(self.shouldChangeStatusBarStyle)
    {
        self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.message_btn = [[WMNavigationBarRedPointButton alloc] initWithImage:[UIImage imageNamed:@"message_icon"]];
    [self.message_btn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [self barButtonItemWithTitle:nil icon:[UIImage imageNamed:@"me_setting"] action:@selector(settings:)];
    item1.customView.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:self.message_btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 20.0;
    
    [self setBarItems:[NSArray arrayWithObjects:item2, spaceItem, item1, nil] position:SeaNavigationItemPositionRight];

    [self setupNavigationBarWithBackgroundColor:[UIColor colorFromHexadecimal:@"FF4444"] titleColor:[UIColor whiteColor] titleFont:nil];
    self.iconTintColor = [UIColor whiteColor];
    [self.navigationController sea_openNavigationBarAlpha];
    [self scrollViewDidScroll:self.scrollView];
    
    self.navigationItem.title = @"";
    self.infos = [WMMeInfo meInfos];
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;

    ///监听个人信息改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidModify:) name:WMUserInfoDidModifyNotification object:nil];
    
    ///退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:WMUserDidLogoutNotification object:nil];
    
    [self initialization];
}

- (void)initialization
{
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    [super initialization];
    
    [self.collectionView registerClass:[WMMeFuncIconCell class] forCellWithReuseIdentifier:@"WMMeFuncIconCell"];
    [self.collectionView registerClass:[WMMeFuncTextCell class] forCellWithReuseIdentifier:@"WMMeFuncTextCell"];
    [self.collectionView registerClass:[WMMeBindPhoneCell class] forCellWithReuseIdentifier:@"WMMeBindPhoneCell"];
    [self.collectionView registerClass:[WMMeOrderInfoFooter class] forCellWithReuseIdentifier:@"WMMeOrderInfoFooter"];
    [self.collectionView registerClass:[WMMeOtherInfoFooter class] forCellWithReuseIdentifier:@"WMMeOtherInfoFooter"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMMeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMMeHeaderView"];
    [self.collectionView registerClass:[WMMeHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMMeHeaderFooterView"];
    [self.collectionView registerClass:[WMMeHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMMeHeaderFooterView"];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -_height_ + 5.0, _width_, _height_)];
    self.headerBackgroundView.userInteractionEnabled = NO;
    self.headerBackgroundView.backgroundColor = [UIColor colorFromHexadecimal:@"FF4444"];
    [self.collectionView addSubview:self.headerBackgroundView];
    self.collectionView.height = _height_ - self.tabBarHeight;

    self.collectionView.showsVerticalScrollIndicator = NO;

    [self reladData];
}

#pragma mark- private method

///刷新数据
- (void)reladData
{
    if(!self.collectionView)
        return;
    
    self.historyBrowseCount = [WMBrowseHistoryDataBase browseHistoryCount];
    
    if([AppDelegate instance].isLogin)
    {
        WMUserInfo *info = [WMUserInfo sharedUserInfo];
        self.message_btn.redPoint.hidden = info.personCenterInfo.unreadMessageCount == 0;

    }
    else
    {
        self.message_btn.redPoint.hidden = YES;
    }
    
    [self scrollViewDidScroll:self.collectionView];
    
    ///不全局reloadData，防止出现不必要的动画
//    [self.collectionView reloadData];
//    [UIView setAnimationsEnabled:NO];
//    [self.collectionView performBatchUpdates:^(void){
//        
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.infos.count - 1)]];
//        WMMeInfo *info = [self.infos lastObject];
//        
//        NSInteger count = 2;
//        if(info.infos.count >= count)
//        {
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:count];
//            for(NSInteger i = 0;i < count;i ++)
//            {
//                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:self.infos.count - 1]];
//            }
//            [self.collectionView reloadItemsAtIndexPaths:indexPaths];
//        }
//        
//    }completion:^(BOOL finish){
//        
//        [UIView setAnimationsEnabled:YES];
//    }];

    [self updateRows];
}

///插入绑定手机号section
- (void)insertBindPhoneNumberSection
{
    if(!self.infos)
        return;
    WMMeInfo *info = [self.infos objectAtIndex:[self bindPhoneSection]];
    if(info.type != WMMeInfoTypeBindPhone)
    {
        [self.infos insertObject:[WMMeInfo infoWithType:WMMeInfoTypeBindPhone] atIndex:[self bindPhoneSection]];
        info = [self.infos objectAtIndex:[self bindPhoneSection] + 1];
        info.topLine = YES;

        [self.collectionView reloadData];
//        [self.collectionView performBatchUpdates:^(void){
//            
//            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[self bindPhoneSection]]];
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[self bindPhoneSection] + 1]];
//        }completion:^(BOOL finish){
//            
//        }];
    }
}

///移除绑定手机号section
- (void)removeBindPhoneNumberSection
{
    if(!self.infos)
        return;
    WMMeInfo *info = [self.infos objectAtIndex:[self bindPhoneSection]];
    if(info.type == WMMeInfoTypeBindPhone)
    {
        [self.infos removeObjectAtIndex:[self bindPhoneSection]];
        info = [self.infos objectAtIndex:[self bindPhoneSection]];
        info.topLine = NO;

        [self.collectionView reloadData];
    }
}

///绑定手机section
- (NSInteger)bindPhoneSection
{
    return 1;
}

///获取对应类型的section
- (NSInteger)sectionForType:(WMMeInfoType) type
{
    for(NSInteger i = 0;i < self.infos.count;i ++)
    {
        WMMeInfo *info = [self.infos objectAtIndex:i];
        if(info.type == type)
            return i;
    }
    
    return NSNotFound;
}

///更新分销和预售
- (void)updateRows
{
    if(!self.infos)
        return;
//    BOOL change = NO;
    
//    WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
    
    NSInteger index = [self sectionForType:WMMeInfoTypeFunc];
    
    WMMeInfo *info = [self.infos objectAtIndex:index];
    info.infos = [WMMeListInfo meListInfos];
//    change = YES;
    [self.collectionView reloadData];
    
//    WMMeListInfo *listInfo = [info.infos objectAtIndex:2];
//    ///预售
//    if([AppDelegate instance].isLogin && userInfo.personCenterInfo.openPresell)
//    {
//        if(listInfo.type != WMMeListInfoTypPresellOrder)
//        {
//            listInfo = [WMMeListInfo infoWithType:WMMeListInfoTypPresellOrder];
//            [info.infos insertObject:listInfo atIndex:2];
//            change = YES;
//        }
//    }
//    else
//    {
//        if(listInfo.type == WMMeListInfoTypPresellOrder)
//        {
//            [info.infos removeObjectAtIndex:2];
//            change = YES;
//        }
//    }
    

//    if(change)
//    {
        ///不全局reloadData，防止出现不必要的动画
//        [UIView setAnimationsEnabled:NO];
//        [self.collectionView performBatchUpdates:^(void){
//            
//            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
//            
//        }completion:^(BOOL finish){
//            
//            [UIView setAnimationsEnabled:YES];
//        }];
//    }
}

///查看消息
- (void)messageAction:(id) sender
{
    if([AppDelegate instance].isLogin)
    {
        [self seeMessage];
    }
    else
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [weakSelf seeMessage];
        }];
    }
}

///查看消息
- (void)seeMessage
{
    WMMessageCenterViewController *msg = [[WMMessageCenterViewController alloc] init];
    [SeaPresentTransitionDelegate pushViewController:msg useNavigationBar:YES parentedViewConttroller:self];
}

///设置
- (void)settings:(id) sender
{
    WMSettingPageViewController *setting = [[WMSettingPageViewController alloc] init];
    [SeaPresentTransitionDelegate pushViewController:setting useNavigationBar:YES parentedViewConttroller:self];
}

#pragma mark- 通知

///用户登录
- (void)userDidLogin:(NSNotification*) notification
{
    [self loadUserInfo];
}

///用户信息改变
- (void)userInfoDidModify:(NSNotification*) notification
{
    [self reladData];
    ///绑定手机号
    if([AppDelegate instance].isLogin && [NSString isEmpty:[WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber])
    {
        [self insertBindPhoneNumberSection];
    }
    else
    {
        [self removeBindPhoneNumberSection];
    }
}

///退出登录
- (void)userDidLogout:(NSNotification*) notification
{
    [self reladData];
    
    [self removeBindPhoneNumberSection];
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMGetUserInfoIdentifier])
    {
        
        [WMUserOperation userInfoFromData:data];
        
        [WMShopCarOperation updateShopCarNumberQuantity:0 needChange:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WMUserInfoDidGetNotification object:self];
        
        [self reladData];
        
        return;
    }
    
    if([identifier isEqualToString:WMAccountSecurityIdentifier])
    {
        if([WMUserOperation accountSecurityInfoFromData:data])
        {
            ///绑定手机号
            if([AppDelegate instance].isLogin && [NSString isEmpty:[WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber])
            {
                [self insertBindPhoneNumberSection];
            }
            else
            {
                [self removeBindPhoneNumberSection];
            }
        }
        return;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

///加载登录用户的信息
- (void)loadUserInfo
{
    if (![AppDelegate instance].isLogin)
    {
        return;
    }
    
    ///查看是否已绑定手机号
    if([NSString isEmpty:[WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber])
    {
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMUserOperation accountSecurityParams] identifier:WMAccountSecurityIdentifier];
    }
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMUserOperation userInfoParams] identifier:WMGetUserInfoIdentifier];
    [self.queue startDownload];
}

#pragma mark- UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = self.navigationBarHeight + self.statusBarHeight;
    CGFloat y = MAX(scrollView.contentOffset.y - WMMeHeaderViewHeight + height, 0);
    CGFloat alpha = y / height;
    [self.navigationController sea_setNavigationBarAlpha:alpha];
}

#pragma mark- UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.infos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WMMeInfo *info = [self.infos objectAtIndex:section];
    
    return info.items;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMMeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMMeInfoTypeOrder :
        {
            return CGSizeMake(_width_, WMMeOrderInfoFooterHeight);
        }
            break;
        case WMMeInfoTypeAssets :
        {
            return CGSizeMake(_width_, WMMeOtherInfoFooterHeight);
        }
            break;
        case WMMeInfoTypeFunc :
        {
            return [WMMeFuncCell sizeForIndex:indexPath.item];
        }
            break;
        case WMMeInfoTypeBindPhone :
        {
            return WMMeBindPhoneCellSize;
        }
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    WMMeInfo *info = [self.infos objectAtIndex:section];
    
    if(info.bottomLine)
    {
        return CGSizeMake(_width_, info.bottomLineHeight);
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    WMMeInfo *info = [self.infos objectAtIndex:section];
    
    switch (info.type)
    {
        case WMMeInfoTypeLogin :
        {
            return CGSizeMake(_width_, WMMeHeaderViewHeight);
        }
            break;
        default:
        {
            if(info.topLine)
            {
                return CGSizeMake(_width_, info.topLineHeight);
            }
        }
            break;
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WMMeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMMeInfoTypeLogin :
        {
            WMMeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMMeHeaderView" forIndexPath:indexPath];
            header.navigationController = self.navigationController;
            [header reloadData];
            
            return header;
        }
            break;
        default:
        {
            if(info.topLine || info.bottomLine)
            {
                WMMeHeaderFooterView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMMeHeaderFooterView" forIndexPath:indexPath];
                return header;
            }
        }
            break;
    }
    
    return nil;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMMeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMMeInfoTypeOrder :
        {
            WMMeOrderInfoFooter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMMeOrderInfoFooter" forIndexPath:indexPath];
            cell.navigationController = self.navigationController;
            [cell reloadData];
            
            return cell;
        }
            break;
        case WMMeInfoTypeAssets :
        {
            WMMeOtherInfoFooter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMMeOtherInfoFooter" forIndexPath:indexPath];
            cell.meViewController = self;
            [cell reloadData];
            
            return cell;
        }
            break;
        case WMMeInfoTypeFunc :
        {
            WMMeListInfo *listInfo = [info.infos objectAtNotBeyondIndex:indexPath.item];
            
            switch (listInfo.type)
            {
                case WMMeListInfoTypHistory :
                {
                    listInfo.subtitle = [NSString stringWithFormat:@"%d", self.historyBrowseCount];
                }
                    break;
                case WMMeListInfoTypCollect :
                {
                    listInfo.subtitle = [NSString stringWithFormat:@"%d", [WMUserInfo sharedUserInfo].personCenterInfo.goodCollectCount];
                }
                    break;
                case WMMeListInfoTypAccess :
                {
                    listInfo.subtitle = [NSString stringWithFormat:@"%d", [WMUserInfo sharedUserInfo].personCenterInfo.goodAccessCount];
                }
                    break;
                default:
                    break;
            }
            
            
            WMMeFuncCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString isEmpty:listInfo.subtitle] ? @"WMMeFuncIconCell" : @"WMMeFuncTextCell" forIndexPath:indexPath];
            cell.info = listInfo;
            cell.position = [WMMeFuncCell positionFromIndex:indexPath.item itemCount:info.items];
            
            return cell;
        }
            break;
        case WMMeInfoTypeBindPhone :
        {
            WMMeBindPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMMeBindPhoneCell" forIndexPath:indexPath];
            cell.title_label.text = info.title;
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMMeInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (info.type)
    {
        case WMMeInfoTypeFunc :
        {
            WMMeListInfo *listInfo = [info.infos objectAtNotBeyondIndex:indexPath.item];
            if(!listInfo)
                return;
            
            switch (listInfo.type)
            {
                case WMMeListInfoTypActivity :
                case WMMeListInfoTypHelpCenter :
                case WMMeListInfoTypHistory :
                case WMMeListInfoTypJoinIn :
                {
                    [self selectInfo:listInfo];
                }
                    break;
                default:
                {
                    if(![AppDelegate instance].isLogin)
                    {
                        WeakSelf(self);
                        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                            
                            [weakSelf selectInfo:listInfo];
                        }];
                    }
                    else
                    {
                        [self selectInfo:listInfo];
                    }
                }
                    break;
            }
        }
            break;
        case WMMeInfoTypeBindPhone :
        {
            WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
            [SeaPresentTransitionDelegate pushViewController:bind useNavigationBar:YES parentedViewConttroller:self];
        }
            break;
        default:
            break;
    }
}

///选择某个
- (void)selectInfo:(WMMeListInfo*) info
{
    UIViewController *vc = nil;
    switch (info.type)
    {
        case WMMeListInfoTypFeedback :
        {
            WMFeedBackPageController *feedBack = [[WMFeedBackPageController alloc] init];
            vc = feedBack;
        }
            break;
        case WMMeListInfoTypShippingAddress :
        {
            WMShippingAddressListViewController *address = [[WMShippingAddressListViewController alloc] init];
            address.memberID = [[WMUserInfo sharedUserInfo] userId];
            vc = address;
        }
            break;
        case WMMeListInfoTypActivity :
        {
            WMActivityListViewController *activity = [[WMActivityListViewController alloc] init];
            vc = activity;
        }
            break;
        case WMMeListInfoTypHelpCenter :
        {
            WMHelpCenterViewController *help = [[WMHelpCenterViewController alloc] init];
            help.hidesBottomBarWhenPushed = YES;
            vc = help;
        }
            break;
        case WMMeListInfoTypRefundService :
        {
            WMRefundViewController *refund = [WMRefundViewController new];
            
            vc = refund;
        }
            break;
        case WMMeListInfoTypPresellOrder :
        {
            WMOrderCenterViewController *order = [[WMOrderCenterViewController alloc] init];
            
            order.hidesBottomBarWhenPushed = YES;
            
            order.isSinglePrepare = YES;
            
            vc = order;
        }
            break;
        case WMMeListInfoTypCollect :
        {
            WMGoodCollectListViewController *list = [[WMGoodCollectListViewController alloc] init];
            vc = list;
        }
            break;
        case WMMeListInfoTypHistory :
        {
            WMGoodBrowseHistoryViewController *history = [[WMGoodBrowseHistoryViewController alloc] init];
            vc = history;
        }
            break;
        case WMMeListInfoTypDrawCoupons :
        {
            WMDrawCouponsViewController *draw = [[WMDrawCouponsViewController alloc] init];
            vc = draw;
        }
            break;
        case WMMeListInfoTypeService :
        {
            WMCustomerServiceViewController *customer = [WMCustomerServiceViewController new];
            vc = customer;
        }
            break;
        case WMMeListInfoTypJoinIn :
        {
            WMStoreToJoinViewController *join = [[WMStoreToJoinViewController alloc] init];
            join.title = info.title;
            vc = join;
        }
            break;
        case WMMeListInfoTypStatistical :
        {
            WMStatisticalViewController *statistical = [[WMStatisticalViewController alloc] init];
            vc = statistical;
        }
            break;
        case WMMeListInfoTypCollectMoney :
        {
            WMCollectMoneyViewController *collect = [[WMCollectMoneyViewController alloc] init];
            vc = collect;
        }
            break;
        case WMMeListInfoTypMyCumstomer :
        {
            WMPartnerListViewController *partner = [[WMPartnerListViewController alloc] init];
            partner.title = info.title;
            vc = partner;
        }
            break;
        case WMMeListInfoTypAccess :
        {
        }
            vc = [[WMGoodsAccessRecordViewController alloc] init];
            break;
    }
    
    if(vc)
    {
        [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self];
    }
}

@end
