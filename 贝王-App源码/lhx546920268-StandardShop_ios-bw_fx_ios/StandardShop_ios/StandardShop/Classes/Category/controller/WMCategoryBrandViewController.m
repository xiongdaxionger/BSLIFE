//
//  WMCategoryBrandViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMCategoryBrandViewController.h"
#import "WMGoodCategoryViewController.h"
#import "WMBrandListViewController.h"
#import "WMSearchController.h"
#import "WMGoodListViewController.h"
#import "WMQRCodeScanViewController.h"
#import "WMNavigationBarRedPointButton.h"
#import "WMUserInfo.h"
#import "WMMessageCenterViewController.h"
#import "WMCustomerServicePhoneInfo.h"

@interface WMCategoryBrandViewController ()<SeaMenuBarDelegate>

///菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///分类
@property(nonatomic,strong) WMGoodCategoryViewController *goodCategoryViewController;

///品牌
@property(nonatomic,strong) WMBrandListViewController *brandListViewController;

///搜索控制器
@property(nonatomic,strong) WMSearchController *searchController;

///消息按钮
@property(nonatomic,strong) WMNavigationBarRedPointButton *message_btn;

@end

@implementation WMCategoryBrandViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.requesting = NO;
    [[WMCustomerServicePhoneInfo shareInstance] cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidGet:) name:WMUserInfoDidGetNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:WMUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAutoLoginDidFail:) name:WMUserAutoLoginDidFailNotification object:nil];

    ///设置导航栏
    [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"qrcode_icon"] action:@selector(qrCode) position:SeaNavigationItemPositionLeft];
    ///拨打客服电话
//    [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"phone_icon"] action:@selector(callCustomerService) position:SeaNavigationItemPositionLeft];

    ///消息
    self.message_btn = [[WMNavigationBarRedPointButton alloc] initWithImage:[UIImage imageNamed:@"message_icon"]];
    self.message_btn.redPoint.layer.borderWidth = 0;
    [self.message_btn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self setBarItemWithCustomView:self.message_btn position:SeaNavigationItemPositionRight];

    ///搜索栏
    self.searchController = [[WMSearchController alloc] initWithViewController:self];

    WeakSelf(self);
    self.searchController.searchHandler = ^(NSString *searchKey){

        WMGoodListViewController *list = [[WMGoodListViewController alloc] init];
        list.titleName = searchKey;
        list.searchKey = searchKey;
        [weakSelf.navigationController pushViewController:list animated:YES];
    };

    self.searchController.searchDidEndHandler = ^(void){

        [weakSelf setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"qrcode_icon"] action:@selector(qrCode) position:SeaNavigationItemPositionLeft];
        [weakSelf setBarItemWithCustomView:weakSelf.message_btn position:SeaNavigationItemPositionRight];
    };

    [self initlization];

    [self userInfoDidGet:nil];
}

///创建搜索栏
- (void)initlization
{
    if(!self.menuBar)
    {
        SeaMenuBar *menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, self.contentY, _width_, _SeaMenuBarHeight_) titles:[NSArray arrayWithObjects:@"分类", @"品牌", nil] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
        menuBar.delegate = self;
        menuBar.topSeparatorLine.hidden = YES;
        [self.view addSubview:menuBar];
        self.menuBar = menuBar;
        
        [self menuBar:self.menuBar didSelectItemAtIndex:0];
    }
}

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
    [self.navigationController pushViewController:msg animated:YES];
}

///二维码扫描
- (void)qrCode
{
    WMQRCodeScanViewController *qrCode = [[WMQRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrCode animated:YES];
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

///退出登录
- (void)userDidLogout:(NSNotification*) notification
{
    self.message_btn.redPoint.hidden = YES;
}

///自动登录失败
- (void)userAutoLoginDidFail:(NSNotification*) notification
{
    self.message_btn.redPoint.hidden = YES;
}

///获取个人信息
- (void)userInfoDidGet:(NSNotification*) notification
{
    WMUserInfo *info = [WMUserInfo sharedUserInfo];
    self.message_btn.redPoint.hidden = info.personCenterInfo.unreadMessageCount == 0;
}

#pragma mark- SeaMenuBar delegate

///点击分段选择
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0 :
        {
            if(!self.goodCategoryViewController)
            {
                self.goodCategoryViewController = [[WMGoodCategoryViewController alloc] init];
            }
            
            if(self.brandListViewController)
            {
                [self.brandListViewController.view removeFromSuperview];
                [self.brandListViewController removeFromParentViewController];
            }
            
            CGRect frame = self.goodCategoryViewController.view.frame;
            frame.origin.y = self.menuBar.bottom;
            frame.size.height = self.view.height - self.menuBar.bottom;
            self.goodCategoryViewController.view.frame = frame;
            
            [self.goodCategoryViewController willMoveToParentViewController:self];
            [self.view addSubview:self.goodCategoryViewController.view];
            [self addChildViewController:self.goodCategoryViewController];
            [self.goodCategoryViewController didMoveToParentViewController:self];
        }
            break;
        case 1 :
        {
            if(!self.brandListViewController)
            {
                self.brandListViewController = [[WMBrandListViewController alloc] init];
            }
            
            if(self.goodCategoryViewController)
            {
                [self.goodCategoryViewController.view removeFromSuperview];
                [self.goodCategoryViewController removeFromParentViewController];
            }
            
            CGRect frame = self.brandListViewController.view.frame;
            frame.origin.y = self.menuBar.bottom;
            frame.size.height = self.view.height - self.menuBar.bottom;
            self.brandListViewController.view.frame = frame;
            
            [self.brandListViewController willMoveToParentViewController:self];
            [self.view addSubview:self.brandListViewController.view];
            [self addChildViewController:self.brandListViewController];
            [self.brandListViewController didMoveToParentViewController:self];
        }
            break;
        default:
            break;
    }
}

///跳到对应的界面 0分类，1品牌馆
- (void)showViewAtIndex:(NSInteger) index
{
    self.tabBarController.selectedIndex = 1;
    [self initlization];
    self.menuBar.selectedIndex = index;
}


@end
