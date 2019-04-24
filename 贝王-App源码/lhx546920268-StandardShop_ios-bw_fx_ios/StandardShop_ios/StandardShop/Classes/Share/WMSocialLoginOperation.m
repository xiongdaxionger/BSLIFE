//
//  WMSocialLoginOperation.m
//  StandardShop
//
//  Created by 罗海雄 on 16/9/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSocialLoginOperation.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WMShareOperation.h"

///获取授权请求标识token
#define WMSocialWeixinTokenIdentifier @"WMSocialWeixinTokenIdentifier"

///获取微信用户信息标识
#define WMSocialWeixinUserInfoIdentifier @"WMSocialWeixinUserInfoIdentifier"

@implementation WMSocialCredential

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.platformType = [aDecoder decodeIntegerForKey:@"platformType"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.platformType forKey:@"platformType"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

@end

@implementation WMSocialUser

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.platformType = [aDecoder decodeIntegerForKey:@"platformType"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.credential = [aDecoder decodeObjectForKey:@"credential"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.unionid = [aDecoder decodeObjectForKey:@"unionid"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.platformType forKey:@"platformType"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.credential forKey:@"credential"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.unionid forKey:@"unionid"];
}

@end

@interface WMSocialLoginOperation()<WXApiDelegate,SeaHttpRequestDelegate>

///qq授权
@property(nonatomic,strong) TencentOAuth *qqOAuth;

///完成回调
@property(nonatomic,copy) WMSocialLoginCompletionHandler completionHandler;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///微信授权凭证
@property(nonatomic,strong) WMSocialCredential *weixinCredential;

///正在授权
@property(nonatomic,assign) BOOL authing;

@end

@implementation WMSocialLoginOperation

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///第三方登录
- (void)authorize:(WMPlatformType)platformType
       completion:(WMSocialLoginCompletionHandler) completion
{
    self.authing = YES;
    
    self.completionHandler = completion;
    switch (platformType) {
        case WMPlatformTypeQQ :
        {
            TencentOAuth *auth = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:(id<TencentSessionDelegate>)self];
            self.qqOAuth = auth;
            [auth authorize:[NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil]];
        }
            break;
        case WMPlatformTypeWeixin :
        {
            SendAuthReq* req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_message,snsapi_userinfo";
            
            [WXApi sendAuthReq:req
                       viewController:[AppDelegate rootViewController]
                             delegate:self];
        }
            break;
        default:
            break;
    }
}

- (void)setAuthing:(BOOL)authing
{
    if(_authing != authing)
    {
        _authing = authing;
        if(_authing)
        {
            ///添加应用进入前台，用于第一次应用跳转时有弹窗，用户点取消会知道
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidOpenURL:) name:WMApplicationDidOpenURLNotification object:nil];
        }
    }
}

#pragma mark- 通知

///应用唤醒
- (void)applicationDidBecomeActive:(NSNotification*) notification
{
    if(self.authing)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self performSelector:@selector(authFail) withObject:nil afterDelay:1.0];
    }
}

///应用进入后台
- (void)applicationWillResignActive:(NSNotification*) notification
{
    if(self.authing)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
    }
}

///应用打开
- (void)applicationDidOpenURL:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WMApplicationDidOpenURLNotification object:nil];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    NSURL *url = [notification.userInfo objectForKey:WMApplicationDidOpenURLKey];
    if(self.qqOAuth)
    {
        [TencentOAuth HandleOpenURL:url];
    }
    else
    {
        [WXApi handleOpenURL:url delegate:self];
    }
}

#pragma mark- TencentSession delegate


- (void)tencentDidLogin
{
    [self.qqOAuth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self authFail];
}

- (void)tencentDidNotNetWork
{
    [self authFail];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    self.authing = NO;
    if(response.retCode == URLREQUEST_SUCCEED)
    {
        WMSocialUser *user = [[WMSocialUser alloc] init];
        
        WMSocialCredential *credential = [[WMSocialCredential alloc] init];
        credential.uid = self.qqOAuth.openId;
        credential.token = self.qqOAuth.accessToken;
        credential.platformType = WMPlatformTypeQQ;
        
        user.credential = credential;
        user.platformType = WMPlatformTypeQQ;
        
        user.uid = self.qqOAuth.openId;
        
        NSDictionary *json = response.jsonResponse;
        user.nickname = [json sea_stringForKey:@"nickname"];
        user.icon = [json sea_stringForKey:@"figureurl"];
        user.sex = [[json sea_stringForKey:@"gender"] isEqualToString:@"男"] ? WMUserInfoBoy : WMUserInfoGirl;
        
        !self.completionHandler ?: self.completionHandler(YES, user, nil);
    }
    else
    {
        [self authFail];
    }
}

#pragma mark- WXApi delegate

- (void)onResp:(BaseResp *)resp
{
    self.authing = NO;
    if(resp.errCode == 0 && [resp isKindOfClass:SendAuthResp.class])
    {
        SendAuthResp *auth = (SendAuthResp*)resp;
        if(!self.httpRequest)
        {
            self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        }
        
        self.httpRequest.identifier = WMSocialWeixinTokenIdentifier;
        [self.httpRequest downloadWithURL:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeixinAppId, WeixinAppSecret, auth.code]];
    }
    else
    {
        [self authFail];
    }
}


///授权失败
- (void)authFail
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    self.authing = NO;
    !self.completionHandler ?: self.completionHandler(NO, nil, nil);
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self authFail];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMSocialWeixinTokenIdentifier])
    {
        NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
        
        if(![dic sea_stringForKey:@"errcode"])
        {
            WMSocialCredential *credential = [[WMSocialCredential alloc] init];
            credential.uid = [dic sea_stringForKey:@"openid"];
            credential.token = [dic sea_stringForKey:@"access_token"];
            credential.platformType = WMPlatformTypeWeixin;
            self.weixinCredential = credential;
            
            self.httpRequest.identifier = WMSocialWeixinUserInfoIdentifier;
            [self.httpRequest downloadWithURL:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", credential.token, credential.uid]];
        }
        else
        {
            [self authFail];
        }
        return;
    }
    
    if([request.identifier isEqualToString:WMSocialWeixinUserInfoIdentifier])
    {
        NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
        
        if(![dic sea_stringForKey:@"errcode"])
        {
            WMSocialUser *user = [[WMSocialUser alloc] init];
            user.credential = self.weixinCredential;
            user.platformType = WMPlatformTypeWeixin;
            user.uid = self.weixinCredential.uid;

            user.nickname = [dic sea_stringForKey:@"nickname"];
            user.icon = [dic sea_stringForKey:@"headimgurl"];
            user.sex = [[dic numberForKey:@"sex"] boolValue] == 1 ? WMUserInfoBoy : WMUserInfoGirl;
            user.unionid = [dic sea_stringForKey:@"unionid"];
            
            !self.completionHandler ?: self.completionHandler(YES, user, nil);
        }
        else
        {
            [self authFail];
        }
    }
    
}

#pragma mark- class method

///保存在NSUserDefaults 中的授权信息
#define WMSocialAuthKey @"WMSocialAuthKey"

/**保存授权
 */
+ (void)saveSocialAuth:(WMSocialUser*) user
{
    if(user)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [SeaUserDefaults setObject:data forKey:WMSocialAuthKey];
        [SeaUserDefaults removeObjectForKey:WMLoginAccount];
        [SeaUserDefaults removeObjectForKey:WMLoginPassword];
    }
}

/**取消授权
 */
+ (void)cancelSocialAuth
{
    [SeaUserDefaults removeObjectForKey:WMSocialAuthKey];
}

/**获取授权
 */
+ (WMSocialUser*)socialAuth
{
    NSData *data = [SeaUserDefaults objectForKey:WMSocialAuthKey];
    if(data)
    {
        WMSocialUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return user;
    }
    
    return nil;
}

@end
