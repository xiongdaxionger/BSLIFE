//
//  WMBrandInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMBrandInfo.h"


@implementation WMBrandInfo

- (instancetype)copyWithZone:(NSZone *)zone
{
    WMBrandInfo *info = [[WMBrandInfo allocWithZone:zone] init];
    info.Id = self.Id;
    info.name = self.name;
    info.imageURL = self.imageURL;
    
    return info;
}

///通过字典创建
+ (WMBrandInfo*)infoFromDictionary:(NSDictionary*) dic
{
    WMBrandInfo *info = [[[self class] alloc] init];
    
    info.Id = [dic sea_stringForKey:@"brand_id"];
    info.name = [dic sea_stringForKey:@"brand_name"];
    info.imageURL = [dic sea_stringForKey:@"brand_logo"];
    
    return info;
}

@end
