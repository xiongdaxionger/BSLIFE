//
//  AppDelegate.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WMImageInitialization.h"
#import "WMPriceOperation.h"

///app跳转返回通知
#define WMApplicationDidOpenURLNotification @"WMApplicationDidOpenURLNotification"
#define WMApplicationDidOpenURLKey @"URL"

@class WMTabBarController, WMLoginViewController ,WMShareActionSheetContentView, WMSocialLoginOperation;

@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

///载入信息
@property(nonatomic,strong) NSDictionary *launchOptions;

/**
 *  正在分享的视图，用于监听app的状态，防止 在ios9中 app取消跳转的时候 分享没回调，菊花还在转
 */
@property (strong, nonatomic) WMShareActionSheetContentView *shareActionSheet;

/**是否登录
 */
@property (nonatomic, assign) BOOL isLogin;

///是否是微信登录
@property (assign,nonatomic) BOOL isPushToWeiXinLogin;

///当前登录操作
@property (nonatomic, weak) WMSocialLoginOperation *socialLoginOperation;

///获取appDelegate
+ (instancetype)instance;

///获取选项卡
+ (WMTabBarController*)tabBarController;

///获取当前rootViewController ，用来present
+ (UIViewController*)rootViewController;

///获取当前的UINavigationController ，用来push，如果没有则返回nil
+ (UINavigationController*)navigationController;

/**判断请求结果是否需要重新登录，如果需要，会自动弹出登录窗口
 *@param dic 包含请求错误信息的字典
 *@return 是否需要登录
 */
+ (BOOL)needLoginFromDictionary:(NSDictionary*) dic;

/**弹出登录窗口
 *@param flag 是否动画
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL) flag;

/**弹出登录窗口
 *@param flag 是否动画
 *@param completion 动画完成
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL) flag completion:(void(^)(void)) completion;

/**弹出登录窗口
 *@param flag 是否动画
 *@param completion 动画完成
 *@param loginCompletion 登录完成回调
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL) flag completion:(void(^)(void)) completion loginCompletion:(void(^)(void)) loginCompletion;

/**提示信息
 *@param msg 要提示的信息
 */
- (void)alertMsg:(NSString*) msg;

///上传设备token
- (void)uploadToken;

/**是否显示网络活动指示器
 */
@property(nonatomic,assign) BOOL showNetworkActivity;


@end

