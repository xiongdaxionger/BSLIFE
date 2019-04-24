//
//  TabBarController.m
//  ydtctz
//
//  Created by 小宝 on 1/2/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import "WMTabBarController.h"
#import "WMHomeViewController.h"
#import "WMCategoryBrandViewController.h"
#import "WMFoundHomeViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMSecondKillViewController.h"
#import "WMMeViewController.h"
#import "WMShopCarViewController.h"
#import "WMLoginViewController.h"
#import "WMArticleViewController.h"
#import "WMFoundListInfo.h"
#import "WMDrawCouponsViewController.h"
#import "WMFoundCommentListViewController.h"
#import "WMBrandInfo.h"
#import "WMCategoryInfo.h"
#import "WMGoodListViewController.h"

///选项卡背景
@interface WMTabBarBackgroundView : UIView

@end

@interface WMTabBarController ()<SeaTabBarControllerDelegate>

///代客下单
@property(nonatomic,weak) UINavigationController *valetNav;

@end

@implementation WMTabBarController

- (void)dealloc
{
    [self stopAllTimer];
}

///初始化
+ (void)initialization
{
    WMTabBarController *tabBarController = [[WMTabBarController alloc] init];
    tabBarController.tabBar.translucent = NO;
    tabBarController.delegate = tabBarController;
    
    //设置点击样式
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont fontWithName:MainFontName size:11.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_appMainColor_, NSForegroundColorAttributeName, [UIFont fontWithName:MainFontName size:11.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabBar_home_n"] selectedImage:[UIImage imageNamed:@"tabBar_home_n"]];
    
    UIViewController *vc = [[WMHomeViewController alloc] init];
    vc.tabBarItem = item;
    
 //   UIViewController *viewController1 = vc;
    SeaNavigationController *viewController1 = [[SeaNavigationController alloc]initWithRootViewController:vc];
    viewController1.targetStatusBarStyle = WMStatusBarStyle;
    
    item = [[UITabBarItem alloc] initWithTitle:@"分类" image:[UIImage imageNamed:@"tabBar_cat_n"]selectedImage:[UIImage imageNamed:@"tabBar_cat_n"]];
    
    vc = [[WMCategoryBrandViewController alloc] init];
    vc.tabBarItem = item;
    SeaNavigationController *viewController2 = [[SeaNavigationController alloc]initWithRootViewController:vc];
    viewController2.targetStatusBarStyle = WMStatusBarStyle;
    
    item = [[UITabBarItem alloc] initWithTitle:@"社区" image:[UIImage imageNamed:@"tabBar_found_n"] selectedImage:[UIImage imageNamed:@"tabBar_found_n"]];
    
    vc = [[WMFoundHomeViewController alloc] init];
    vc.tabBarItem = item;
    SeaNavigationController *viewController3 = [[SeaNavigationController alloc]initWithRootViewController:vc];
    viewController3.targetStatusBarStyle = WMStatusBarStyle;
    
    item = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[UIImage imageNamed:@"tabBar_shopcart_n"] selectedImage:[UIImage imageNamed:@"tabBar_shopcart_n"]];
    
    vc = [[WMShopCarViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.tabBarItem = item;
    SeaNavigationController *viewController4 = [[SeaNavigationController alloc]initWithRootViewController:vc];
    viewController4.targetStatusBarStyle = WMStatusBarStyle;
    
    item = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"tabBar_me_n"] selectedImage:[UIImage imageNamed:@"tabBar_me_n"]];
    
    vc = [[WMMeViewController alloc] init];
    vc.tabBarItem = item;
    SeaNavigationController *viewController5 = [[SeaNavigationController alloc]initWithRootViewController:vc];
    viewController5.targetStatusBarStyle = WMStatusBarStyle;
    
    [tabBarController setViewControllers:@[viewController1,viewController2,viewController3,viewController4,viewController5]];
    [AppDelegate instance].window.rootViewController = tabBarController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.tintColor = _appMainColor_;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return WMStatusBarStyle;
}

#pragma mark- UITabBarController delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if(![[AppDelegate instance] isLogin])
//    {
//        NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
//        ///购物车需要需要登录
//        if(index == 3)
//        {
//            [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
//               
//                self.selectedIndex = index;
//            }];
//            
//            return NO;
//        }
//    }

    return YES;
}

///停止所有计时器任务
- (void)stopAllTimer
{
    //[self.messageListViewController stopTimer];
}


/**
 *  打开某篇学院文章
 * @param Id 文章id
 */
- (void)openCollegeWithId:(NSString*)Id title:(NSString *)title
{
    if([Id longLongValue] == 0)
        return;
    WMFoundCommentListViewController *detail = [[WMFoundCommentListViewController alloc] init];
    detail.articleId = Id;
    detail.title = title;
    [SeaPresentTransitionDelegate pushViewController:detail useNavigationBar:YES parentedViewConttroller:[AppDelegate rootViewController]];
}

/**
 *  打开某个商品详情
 * @param Id 商品id
 */
- (void)openGoodDetailWithId:(NSString *)Id title:(NSString *)title
{
    if([Id longLongValue] == 0)
        return;
    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.productID = Id;
    detail.title = title;
    [SeaPresentTransitionDelegate pushViewController:detail useNavigationBar:YES parentedViewConttroller:[AppDelegate rootViewController]];
}

/**打开秒杀
 */
- (void)openSecondKill{
    
    [SeaPresentTransitionDelegate pushViewController:[WMSecondKillViewController new] useNavigationBar:YES parentedViewConttroller:[AppDelegate rootViewController]];
}

- (void)openActivityCoupon{
    
    [SeaPresentTransitionDelegate pushViewController:[WMDrawCouponsViewController new] useNavigationBar:YES parentedViewConttroller:[AppDelegate tabBarController]];
}

- (void)openBrandWithId:(NSString *)Id title:(NSString *)title{
    
    WMBrandInfo *brandInfo = [[WMBrandInfo alloc] init];
    
    brandInfo.name = title;
    
    brandInfo.Id = Id;
    
    [SeaPresentTransitionDelegate pushViewController:[[WMGoodListViewController alloc] initWithBrandInfo:brandInfo] useNavigationBar:YES parentedViewConttroller:[AppDelegate tabBarController]];
}

- (void)openCategoryWithID:(NSString *)Id title:(NSString *)title{
    
    WMCategoryInfo *categoryInfo = [WMCategoryInfo new];
    
    categoryInfo.categoryId = Id.integerValue;
    
    categoryInfo.categoryName = title;
    
    [SeaPresentTransitionDelegate pushViewController:[[WMGoodListViewController alloc] initWithCategoryInfo:categoryInfo] useNavigationBar:YES parentedViewConttroller:[AppDelegate tabBarController]];
}

- (void)openCustomLink:(NSString *)link title:(NSString *)title{
    
    SeaWebViewController *webController = [[SeaWebViewController alloc] initWithURL:link];
    
    webController.backItem = YES;
    
    webController.title = title;
    
    [SeaPresentTransitionDelegate pushViewController:webController useNavigationBar:YES parentedViewConttroller:[AppDelegate tabBarController]];
}



@end
