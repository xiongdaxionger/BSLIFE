//
//  WMAccountSecurityInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAccountSecurityInfo.h"

@implementation WMAccountSecurityInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMAccountSecurityInfo *info = [[WMAccountSecurityInfo alloc] init];
    info.phoneNumber = [[dic dictionaryForKey:WMHttpData] sea_stringForKey:@"mobile"];
    
    return info;
}

@end
