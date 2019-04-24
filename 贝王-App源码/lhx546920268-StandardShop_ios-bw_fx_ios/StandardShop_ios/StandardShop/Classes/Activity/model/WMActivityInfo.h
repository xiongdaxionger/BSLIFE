//
//  WMActivityInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///活动类型
typedef NS_ENUM(NSInteger,WMActivityType)
{
    ///无法识别的类型
    WMActivityTypeUnknow,
    
    ///摇一摇
    WMActivityTypeShake,

    ///充值有礼
    WMActivityTypeTopup,

    ///签到
    WMActivityTypeSignup,

    ///领券中心
    WMActivityTypeDrawCoupons,
    
    ///邀请注册
    WMActivityTypeInviteRegister,
};

///活动信息
@interface WMActivityInfo : NSObject

///活动名称
@property(nonatomic,copy) NSString *name;

///类型
@property(nonatomic,assign) WMActivityType type;

///图标
@property(nonatomic,copy) NSString *imageURL;

///通过字典创建，如果活动无法识别，则返回nil
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
