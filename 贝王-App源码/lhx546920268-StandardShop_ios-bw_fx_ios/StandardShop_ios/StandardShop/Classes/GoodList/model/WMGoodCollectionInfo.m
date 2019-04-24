//
//  WMGoodCollectionInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodCollectionInfo.h"

@implementation WMGoodCollectionInfo

/**从字典中创建
 *@param dic 包含收藏信息的字典
 *@return 一个实例
 */
+ (id)infoFromDictionary:(NSDictionary*) dic
{
    WMGoodCollectionInfo *info = [[WMGoodCollectionInfo alloc] init];
    info.goodInfo = [[WMGoodInfo alloc] init];
    NSString *time = [dic sea_stringForKey:@"fav_add_time"];
    info.time = [NSDate formatTimeInterval:time format:DateFromatYMd];
    
    info.goodInfo.goodId = [dic sea_stringForKey:@"goods_id"];
    info.goodInfo.productId = [dic sea_stringForKey:@"product_id"];
    info.goodInfo.imageURL = [dic sea_stringForKey:@"image_default_id"];
    info.goodInfo.goodName = [dic sea_stringForKey:@"name"];
    info.goodInfo.price = [dic sea_stringForKey:@"price"];
    info.goodInfo.isMarket = [[dic sea_stringForKey:@"marketable"] isEqualToString:@"true"];
    info.goodInfo.inventory = [[dic numberForKey:@"store"] longLongValue];
    
    return info;
}

@end
