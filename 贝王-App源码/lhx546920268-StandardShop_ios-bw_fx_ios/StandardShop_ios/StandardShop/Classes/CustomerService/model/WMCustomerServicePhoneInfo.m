//
//  WMCustomerServicePhoneInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCustomerServicePhoneInfo.h"
#import "WMCustomerServiceInfo.h"
#import "WMCustomerServiceOperation.h"

@interface WMCustomerServicePhoneInfo ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///完成回调
@property(nonatomic,copy) void(^completion)(void);

@end

@implementation WMCustomerServicePhoneInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        ///添加登录登出监听
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:WMLoginSuccessNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:WMUserDidLogoutNotification object:nil];
    }
    
    return self;
}

///单例
+ (instancetype)shareInstance
{
    static WMCustomerServicePhoneInfo *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        info = [[WMCustomerServicePhoneInfo alloc] init];
        
    });
    
    return info;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString*)call
{
    if([AppDelegate instance].isLogin)
    {
        return ![NSString isEmpty:self.uplinePhoneNumber] ? self.uplinePhoneNumber : self.servicePhoneNumber;
    }
    else
    {
        return self.servicePhoneNumber;
    }
}

- (NSString*)intro
{
    if(_intro)
        return _intro;
    return @"";
}

- (BOOL)loading
{
    return self.httpRequest.requesting;
}

#pragma mark- 通知

///登录
- (void)userDidLogin:(NSNotification*) notification
{
    [self loadInfo];
}

///登出
- (void)userDidLogout:(NSNotification*) notification
{
    [self clear];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.httpRequest = nil;
    !self.completion ?: self.completion();
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    [WMCustomerServiceOperation returnCustomServiceResultWithData:data];
    !self.completion ?: self.completion();
    self.httpRequest = nil;
}

///加载信息
- (void)loadInfo
{
    if(!self.httpRequest)
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCustomerServiceOperation returnCustomServiceParam]];
}

///初始化
- (void)infoFromDictionary:(NSDictionary*) dic
{
    
    self.servicePhoneNumber = [dic sea_stringForKey:@"mobile"];
    self.uplinePhoneNumber = [dic sea_stringForKey:@"higher"];
    self.type = [dic sea_stringForKey:@"type"];
    self.intro = [dic sea_stringForKey:@"explain"];
    self.contact = [dic sea_stringForKey:@"val"];
    
}

///清除信息
- (void)clear
{
    self.uplinePhoneNumber = nil;
}

///取消加载
- (void)cancel
{
    [self.httpRequest cancelRequest];
    self.httpRequest = nil;
    self.completion = nil;
}

///加载客服信息
- (void)loadInfoWithCompletion:(void(^)(void)) completion
{
    self.completion = completion;
    if(!self.httpRequest.requesting)
    {
        [self loadInfo];
    }
}

@end
