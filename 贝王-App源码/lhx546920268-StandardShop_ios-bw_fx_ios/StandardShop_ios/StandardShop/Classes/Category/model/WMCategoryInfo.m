//
//  WMCategoryInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCategoryInfo.h"

@implementation WMCategoryInfo

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMCategoryInfo *info = [[WMCategoryInfo alloc] init];
    info.categoryId = [[dic numberForKey:@"cat_id"] longLongValue];
    info.categoryName = [dic sea_stringForKey:@"cat_name"];
    info.imageURL = [dic sea_stringForKey:@"image_default_id"];

    ///虚拟分类
    if(info.categoryId == 0)
    {
        info.categoryId = [[dic numberForKey:@"virtual_cat_id"] longLongValue];
        info.categoryName = [dic sea_stringForKey:@"virtual_cat_name"];
        info.isVirtualCategory = YES;
    }

    return info;
}

@end
