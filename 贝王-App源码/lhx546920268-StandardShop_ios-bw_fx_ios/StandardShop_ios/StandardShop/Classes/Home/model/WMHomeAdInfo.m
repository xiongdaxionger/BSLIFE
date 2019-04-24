//
//  WMHomeAdInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMHomeAdInfo.h"
#import "WMFoundCommentListViewController.h"
#import "WMGoodListViewController.h"
#import "WMCategoryInfo.h"
#import "WMShareActionSheet.h"
#import "WMBrandInfo.h"
#import "WMGoodDetailContainViewController.h"
#import "WMSecondKillViewController.h"
#import "WMIntegralSignInViewController.h"
#import "WMShakeViewController.h"
#import "WMTabBarController.h"
#import "WMCategoryBrandViewController.h"
#import "WMTopupAdViewController.h"
#import "WMDrawCouponsViewController.h"
#import "WMHomeViewController.h"

@implementation WMHomeAdInfo

+ (instancetype)infoFromDictionary:(NSDictionary *)dic
{
    WMHomeAdInfo *info = [[WMHomeAdInfo alloc] init];
    
    info.imageURL = [dic sea_stringForKey:@"link"];
    info.Id = [dic sea_stringForKey:@"url_id"];
    info.text = [dic sea_stringForKey:@"ad_name"];
    
    NSString *type = [dic sea_stringForKey:@"url_type"];
    if([type isEqualToString:@"article"])
    {
        info.adType = WMHomeAdTypeArticle;
    }
    else if ([type isEqualToString:@"gallery"])
    {
        info.adType = WMHomeAdTypeCategoryGoodList;
    }
    else if ([type isEqualToString:@"virtual_cat"])
    {
        info.adType = WMHomeAdTypeVirtualCategoryGoodList;
    }
    else if ([type isEqualToString:@"goods_cat"])
    {
        info.adType = WMHomeAdTypeCategoryList;
    }
    else if ([type isEqualToString:@"brand"])
    {
        info.adType = WMHomeAdTypeBrand;
    }
    else if ([type isEqualToString:@"yiy"])
    {
        info.adType = WMHomeAdTypeShake;
    }
    else if([type isEqualToString:@"product"])
    {
        info.adType = WMHomeAdTypeGood;
    }
    else if ([type isEqualToString:@"signin"])
    {
        info.adType = WMHomeAdTypeSignin;
    }
    else if([type isEqualToString:@"starbuy"])
    {
        info.adType = WMHomeAdTypeSecondKill;
    }
    else if ([type isEqualToString:@"custom"])
    {
        info.adType = WMHomeAdTypeCustom;
    }
    else if ([type isEqualToString:@"recharge"])
    {
        info.adType = WMHomeAdTypeTopup;
    }
    else if ([type isEqualToString:@"preparesell"])
    {
        info.adType = WMHomeAdTypePresellGoodList;
    }
    else if ([type isEqualToString:@"get_coupons"])
    {
        info.adType = WMHomeAdTypeDrawCoupons;
    }
    
    info.itemSize = CGSizeMake([[dic numberForKey:@"size_x"] floatValue], [[dic numberForKey:@"size_y"] floatValue]);
    
    return info;
}

/**获取对应的品牌controller
 */
- (UIViewController*)viewController
{
    switch (self.adType)
    {
        case WMHomeAdTypeGood :
        {
            WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
            detail.productID = self.Id;
            return detail;
        }
            break;
        case WMHomeAdTypeArticle :
        {
            WMFoundCommentListViewController *article = [[WMFoundCommentListViewController alloc] init];
            article.articleId = self.Id;
            article.title = self.text;
            return article;
        }
            break;
        case WMHomeAdTypeCategoryGoodList :
        case WMHomeAdTypeVirtualCategoryGoodList :
        {
            WMCategoryInfo *info = [[WMCategoryInfo alloc] init];
            info.categoryId = [self.Id longLongValue];
            info.categoryName = self.text;
            info.isVirtualCategory = self.adType == WMHomeAdTypeVirtualCategoryGoodList;
            
            WMGoodListViewController *list = [[WMGoodListViewController alloc] initWithCategoryInfo:info];
            return list;
        }
            break;
        case WMHomeAdTypeBrand :
        {
            WMBrandInfo *brandInfo = [[WMBrandInfo alloc] init];
            brandInfo.Id = self.Id;
            brandInfo.name = self.text;

            WMGoodListViewController *brand = [[WMGoodListViewController alloc] initWithBrandInfo:brandInfo];
            return brand;
        }
            break;
        case WMHomeAdTypeSecondKill :
        {
            WMSecondKillViewController *secondKill = [[WMSecondKillViewController alloc] init];
            secondKill.secondKillImageURL = [WMHomeViewController secondKillImageURL];
            return secondKill;
        }
            break;
        case WMHomeAdTypeShake :
        {
            if(![AppDelegate instance].isLogin)
            {
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                   
                    [self shake];
                }];
            }
            else
            {
                [self shake];
            }
        }
            break;
        case WMHomeAdTypeSignin:
        {
            if(![AppDelegate instance].isLogin)
            {
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                    
                    [self signin];
                }];
            }
            else
            {
                [self signin];
            }
        }
            break;
        case WMHomeAdTypeNotknow :
        {
            
        }
            break;
        case WMHomeAdTypeCustom :
        {
            SeaWebViewController *webView = [[SeaWebViewController alloc] initWithURL:self.Id];
            webView.backItem = YES;
            webView.hidesBottomBarWhenPushed = YES;
            return webView;
        }
            break;
        case WMHomeAdTypeCategoryList :
        {
            UIViewController *root = [AppDelegate rootViewController];
            UINavigationController *nav = nil;
            if([root isKindOfClass:[UINavigationController class]])
            {
                nav = (UINavigationController*)root;
            }
            else if ([root isKindOfClass:[WMTabBarController class]])
            {
                WMTabBarController *tab = (WMTabBarController*)root;
                root = tab.selectedViewController;
                if([root isKindOfClass:[UINavigationController class]])
                {
                    nav = (UINavigationController*)root;
                }
            }
            
            
            if([AppDelegate tabBarController].selectedIndex == 1)
            {
                [nav backToRootViewControllerWithAnimated:YES];
            }
            else
            {
                [nav backToRootViewControllerWithAnimated:NO];
                [AppDelegate tabBarController].selectedIndex = 1;
            }
            
            ///显示分类
            nav = (UINavigationController*)[AppDelegate tabBarController].selectedViewController;
            WMCategoryBrandViewController *category = (WMCategoryBrandViewController*)[nav.viewControllers firstObject];
            [category showViewAtIndex:0];
        }
            break;
        case WMHomeAdTypeTopup :
        {
            if(![AppDelegate instance].isLogin)
            {
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                    
                    [self topup];
                }];
            }
            else
            {
                [self topup];
            }
        }
            break;
        case WMHomeAdTypePresellGoodList :
        {
            WMGoodListViewController *list = [[WMGoodListViewController alloc] init];
            list.titleName = self.text;
            list.onlyPresell = YES;
            return list;
        }
            break;
        case WMHomeAdTypeDrawCoupons :
        {
            WMDrawCouponsViewController *draw = [[WMDrawCouponsViewController alloc] init];
            return draw;
        }
    }
    
    return nil;
}

///去签到
- (void)signin
{
    WMIntegralSignInViewController *signin = [[WMIntegralSignInViewController alloc] init];
    [self pushViewController:signin];
}

///摇一摇
- (void)shake
{
    WMShakeViewController *shake = [[WMShakeViewController alloc] init];
    [self pushViewController:shake];
}

///充值
- (void)topup
{
    WMTopupAdViewController *topup = [[WMTopupAdViewController alloc] init];
    [self pushViewController:topup];
}

- (void)pushViewController:(UIViewController*) vc
{
    [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:[AppDelegate rootViewController]];
}

@end
