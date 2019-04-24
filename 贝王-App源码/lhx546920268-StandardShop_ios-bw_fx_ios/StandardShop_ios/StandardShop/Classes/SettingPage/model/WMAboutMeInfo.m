//
//  WMAboutMeInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/28.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMAboutMeInfo.h"

@implementation WMAboutMeInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMAboutMeInfo *info = [[WMAboutMeInfo alloc] init];

    info.html = [dic sea_stringForKey:@"explain"];
    
    return info;
}

@end
