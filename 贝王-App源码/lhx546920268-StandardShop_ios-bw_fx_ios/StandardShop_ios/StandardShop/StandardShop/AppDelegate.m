//
//  AppDelegate.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "AppDelegate.h"
#import "SeaCacheCrash.h"
#import "WMLoginViewController.h"
#import "WMPhoneInputViewController.h"
#import "WMUserOperation.h"
#import "WMShopCarOperation.h"
#import "WMShareOperation.h"
#import "WMAPNSPushOperation.h"
#import "WMInitialization.h"
#import "WMTabBarController.h"
#import "WMUserInfo.h"
#import "WMGuidePage.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WMDoPaymemtClient.h"
#import <MAMapKit/MAMapKit.h>
#import "WMSocialLoginOperation.h"
#import "WMUnionPayClient.h"
#import "WMServerTimeOperation.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <UserNotifications/UserNotifications.h>

/**自动登录间隔
 */
#define WMAutoLoginTimeInterval 25 * 60

@interface AppDelegate ()<SeaNetworkQueueDelegate,WMGuidePageDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate>

/**最后的登录时间
 */
@property(nonatomic,strong) NSDate *lastLoginDate;

/**自动登录计时器
 */
@property(nonatomic,strong) NSTimer *loginTimer;

/**网络请求 队列
 */
@property(nonatomic,strong) SeaNetworkQueue *queue;

/**提示信息
 */
@property(nonatomic,strong) SeaPromptView *msgAlertView;

/**活动指示
 */
@property(nonatomic,strong) SeaNetworkActivityView *networkActivityView;

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

/**是否是第一次登陆
 */
@property (nonatomic, assign) BOOL isFirstTimeLogin;

@end

@implementation AppDelegate

///获取appDelegate
+ (instancetype)instance
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

///获取选项卡
+ (WMTabBarController*)tabBarController
{
    WMTabBarController *tab = (WMTabBarController*)[AppDelegate instance].window.rootViewController;
    if([tab isKindOfClass:[WMTabBarController class]])
    {
        return tab;
    }
    
    return nil;
}

///获取当前rootViewController ，用来present
+ (UIViewController*)rootViewController
{
    AppDelegate *app = [AppDelegate instance];
    return [app.window.rootViewController topestPresentedViewController];
}

///获取当前的UINavigationController ，用来push，如果没有则返回nil
+ (UINavigationController*)navigationController
{
    UIViewController *root = [AppDelegate rootViewController];
    if([root isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController*)root;
    }
    else if ([root isKindOfClass:[WMTabBarController class]])
    {
        WMTabBarController *tab = (WMTabBarController*)root;
        root = tab.selectedViewController;
        if([root isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController*)root;
        }
    }
    
    return root.navigationController;
}

/**判断请求结果是否需要重新登录，如果需要，会自动弹出登录窗口
 *@param dic 包含请求错误信息的字典
 *@return 是否需要登录
 */
+ (BOOL)needLoginFromDictionary:(NSDictionary*) dic
{
    NSString *code = [dic sea_stringForKey:WMHtppErrorCode];
    if([code isEqualToString:WMHttpNeedLogin])
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES];

        NSString *errMsg = [dic sea_stringForKey:WMHttpMessage];
        if([NSString isEmpty:errMsg])
        {
            errMsg = [dic sea_stringForKey:WMHttpData];
        }
        
        NSLog(@"需要重新登录 %@", errMsg);
        
        return YES;
    }
    else
    {
        NSLog(@"err msg = %@", [dic sea_stringForKey:WMHttpMessage]);
    }
    
    return NO;
}

/**弹出登录窗口
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL)flag
{
    return [self showLoginViewControllerWithAnimate:flag completion:nil];
}

/**弹出登录窗口
 *@param flag 是否动画
 *@param completion 动画完成
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL) flag completion:(void(^)(void)) completion
{
    return [self showLoginViewControllerWithAnimate:flag completion:completion loginCompletion:nil];
}

/**弹出登录窗口
 *@param flag 是否动画
 *@param completion 动画完成
 *@param loginCompletion 登录完成回调
 */
- (WMLoginViewController*)showLoginViewControllerWithAnimate:(BOOL) flag completion:(void(^)(void)) completion loginCompletion:(void(^)(void)) loginCompletion
{
    UIViewController *root = [AppDelegate rootViewController];
    
    ///判断登录窗口是否已弹出
    if([root isKindOfClass:[WMLoginViewController class]] || [root isKindOfClass:[WMPhoneInputViewController class]])
    {
        return [root isKindOfClass:[WMLoginViewController class]] ? (WMLoginViewController*)root : nil;
    }
    
    if([root isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)root;
        WMLoginViewController *login = nav.viewControllers.firstObject;
        
        if([login isKindOfClass:[WMLoginViewController class]] || [login isKindOfClass:[WMPhoneInputViewController class]])
        {
            return [root isKindOfClass:[WMLoginViewController class]] ? (WMLoginViewController*)root : nil;
        }
    }
    
    [self cancelLogin];
    [self.queue cancelRequestWithIdentifier:WMLoginIdentifier];
    
    WMLoginViewController *login = [[WMLoginViewController alloc] init];
    login.loginCompletionHandler = loginCompletion;
    
    
    
    UINavigationController *nav = [login createdInNavigationController];
    
    SeaPresentTransitionDelegate *delegate = [[SeaPresentTransitionDelegate alloc] init];
    delegate.transitionStyle = SeaPresentTransitionStyleCoverVertical;
    delegate.duration = 0.25;
    nav.sea_transitioningDelegate = delegate;
    
    [root presentViewController:nav animated:flag completion:completion];
    
    return login;
}

#pragma mark- login

/**启动登录计时器
 */
- (void)startLoginTimer
{
    if(!self.loginTimer)
    {
        //已登录的时长
        NSTimeInterval timeInterval = fabs([self.lastLoginDate timeIntervalSinceNow]);
        timeInterval = MAX(0, WMAutoLoginTimeInterval - timeInterval);
        
        self.loginTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] interval:WMAutoLoginTimeInterval target:self selector:@selector(autoLogin) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.loginTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopLoginTimer
{
    if(self.loginTimer && [self.loginTimer isValid])
    {
        [self.loginTimer invalidate];
        self.loginTimer = nil;
    }
}

/**自动登录
 */
- (void)autoLogin
{
    if(self.isFirstTimeLogin)
    {
        self.isLogin = NO;
    }
    
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginAccount];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginPassword];
    
    ///判断是否是注册用户登录
    if(![NSString isEmpty:account] && ![NSString isEmpty:password])
    {
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMUserOperation loginParamWithAccout:account password:password code:nil] identifier:WMLoginIdentifier];
        [self.queue startDownload];
    }
    else
    {
        ///判断是否是社交账号登录
        WMSocialUser *user = [WMSocialLoginOperation socialAuth];
        if(user != nil)
        {
            [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMUserOperation socialLoginWithUser:user] identifier:WMSocialLoginIdentifier];
            [self.queue startDownload];
        }
    }
}

///取消登录
- (void)cancelLogin
{
    if([self.queue isRequestingWithIdentifier:WMLoginIdentifier] || [self.queue isRequestingWithIdentifier:WMSocialLoginIdentifier])
    {
        [self.queue cancelRequestWithIdentifier:WMLoginIdentifier];
        [self.queue cancelRequestWithIdentifier:WMSocialLoginIdentifier];
        [[NSNotificationCenter defaultCenter] postNotificationName:WMUserAutoLoginDidFailNotification object:nil];
    }

    self.isLogin = NO;
    [self stopLoginTimer];
    [WMUserInfo logout];
    self.lastLoginDate = nil;
    self.loginCompletionHandler = nil;
    self.isFirstTimeLogin = YES;
}

/**登录成功
 */
- (void)loginDidFinish:(NSNotification*) notification
{
    self.isFirstTimeLogin = NO;
    self.isLogin = YES;

    [self startLoginTimer];
    
    [self uploadToken];

    ///加载系统时间
    [[WMServerTimeOperation sharedInstance] loadServerTime];
}

///上传设备token
- (void)uploadToken
{
    if(!self.isLogin)
        return;
    
    if(![SeaUserDefaults objectForKey:WMTokenKey])
    {
        return;
    }
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMUserOperation saveTokenParam:[SeaUserDefaults objectForKey:WMTokenKey]] identifier:@"WMToken"];
    [self.queue startDownload];
}

#pragma mark- queue

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMLoginIdentifier] || [identifier isEqualToString:WMSocialLoginIdentifier])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMUserAutoLoginDidFailNotification object:nil];
        return;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMLoginIdentifier])
    {
        WMLoginResult result = [WMUserOperation loginResultFromData:data alertFailMsg:NO errorMsg:nil codeURL:nil];
        if(result == WMLoginResultSuccess)
        {
            self.isLogin = YES;
            if(self.isFirstTimeLogin)
            {
                self.isFirstTimeLogin = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:WMLoginSuccessNotification object:nil];
            }
            else
            {
                self.lastLoginDate = [NSDate date];
            }
            
            if(self.loginCompletionHandler)
            {
                self.loginCompletionHandler();
                self.loginCompletionHandler = nil;
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WMUserAutoLoginDidFailNotification object:nil];
            self.isLogin = NO;
        }
        return;
    }
    
    if([identifier isEqualToString:WMSocialLoginIdentifier])
    {
        WMLoginResult result = [WMUserOperation socialLoginResultFromData:data alertFailMsg:NO];
        if(result == WMLoginResultSuccess)
        {
            [[WMUserInfo sharedUserInfo] saveUserInfoToUserDefaults];
            
            self.isLogin = YES;

            if(self.isFirstTimeLogin)
            {
                self.isFirstTimeLogin = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:WMLoginSuccessNotification object:nil];
            }
            else
            {
                self.lastLoginDate = [NSDate date];
            }
            
            if(self.loginCompletionHandler)
            {
                self.loginCompletionHandler();
                self.loginCompletionHandler = nil;
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WMUserAutoLoginDidFailNotification object:nil];
            self.isLogin = NO;
        }
        return;
    }
    
//    if ([identifier isEqualToString:WMGetShopCarListIdentifier]) {
//        
//        [AppDelegate instance].shopCarNum = [WMShopCarOperation returnShopCarQuantityWithData:data];
//        
//        [WMShopCarOperation updateBadgeValue];
//        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"WMGetShopCarListSuccess" object:nil];
//    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

#pragma mark- appDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.launchOptions = launchOptions;
    
#ifdef __IPHONE_10_0

    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
#endif
    
    
    ///异常捕获
    NSSetUncaughtExceptionHandler(&uncacheExceptionHandler);
    
    ///监听登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinish:) name:WMLoginSuccessNotification object:nil];
    
    [WMInitialization initialization];
    [[UITableView appearance] setSeparatorColor:_separatorLineColor_];
    
    ///创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    
    [WMTabBarController initialization];
    
    [self.window makeKeyAndVisible];
    
    //引导页
    if([WMGuidePage shouldShowGuidePage])
    {
        WMGuidePage *page = [[WMGuidePage alloc] init];
        
        page.delegate = self;
        
        [page show];
    }

    [self operationAfterLaunch];
    
    return YES;
}

//程序载入后的操作
- (void)operationAfterLaunch
{
    /**
     *  推送信息
     */
    NSDictionary *pushNotificationUserInfo = [self.launchOptions dictionaryForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [self dealWithAPNSUserInfo:pushNotificationUserInfo];
    
    ///注册分享
    [WMShareOperation registerShareSDK];
    
    //注册推送
    [WMAPNSPushOperation registerRemoteNofiticationWithLaunchOptions:self.launchOptions];
    
    if([WMUserInfo isOnceLogin])
    {
        ///设置cookie信息，防止后台开启验证码时登录失败
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginAccount];
        WMUserInfo *info = [WMUserInfo sharedUserInfo];
        if(account && info.userId)
        {
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:SeaNetworkDomainName, NSHTTPCookieDomain, account, NSHTTPCookieValue, @"UNAME", NSHTTPCookieName, @"/", NSHTTPCookiePath, nil]];
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];


            cookie = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:SeaNetworkDomainName, NSHTTPCookieDomain, info.userId, NSHTTPCookieValue, @"S[MEMBER]", NSHTTPCookieName, @"/", NSHTTPCookiePath, nil]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
        }

        self.isFirstTimeLogin = YES;
        [self autoLogin];
    }else{
        ///加载系统时间
        [[WMServerTimeOperation sharedInstance] loadServerTime];
    }
    
    ///配置高德地图key
    [MAMapServices sharedServices].apiKey = MAMapKey;
}


#pragma mark- WMGuidePage delegate

- (void)guideWillDisappear:(WMGuidePage *)guildPage
{
    //[self operationAfterLaunch];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self stopLoginTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self startLoginTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if(url)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMApplicationDidOpenURLNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:url, WMApplicationDidOpenURLKey, nil]];
    }
    
    return [self getCallBackWithSourceStr:sourceApplication url:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    
    NSString *sourceStr = [options sea_stringForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    
    if(url)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMApplicationDidOpenURLNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:url, WMApplicationDidOpenURLKey, nil]];
    }
    
    return  [self getCallBackWithSourceStr:sourceStr url:url];
}

- (BOOL)getCallBackWithSourceStr:(NSString *)sourceStr url:(NSURL *)url{
    
    if ([sourceStr isEqualToString:@"com.alipay.iphoneclient"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        return YES;
    }
    else if ([sourceStr isEqualToString:@"com.tencent.xin"])
    {
        //通知要加入订单类型
        if(self.isPushToWeiXinLogin)
        {
            
        }
        else
        {
            return  [WXApi handleOpenURL:url delegate:[WeiCharPayClient new]];
        }
    }
    else{
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            DoPayCallBackType resultType = DoPayCallBackTypeUnkonw;
            
            if([code isEqualToString:@"success"]) {
                
                resultType = DoPayCallBackTypeSuccess;
            }
            else if([code isEqualToString:@"fail"]) {
                
                resultType = DoPayCallBackTypeFail;
            }
            else if([code isEqualToString:@"cancel"]) {
                
                resultType = DoPayCallBackTypeCancel;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(resultType)}];
        }];
    }
    
    return YES;
}

#pragma mark- APNS

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [WMAPNSPushOperation application:application didReceiveLocalNotification:notification];
}

#ifdef __IPHONE_8_0

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    [WMAPNSPushOperation application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [WMAPNSPushOperation application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    [WMAPNSPushOperation application:app didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    //推送反馈(app运行时)
    [WMAPNSPushOperation application:application didReceiveRemoteNotification:userInfo];
    [self dealWithAPNSUserInfo:userInfo];
}

#ifdef __IPHONE_10_0

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    [self dealWithAPNSUserInfo:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

#pragma mark- 提示信息

/**提示信息
 *@param msg 要提示的信息
 */
- (void)alertMsg:(NSString*) msg
{
    if(!self.msgAlertView)
    {
        
        SeaPromptView *alertView = [[SeaPromptView alloc] initWithFrame:CGRectMake((_width_ - _seaAlertViewWidth_) / 2.0, (_height_ - _seaAlertViewHeight_) / 2.0, _seaAlertViewWidth_, _seaAlertViewHeight_) message:msg];
        [self.window addSubview:alertView];
        alertView.removeFromSuperViewAfterHidden = NO;
        self.msgAlertView = alertView;
    }
    
    self.msgAlertView.messageLabel.text = msg;
    [self.window bringSubviewToFront:self.msgAlertView];
    [self.msgAlertView showAndHideDelay:2.0];
}

- (void)setShowNetworkActivity:(BOOL)showNetworkActivity
{
    if(_showNetworkActivity != showNetworkActivity)
    {
        _showNetworkActivity = showNetworkActivity;
        if(_showNetworkActivity)
        {
            if(!_networkActivityView)
            {
                CGFloat width = 100.0;
                CGFloat height = 70.0;
                SeaNetworkActivityView *view = [[SeaNetworkActivityView alloc] initWithFrame:CGRectMake((_width_ - width) / 2.0, (_height_ - height) / 2.0, width, height)];
                [self.window addSubview:view];
                self.networkActivityView = view;
            }
            
            [self.window bringSubviewToFront:self.networkActivityView];
            self.networkActivityView.msg = @"请稍后..";
            self.networkActivityView.hidden = NO;
        }
        else
        {
            self.networkActivityView.hidden = YES;
        }
        
        UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
        if([nav isKindOfClass:[UINavigationController class]])
        {
            UIViewController *vc = [nav.viewControllers lastObject];
            vc.view.userInteractionEnabled = !_showNetworkActivity;
        }
        else
        {
            self.window.userInteractionEnabled = !_showNetworkActivity;
        }
    }
}

#pragma mark- 短信

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled :
        {
            
        }
            break;
        case MessageComposeResultFailed :
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"发送短信失败,请检查该设备是否具有发送短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case MessageComposeResultSent :
        {
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate alertMsg:@"发送成功"];
        }
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 推送消息

///处理收到的推送消息
- (void)dealWithAPNSUserInfo:(NSDictionary*) userInfo
{
    if(userInfo.count == 0)
        return;
    
    NSString *type = [userInfo sea_stringForKey:@"type"];
    
    NSString *link = [userInfo sea_stringForKey:@"link"];
    
    NSString *title = [userInfo sea_stringForKey:@"title"];
    
    ///打开秒杀
    if ([type isEqualToString:@"starbuy"]) {
        
        [[AppDelegate tabBarController] openSecondKill];
        
        return;
    }
    
    //打开商品详情
    if([type isEqualToString:@"product"])
    {
        [[AppDelegate tabBarController] openGoodDetailWithId:link title:title];
        return;
    }
    
    ///打开分类
    if ([type isEqualToString:@"cat"]) {
        
        [[AppDelegate tabBarController] openCategoryWithID:link title:title];
        
        return;
    }
    
    ///打开品牌
    if ([type isEqualToString:@"brand"]) {
        
        [[AppDelegate tabBarController] openBrandWithId:link title:title];
        
        return;
    }
    
    ///打开学院文章
    if([type isEqualToString:@"article"])
    {
        [[AppDelegate tabBarController] openCollegeWithId:link title:title];
        return;
    }
    
    ///打开领券中心
    if ([type isEqualToString:@"coupons"]) {
        
        [[AppDelegate tabBarController] openActivityCoupon];
        
        return;
    }
    
    ///自定义链接
    if ([type isEqualToString:@"custom"]) {
        
        [[AppDelegate tabBarController] openCustomLink:link title:title];
        
        return;
    }
    //判断是否已登录，没登陆要登陆完成后打开
//    if(self.isLogin && self.loginCompletionHandler != nil)
//    {
//        self.loginCompletionHandler();
//        self.loginCompletionHandler = nil;
//    }
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"去设置"])
    {
        openSystemSettings();
    }
}

@end
