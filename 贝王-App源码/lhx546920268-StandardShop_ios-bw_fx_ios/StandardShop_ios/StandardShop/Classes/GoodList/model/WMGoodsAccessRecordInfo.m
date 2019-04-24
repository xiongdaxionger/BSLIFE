//
//  WMGoodsAccessRecordInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "WMGoodsAccessRecordInfo.h"

@implementation WMGoodsAccessRecordInfo

/**通过字典创建
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMGoodsAccessRecordInfo *info = [[WMGoodsAccessRecordInfo alloc] init];
    
    info.goodId = [dic sea_stringForKey:@"goods_id"];
    info.productId = [dic sea_stringForKey:@"product_id"];
    info.goodName = [dic sea_stringForKey:@"name"];
    info.imageURL = [dic sea_stringForKey:@"goods_img"];
    info.count = [[dic numberForKey:@"nums"] intValue];
    info.time = [NSDate formatTimeInterval:[dic sea_stringForKey:@"create_time"] format:DateFormatYMdHm];
    info.store = [dic sea_stringForKey:@"local_name"];
    
    return info;
}

@end
