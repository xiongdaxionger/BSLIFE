//
//  WMTopupActivityInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupActivityInfo.h"

@implementation WMTopupActivityInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMTopupActivityInfo *info = [[WMTopupActivityInfo alloc] init];
    info.desc = [dic sea_stringForKey:@"brief"];
    info.amount = [dic sea_stringForKey:@"price_min"];
    info.giving = [dic sea_stringForKey:@"song"];
    
    return info;
}

@end
