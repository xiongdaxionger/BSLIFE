//
//  Mysoure.m
//  WuMei
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMIntegralInfo.h"

@implementation WMIntegralInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMIntegralInfo *info = [[WMIntegralInfo alloc] init];
    info.useTitle = [dic sea_stringForKey:@"exchange_gift_link"];

    NSDictionary *dict = [dic dictionaryForKey:@"extend_point_html"];
    NSDictionary *consumptionDic = [dict dictionaryForKey:@"expense_point"];

    info.consumptionFreezeName = [consumptionDic sea_stringForKey:@"name"];
    info.consumptionFreezeIntegral = [consumptionDic sea_stringForKey:@"value"];

    NSDictionary *obtainDic = [dict dictionaryForKey:@"obtained_point"];

    info.obtainFreezeName = [obtainDic sea_stringForKey:@"name"];
    info.obtainFreezeIntegral = [obtainDic sea_stringForKey:@"value"];

    long long total = [[dic numberForKey:@"total"] longLongValue];
    info.availableIntegral = [NSString stringWithFormat:@"%lld", total - [info.consumptionFreezeIntegral longLongValue]];

    return info;
}

@end

@implementation WMIntegralHistoryInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMIntegralHistoryInfo *info = [[WMIntegralHistoryInfo alloc] init];
    info.integral = [dic sea_stringForKey:@"change_point"];
    info.reason = [dic sea_stringForKey:@"reason"];
    NSString *time = [dic sea_stringForKey:@"addtime"];
    info.time = [NSDate formatTimeInterval:time format:DateFromatYMd];

    return info;
}

@end
