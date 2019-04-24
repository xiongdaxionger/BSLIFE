//
//  WMSocialLoginOperation.h
//  StandardShop
//
//  Created by 罗海雄 on 16/9/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///平台
typedef NS_ENUM(NSInteger,WMPlatformType)
{
    ///未知
    WMPlatformTypeNotknow = 0,
    
    ///qq
    WMPlatformTypeQQ = 1,
    
    ///微信
    WMPlatformTypeWeixin = 2,
};

@class WMSocialUser;

///第三方登录完成回调
typedef void (^WMSocialLoginCompletionHandler)(BOOL success, WMSocialUser *user, NSError *error);

///第三方登录授权凭证
@interface WMSocialCredential : NSObject<NSCoding>

///用户标识
@property (nonatomic, copy) NSString *uid;

///用户令牌
@property (nonatomic, copy) NSString *token;

///平台类型
@property (nonatomic, assign) WMPlatformType platformType;

@end

///第三方登录用户信息
@interface WMSocialUser : NSObject<NSCoding>

///平台类型
@property (nonatomic, assign) WMPlatformType platformType;

///授权凭证， 为nil则表示尚未授权
@property (nonatomic, strong) WMSocialCredential *credential;

///用户标识
@property (nonatomic, copy) NSString *uid;

///昵称
@property (nonatomic, copy) NSString *nickname;

///头像
@property (nonatomic, copy) NSString *icon;

///性别
@property (nonatomic, copy) NSString *sex;

///用户唯一标识符
@property (nonatomic, copy) NSString *unionid;

@end




///第三方登录操作
@interface WMSocialLoginOperation : NSObject

///第三方登录
- (void)authorize:(WMPlatformType)platformType
       completion:(WMSocialLoginCompletionHandler) completion;

/**保存授权
 */
+ (void)saveSocialAuth:(WMSocialUser*) user;

/**取消授权
 */
+ (void)cancelSocialAuth;

/**获取授权
 */
+ (WMSocialUser*)socialAuth;

@end
