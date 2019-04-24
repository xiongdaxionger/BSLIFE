//
//  WMShareOperation.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMShareOperation.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"

//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

@implementation WMShareOperation

///注册分享
+ (void)registerShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"15d9f6501dfd0"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                         {
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                         }
                             break;
                         case SSDKPlatformTypeQQ:
                         {
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                         }
                             
                             break;
                         case SSDKPlatformTypeSinaWeibo :
                         {
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                         }
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:WeixinAppId
                                            appSecret:WeixinAppSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQAppId
                                           appKey:QQAppKey
                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSinaWeibo :
                  {
                      [appInfo SSDKSetupSinaWeiboByAppKey:WeiboAppKey appSecret:WeiboAppSecret redirectUri:[NSString stringWithFormat:@"http://%@", SeaNetworkDomainName] authType:SSDKAuthTypeBoth];
                  }
                      break;
                  default:
                      break;
              }
          }];
}

/**打开QQ并打开和对应的用户的聊天窗口
 *@param qq号码
 */
+ (void)openQQWithQQ:(NSString *)qq
{
    QQApiSendResultCode code = [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:[QQApiWPAObject objectWithUin:qq]]];
    
    if(code != EQQAPISENDSUCESS)
    {
        NSLog(@"打开QQ并打开和对应的用户的聊天窗口 error = %d", code);
    }
}

/**打开问下并打开对应的聊天窗口
 *@param weixin 微信号码
 */
+ (void)openWeinxinWithUserName:(NSString *)username
{
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
    
    req.username = username;
    
    [WXApi sendReq:req];
}

@end
