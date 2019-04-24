//
//  WMActivityInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMActivityInfo.h"

@implementation WMActivityInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMActivityInfo *info = [[WMActivityInfo alloc] init];
    info.name = [dic sea_stringForKey:@"name"];
    info.imageURL = [dic sea_stringForKey:@"img"];
    info.type = [WMActivityInfo typeFromString:[dic sea_stringForKey:@"type"]];
    
    return info;
}

///获取类型
+ (WMActivityType)typeFromString:(NSString*) string
{
    WMActivityType type = WMActivityTypeUnknow;
    
    if([string isEqualToString:@"yiy"])
    {
        type = WMActivityTypeShake;
    }
    else if([string isEqualToString:@"recharge"])
    {
        type = WMActivityTypeTopup;
    }
    else if([string isEqualToString:@"sign"])
    {
        type = WMActivityTypeSignup;
    }
    else if([string isEqualToString:@"coupons"])
    {
        type = WMActivityTypeDrawCoupons;
    }
    else if([string isEqualToString:@"register"])
    {
        type = WMActivityTypeInviteRegister;
    }
    
    return type;
}

@end
