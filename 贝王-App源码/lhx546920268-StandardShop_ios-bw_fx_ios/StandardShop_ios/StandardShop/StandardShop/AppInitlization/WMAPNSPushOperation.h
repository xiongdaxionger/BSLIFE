//
//  WMAPNSPushOperation.h
//  AKYP
//
//  Created by 罗海雄 on 15/11/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///推送相关的操作
@interface WMAPNSPushOperation : NSObject

/**注册信鸽远程推送
 *@param launchOptions 在appDelegate 中的 didFinishLaunchingWithOptions 中的参数
 */
+ (void)registerRemoteNofiticationWithLaunchOptions:(NSDictionary*) launchOptions;

/**注销推送
 */
+ (void)unregisterRemoteNofitication;

#pragma mark- appDelegate

+ (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

//按钮点击事件回调
+ (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler;

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

//如果deviceToken获取不到会进入此事件
+ (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err;

+ (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

@end
