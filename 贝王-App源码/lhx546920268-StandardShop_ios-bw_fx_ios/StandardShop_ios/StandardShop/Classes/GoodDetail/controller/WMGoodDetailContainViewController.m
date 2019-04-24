//
//  WMGoodDetailContainViewController.m
//  StandardShop
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailContainViewController.h"
#import "WMGoodDetailInfoViewController.h"
#import "WMGoodGraphicDetailViewController.h"
#import "WMShopCarViewController.h"
#import "WMGoodBrowseHistoryViewController.h"
#import "WMGoodCollectListViewController.h"
#import "WMMessageCenterViewController.h"
#import "WMTabBarController.h"
#import "WMGoodCommentViewController.h"

#import "WMGoodDetailOperation.h"
#import "WMCustomerServiceOperation.h"
#import "WMGoodListOperation.h"
#import "WMShareOperation.h"
#import "WMUserOperation.h"
#import "WMGoodDetailInfo.h"
#import "WMUserInfo.h"
#import "WMGoodInfo.h"
#import "WMShopContactInfo.h"
#import "WMCustomerServicePhoneInfo.h"

#import "WMGoodDetailBottomView.h"
#import "WMShareActionSheet.h"
#import "WMBrowseHistoryDataBase.h"
#import "WMShopContactDialog.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface WMGoodDetailContainViewController ()<SeaNetworkQueueDelegate,SeaHttpRequestDelegate,SeaBubbleMenuDelegate,UIAlertViewDelegate,SeaMenuBarDelegate,CNContactViewControllerDelegate,CNContactPickerDelegate,ABNewPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>
/**请求队列
 */
@property (strong,nonatomic) SeaNetworkQueue *queue;
/**商品的相似商品数组
 */
@property (strong,nonatomic) NSArray *goodSimilarsArr;
/**商品详情数据模型
 */
@property (strong,nonatomic) WMGoodDetailInfo *goodDetailInfo;
/**商品信息控制器
 */
@property (strong,nonatomic) WMGoodDetailInfoViewController *infoController;
/**商品的图文详情
 */
@property (strong,nonatomic) WMGoodGraphicDetailViewController *graphicController;
/**底部视图
 */
@property (strong,nonatomic) WMGoodDetailBottomView *bottomView;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**气泡弹窗
 */
@property (strong,nonatomic) SeaBubbleMenu *bubbleMenu;
/**客服数据
 */
@property (strong,nonatomic) NSDictionary *customServiceInfo;
/**菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *menuBar;
/**iOS8之前的播放器
 */
@property (strong,nonatomic) MPMoviePlayerViewController *moviePlayerController;
/**iOS8之后的播放器
 */
@property (strong,nonatomic) AVPlayerViewController *avPlayerController;

@end

@implementation WMGoodDetailContainViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.backItem = YES;
                
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    _menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, 150.0, 44.0) titles:@[@"商品",@"详情",@"评价"] style:SeaMenuBarStyleItemWithRelateTitle];
    
    _menuBar.topSeparatorLine.hidden = YES;
    
    _menuBar.separatorLine.hidden = YES;
    
    _menuBar.callDelegateWhenSetSelectedIndex = NO;
    
    _menuBar.buttonInterval = 15.0;
    
    _menuBar.buttonWidthExtension = 5.0;
    
    _menuBar.showSeparator = NO;
    
    _menuBar.titleFont = [UIFont fontWithName:MainFontName size:16.0];
    
    _menuBar.titleColor = [UIColor blackColor];
    
    _menuBar.selectedColor = [UIColor blackColor];
    
    _menuBar.delegate = self;
    
    self.navigationItem.titleView = _menuBar;
    
    [self reloadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.bottomView.badgeView.value = [WMUserInfo displayShopcarCount];
    
    _menuBar.selectedIndex = self.scrollView.contentOffset.y > 0.0 ? 1 : 0;
}

#pragma mark - 网络请求
- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    
    [self configureNetWorkQueueRequest];
}

- (void)configureNetWorkQueueRequest{
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodDetailOperation returnGoodDetailParamWithProductID:self.productID isGift:self.isGift] identifier:WMGoodDetailRequestIdentifier];
    
    if([NSString isEmpty:[WMCustomerServicePhoneInfo shareInstance].servicePhoneNumber]){
        
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMCustomerServiceOperation returnCustomServiceParam] identifier:WMCustomerServiceInfoIdentifier];
    }
    else{
        
        WMCustomerServicePhoneInfo *info = [WMCustomerServicePhoneInfo shareInstance];
        
        NSDictionary *dict = @{@"type":info.type,@"val":info.contact};

        self.customServiceInfo = dict;
    }
    
    [self.queue startDownload];
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier{
    
    self.loading = NO;
    
    [self failToLoadData];
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier{
    
    if ([identifier isEqualToString:WMGoodDetailRequestIdentifier]) {
        
        id info = [WMGoodDetailOperation returnGoodDetailInfoWithData:data];
        
        if ([info isKindOfClass:[WMGoodDetailInfo class]]) {
            
            self.goodDetailInfo = (WMGoodDetailInfo *)info;
            
            
            UIBarButtonItem *shareItem = [self barButtonItemWithTitle:nil icon:[UIImage imageNamed:@"share_icon"] action:@selector(shareGood)];
            
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spaceItem.width = 20.0;
            
            UIBarButtonItem *moreItem = [self barButtonItemWithTitle:nil icon:[UIImage imageNamed:@"more_point"] action:@selector(showBubbleView)];
            
            [self setBarItems:[NSArray arrayWithObjects:moreItem, spaceItem, shareItem, nil] position:SeaNavigationItemPositionRight];
            
            [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodDetailOperation returnGoodSimilarGoodParamWithGoodID:self.goodDetailInfo.goodID] identifier:WMGoodDetailSimilarRequestIdentifier];
            
            [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMGoodDetailOperation returnRecordGoodVisitParamWithGoodID:self.goodDetailInfo.goodID] identifier:WMRecordGoodVisitIdentifier];
            
            WMGoodInfo *goodInfo = [[WMGoodInfo alloc] init];
            goodInfo.goodId = self.goodDetailInfo.goodID;
            goodInfo.productId = self.goodDetailInfo.productID;
            goodInfo.goodName = self.goodDetailInfo.goodName;
            goodInfo.imageURL = [self.goodDetailInfo.goodImagesArr firstObject];
            goodInfo.price = self.goodDetailInfo.goodShowPrice;
            goodInfo.marketPrice = self.goodDetailInfo.goodMarketPrice;
            
            [WMBrowseHistoryDataBase insertBrowseHistoryWithInfo:goodInfo];
        }
        else if ([info isKindOfClass:[NSString class]]){
            
            NSString *msg = (NSString *)info;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([identifier isEqualToString:WMGoodDetailSimilarRequestIdentifier]){
        
        NSArray *goodSimilarArr = [WMGoodDetailOperation returnGoodSimilarArrWithData:data];
        
        if (goodSimilarArr) {
            
            self.goodSimilarsArr = goodSimilarArr;
        }
    }
    else if ([identifier isEqualToString:WMCustomerServiceInfoIdentifier]){
        
        NSDictionary *dict = [WMCustomerServiceOperation returnCustomServiceResultWithData:data];
        
        self.customServiceInfo = dict;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue{
    
    self.loading = NO;
    
    self.goodDetailInfo.goodSimilarGoodsArr = self.goodSimilarsArr;
        
    if (!self.scrollView && self.goodDetailInfo) {
        
        [self initialization];
        
        [self configureBottomView];
        
        WeakSelf(self);
        
        _infoController = [[WMGoodDetailInfoViewController alloc] init];
        
        _infoController.goodDetailInfo = self.goodDetailInfo;
        
        _infoController.navigation = self.navigationController;
        
        _infoController.isGift = self.isGift;
        
        _infoController.view.frame = CGRectMake(0, 0, _width_, self.scrollView.height);
        
        [_infoController setUpLoadCallBack:^{
            
            [weakSelf.infoController removeFromParentViewController];
            
            [weakSelf addChildViewController:weakSelf.graphicController];
            
            [weakSelf.scrollView setContentOffset:CGPointMake(0, weakSelf.scrollView.height) animated:YES];
            
            weakSelf.menuBar.selectedIndex = 1;
        }];
        
        [_infoController setUpLoadButtonCollection:^{
            
            weakSelf.goodDetailInfo = weakSelf.infoController.goodDetailInfo;
            
            weakSelf.bottomView.buttonPageList = weakSelf.goodDetailInfo.buttonPageList;
            
            weakSelf.bottomView.buttonView.buttonListArr = weakSelf.goodDetailInfo.buttonPageList;
            
            [weakSelf.bottomView.buttonView updateUI];
        }];
                
        [self addChildViewController:_infoController];
        
        [self.scrollView addSubview:_infoController.view];
        
        self.graphicController = [[WMGoodGraphicDetailViewController alloc] init];
        
        self.graphicController.goodDetailInfo = self.goodDetailInfo;
        
        [self.graphicController setDropDown:^{
            
            [weakSelf.graphicController removeFromParentViewController];
            
            [weakSelf addChildViewController:weakSelf.infoController];
            
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            weakSelf.menuBar.selectedIndex = 0;
        }];
        
        self.graphicController.view.frame = CGRectMake(0, self.scrollView.height, _width_, self.scrollView.height);
        
        [self.scrollView addSubview:self.graphicController.view];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([self.request.identifier isEqualToString:WMGoodCollectIdentifier]) {
        
        if ([WMGoodListOperation goodCollectResultFromData:data]) {
            
            [self alertMsg:@"收藏成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMGoodCollectDidChangeNotification object:nil userInfo:@{WMGoodCollectStatus:@(YES),WMGoodOperationGoodId:self.goodDetailInfo.goodID}];
            
            self.goodDetailInfo.goodIsFav = YES;
            
            self.bottomView.goodIsFav = YES;
            
            [self.bottomView updateUI];
        }
    }
    else if ([self.request.identifier isEqualToString:WMGoodRemoveCollectIdentifier]){
        
        if ([WMGoodListOperation goodCollectResultFromData:data]) {
            
            [self alertMsg:@"取消收藏成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMGoodCollectDidChangeNotification object:nil userInfo:@{WMGoodCollectStatus:@(NO),WMGoodOperationGoodId:self.goodDetailInfo.goodID}];
            
            self.goodDetailInfo.goodIsFav = NO;
            
            self.bottomView.goodIsFav = NO;
            
            [self.bottomView updateUI];
        }
    }
    else if ([self.request.identifier isEqualToString:WMGetShopContactIdentifier]){
    
        NSDictionary *contactInfo = [WMGoodDetailOperation returnShopContactInfo:data];
        
        if (contactInfo) {
            
            [self showContactDialog];
        }
    }
    else if ([self.request.identifier isEqualToString:WMCustomerServiceInfoIdentifier]){
        
        NSDictionary *customerServiceDict = [WMCustomerServiceOperation returnCustomServiceResultWithData:data];
        
        if(customerServiceDict)
        {
            [self callCustomService];
        }
        else
        {
            [self alertMsg:@"获取客服信息失败"];
        }
    }
}

#pragma mark - 初始化
- (void)initialization{
    
    CGFloat height = _height_ - self.navigationBarHeight - self.statusBarHeight - WMGoodDetailBottomViewHeight;
    
    if (isIPhoneX) {
        
        height -= 35.0;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width_, height)];
    
    self.scrollView.contentSize = CGSizeMake(_width_, height * 2.0);
    
    self.scrollView.scrollEnabled = NO;
    
    self.scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
}

- (void)configureBottomView{
    
    WeakSelf(self);
    
    _bottomView = [[WMGoodDetailBottomView alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, _width_, WMGoodDetailBottomViewHeight)];
    
    _bottomView.quantity = [WMUserInfo displayShopcarCount];
    
    _bottomView.goodIsFav = _goodDetailInfo.goodIsFav;
    
    _bottomView.type = _goodDetailInfo.type;
    
    _bottomView.buttonPageList = _goodDetailInfo.buttonPageList;
    
    [_bottomView layOutGoodBottomView];
    
    [_bottomView setCustomServiceAction:^(UIButton *button) {
        
        /**点击客服
        
        if ([AppDelegate instance].isLogin) {
            
            if (![NSString isEmpty:[WMShopContactInfo shareInstance].upLineShopName]) {
                
                [weakSelf showContactDialog];
                
                return ;
            }
        }
        else{
        
            if (![NSString isEmpty:[WMShopContactInfo shareInstance].shopName]) {
                
                [weakSelf showContactDialog];
                
                return;
            }
        }
        
        weakSelf.requesting = YES;
        
        weakSelf.showNetworkActivity = YES;
        
        weakSelf.request.identifier = WMGetShopContactIdentifier;
        
        [weakSelf.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation returnShopContactInfoParam]];
         
         **/
        
        if([AppDelegate instance].isLogin){
            [weakSelf openService];
        }else{
            [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                
                [weakSelf openService];
            }];
        }
        
    }];
    
    [_bottomView setAddFavButtonAction:^(UIButton *button) {
        
        if ([[AppDelegate instance] isLogin]) {
            
            if (weakSelf.goodDetailInfo.goodIsFav) {
                
                [weakSelf removeGoodFavInfo];
            }
            else{
                
                [weakSelf addGoodFavInfo];
            }
            
        }
        else{
            
            [[AppDelegate instance] showLoginViewControllerWithAnimate:YES];
        }
    }];
    
    [_bottomView setShopCarButtonAction:^(UIButton *button) {
        
        WMShopCarViewController *carController = [WMShopCarViewController new];
        
        carController.backItem = YES;
        
        [weakSelf.navigationController pushViewController:carController animated:YES];
    }];
    
    [_bottomView.buttonView setButtonAction:^(BOOL fastBuy, BOOL notify, BOOL canBuy,NSString *value) {
        
        [weakSelf.infoController configureSpecInfoControllerIsGift:self.goodDetailInfo.type == GoodPromotionTypeGift fastBuy:fastBuy notify:notify canBuy:canBuy value:value];
    }];
    
    [self.view addSubview:_bottomView];
}

//打开客服
- (void)openService{
    if([NSString isEmpty:[WMCustomerServicePhoneInfo shareInstance].servicePhoneNumber])
    {
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
        
        self.request.identifier = WMCustomerServiceInfoIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMCustomerServiceOperation returnCustomServiceParam]];
    }
    else{
        
        [self callCustomService];
    }
}

- (void)addGoodFavInfo{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGoodCollectIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation goodCollectParamWithType:0 goodId:self.goodDetailInfo.goodID]];
}

- (void)removeGoodFavInfo{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGoodRemoveCollectIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation goodCollectParamWithType:1 goodId:self.goodDetailInfo.goodID]];
}

#pragma mark - 打开客服
- (void)callCustomService{
    
    NSString *type = [WMCustomerServicePhoneInfo shareInstance].type;
    
    if ([type isEqualToString:@"weixin"]) {
        
        [WMShareOperation openWeinxinWithUserName:[WMCustomerServicePhoneInfo shareInstance].contact];
    }
    else if ([type isEqualToString:@"qq"]){
        
        [WMShareOperation openQQWithQQ:[WMCustomerServicePhoneInfo shareInstance].contact];
    }
    else{
        
        SeaWebViewController *web = [[SeaWebViewController alloc] initWithURL:[WMCustomerServicePhoneInfo shareInstance].contact];
        
        web.backItem = YES;
        
        web.title = @"在线客服";
        
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark - 分享商品
- (void)shareGood{
    
    if (!self.goodDetailInfo) {
        
        return;
    }
    
    WMGoodInfo *goodInfo = [WMGoodInfo new];
    
    goodInfo.goodName = self.goodDetailInfo.goodName;
    
    goodInfo.brief = self.goodDetailInfo.goodBrief.string;
    
    goodInfo.shareURL = self.goodDetailInfo.shareURL;
    
    goodInfo.imageURL = [self.goodDetailInfo.goodImagesArr firstObject];
    
    WMShareActionSheet *actionSheet = [[WMShareActionSheet alloc] init];
    
    actionSheet.shareContentView.shareType = WMShareTypeGoodH5;
    
    actionSheet.shareContentView.goodInfo = goodInfo;
    
    actionSheet.shareContentView.navigationController = self.navigationController;
    
    [actionSheet show];
}

#pragma mark - 弹出气泡
- (void)showBubbleView{
    
    UIWindow *window = [AppDelegate instance].window;
    
    CGRect rect = [window convertRect:CGRectMake(_width_ - 40.0, 30.0, 30.0, 30.0) toWindow:window];
    
    self.bubbleMenu = [[SeaBubbleMenu alloc] init];
    
    self.bubbleMenu.fillColor = [UIColor colorWithR:0 G:0 B:0 a:0.8];
    
    self.bubbleMenu.menuWidth = 120.0;
    
    self.bubbleMenu.contentInsets = UIEdgeInsetsMake(0, 8.0, 0.0, 0.0);
    
    self.bubbleMenu.textColor = [UIColor whiteColor];
    
    self.bubbleMenu.selectedBackgroundColor = self.bubbleMenu.fillColor;
    
    self.bubbleMenu.delegate = self;
    
    self.bubbleMenu.menuItemInfos = [NSMutableArray arrayWithObjects:[SeaBubbleMenuItemInfo infoWithTitle:@" 消息" icon:[UIImage imageNamed:[WMUserInfo sharedUserInfo].personCenterInfo.unreadMessageCount == 0 ? @"detail_message" : @"detail_message_unread"]], [SeaBubbleMenuItemInfo infoWithTitle:@" 首页" icon:[UIImage imageNamed:@"detail_home"]],[SeaBubbleMenuItemInfo infoWithTitle:@" 我的收藏" icon:[UIImage imageNamed:@"detail_fav"]],[SeaBubbleMenuItemInfo infoWithTitle:@" 我的足迹" icon:[UIImage imageNamed:@"detail_history"]], nil];
    
    [self.bubbleMenu showInView:window relatedRect:rect animated:YES overlay:YES];
}

- (void)bubbleMenu:(SeaBubbleMenu *)menu didSelectedAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            if([AppDelegate instance].isLogin)
            {
                [self.navigationController pushViewController:[WMMessageCenterViewController new] animated:YES];
            }
            else
            {
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                    
                    [self.navigationController pushViewController:[WMMessageCenterViewController new] animated:YES];
                }];
            }
        }
            break;
        case 1:
        {
            [AppDelegate tabBarController].selectedIndex = 0;

            [self backToRootViewControllerWithAnimated:NO];
        }
            break;
        case 2:
        {
            if([AppDelegate instance].isLogin)
            {
                [self.navigationController pushViewController:[WMGoodCollectListViewController new] animated:YES];
            }
            else
            {
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                    
                    [self.navigationController pushViewController:[WMGoodCollectListViewController new] animated:YES];
                }];
            }
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[WMGoodBrowseHistoryViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self back];
}

#pragma mark - SeaMenuBarDelegate
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    if (!self.graphicController) {
        
        return;
    }
    
    if (index == 0) {
        
        [self.graphicController removeFromParentViewController];
        
        [self addChildViewController:self.infoController];
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (index == 1){
        
        [self.infoController removeFromParentViewController];
        
        [self addChildViewController:self.graphicController];
        
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.height) animated:YES];
    }
    else{
        
        WMGoodCommentViewController *comment = [[WMGoodCommentViewController alloc] initWithGoodId:self.goodDetailInfo.goodID];
        
        [self.navigationController pushViewController:comment animated:YES];
    }
}

- (BOOL)menuBar:(SeaMenuBar *)menu shouldSelectItemAtIndex:(NSInteger)index{
    
    if (!self.graphicController) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 弹出弹窗
- (void)showContactDialog{
    
    WMShopContactDialog *dialog = [[WMShopContactDialog alloc] init];
    
    dialog.controller = self;
    
    WeakSelf(self);
    
    [dialog setContactCallBack:^(BOOL isExist) {
        
        if (_ios9_0_) {
            
            if (!isExist) {
                
                CNMutableContact *contact = [[CNMutableContact alloc] init];
                
                contact = [WMGoodDetailOperation getContactIsExist:isExist contact:contact];
                
                CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:contact];
                
                controller.delegate = weakSelf;
                
                UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
                
                [weakSelf presentViewController:navigation animated:YES completion:^{
                    
                }];
                
            }else{
            
                CNContactPickerViewController *controller = [[CNContactPickerViewController alloc] init];
                
                controller.delegate = weakSelf;
                
                [weakSelf presentViewController:controller animated:YES completion:^{
                    
                }];
            }
        }
        else{
            
            if (!isExist) {
                                
                ABNewPersonViewController *controller = [ABNewPersonViewController new];
                
                controller.newPersonViewDelegate = weakSelf;
                
                controller.displayedPerson = [WMGoodDetailOperation getAddressBookRecord];
                
                UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
                
                [weakSelf presentViewController:navigation animated:YES completion:^{
                    
                    
                }];
            }else{
                
                ABPeoplePickerNavigationController * controller = [[ABPeoplePickerNavigationController alloc] init];
                
                controller.peoplePickerDelegate = weakSelf;
                
                if (_ios8_0_) {
                    
                    controller.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
                }
                
                [weakSelf presentViewController:controller animated:YES completion:^{
                    
                    
                }];
            }
        }
    }];
    
    [dialog show];
}

#pragma mark - CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
    
    return YES;
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    WeakSelf(self);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        CNMutableContact *currentContact = [contact mutableCopy];
        
        currentContact = [WMGoodDetailOperation getContactIsExist:YES contact:currentContact];
        
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:currentContact];
        
        controller.delegate = weakSelf;
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [weakSelf presentViewController:navigation animated:YES completion:^{
            
        }];
    }];
}

#pragma mark - ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    
    [newPersonView dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    WeakSelf(self);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
        ABNewPersonViewController *controller = [ABNewPersonViewController new];
        
        controller.newPersonViewDelegate = weakSelf;
        
        controller.displayedPerson = person;
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [weakSelf presentViewController:navigation animated:YES completion:^{
            
            
        }];
    }];
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

















@end
