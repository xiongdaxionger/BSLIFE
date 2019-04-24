//
//  WMShareOperation.h
//  AKYP
//
//  Created by 罗海雄 on 15/11/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///分享key

#define QQAppId @"1105567706"
#define QQAppKey @"AWFbWyNuZVUAVPvU"
#define WeixinAppId @"wx8007798dfc384ed9"
#define WeixinAppSecret @"61688686bd70167a1bca62024fe73ee2"

#define WeiboAppKey @"965767690"
#define WeiboAppSecret @"84b4c794894f9e5fc5020663e9f627e7"

///有关分享的操作
@interface WMShareOperation : NSObject

///注册分享，在APPDelegate 中调用
+ (void)registerShareSDK;

/**打开QQ并打开和对应的用户的聊天窗口
 *@param qq号码
 */
+ (void)openQQWithQQ:(NSString*) qq;

/**打开问下并打开对应的聊天窗口
 *@param weixin 微信号码
 */
+ (void)openWeinxinWithUserName:(NSString*) username;

@end
