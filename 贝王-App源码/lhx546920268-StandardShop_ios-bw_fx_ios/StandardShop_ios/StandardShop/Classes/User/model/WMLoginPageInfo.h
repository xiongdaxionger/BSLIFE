//
//  WMLoginPageInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/11/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSocialLoginOperation.h"

@class WMSocialLoginTypeInfo;

///登录页面信息
@interface WMLoginPageInfo : NSObject

///图形验证码链接
@property(nonatomic,copy) NSString *imageCodeURL;

///第三方登录 
@property(nonatomic,copy) NSArray<WMSocialLoginTypeInfo*> *socialLogins;

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

///登录类型 信息
@interface WMSocialLoginTypeInfo : NSObject

///类型
@property(nonatomic,assign) WMPlatformType type;

///图标
@property(nonatomic,strong) UIImage *image;

///标题
@property(nonatomic,copy) NSString *title;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
