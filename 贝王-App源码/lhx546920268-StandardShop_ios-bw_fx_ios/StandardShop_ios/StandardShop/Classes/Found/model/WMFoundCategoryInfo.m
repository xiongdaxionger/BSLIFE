//
//  WMFoundCategoryInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCategoryInfo.h"

@implementation WMFoundCategoryInfo

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMFoundCategoryInfo *info = [[WMFoundCategoryInfo alloc] init];
    
    info.Id = [dic sea_stringForKey:@"node_id"];
    info.name = [dic sea_stringForKey:@"node_name"];
    info.imageURL = [dic sea_stringForKey:@"image"];
    info.intro = [dic sea_stringForKey:@"node_desc"];
    
    return info;
}

@end
