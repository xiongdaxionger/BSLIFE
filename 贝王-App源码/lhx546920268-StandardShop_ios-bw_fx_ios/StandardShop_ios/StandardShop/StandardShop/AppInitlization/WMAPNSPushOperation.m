//
//  WMAPNSPushOperation.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMAPNSPushOperation.h"
#import "XGPush.h"
#import <UserNotifications/UserNotifications.h>

@implementation WMAPNSPushOperation

/**注册信鸽远程推送
 *@param launchOptions 在appDelegate 中的 didFinishLaunchingWithOptions 中的参数
 */
+ (void)registerRemoteNofiticationWithLaunchOptions:(NSDictionary*) launchOptions
{
    ///判断是否已开启勿打扰模式
    if([SeaUserDefaults boolForKey:WuDaYaoMoShiKey])
    {
        return;
    }
    
    [XGPush startApp:2200253555 appKey:@"I13DU16NL9MH"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
            if(_ios8_0_)
            {
                if (_ios10_0_) {
                    
                    [WMAPNSPushOperation registerPushForIOS10];
                }
                else{
                
                    [WMAPNSPushOperation registerPushForIOS8];
                }
            }
            else
            {
                [WMAPNSPushOperation registerPush];
            }
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    [XGPush handleLaunching:launchOptions
            successCallback:successBlock
              errorCallback:errorBlock];
}

/**注销推送
 */
+ (void)unregisterRemoteNofitication
{
    [XGPush unRegisterDevice];
}

///ios8之后的apns注册方式
+ (void)registerPushForIOS8
{
#ifdef __IPHONE_8_0
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication]
     registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

//ios10推送注册
+ (void)registerPushForIOS10{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            
            NSLog(@"允许");
            
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                
            }];
        }
        else{
            
            NSLog(@"不允许");
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

///ios8以前的注册方式
+ (void)registerPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

#pragma mark- appDelegate

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification
                            userInfoKey:@"clockID"
                          userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
}


//ios8 之后的注册代理 按钮点击事件回调
+ (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler
{
    
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken];
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken:");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [XGPush registerDevice:deviceToken
           successCallback:successBlock
             errorCallback:errorBlock];
    
    [SeaUserDefaults setObject:deviceTokenStr forKey:WMTokenKey];
    [[AppDelegate instance] uploadToken];
    
    //打印获取的deviceToken的字符串
#if SeaDebug
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
#endif
}

//如果deviceToken获取不到会进入此事件
+ (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
#if SeaDebug
    NSString *str = [NSString stringWithFormat: @"Error And Get Token fail: %@",err];
    NSLog(@"%@",str);
#endif
}

+ (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
}

@end
