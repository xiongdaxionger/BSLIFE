//
//  WMGoodDetailSellLogInfo.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailSellLogInfo.h"

@implementation WMGoodDetailSellLogInfo
/**批量初始化
 */
+ (NSArray *)returnSellLogInfosArrWithDictsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMGoodDetailSellLogInfo returnSellLogInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnSellLogInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailSellLogInfo *info = [WMGoodDetailSellLogInfo new];
    
    info.sellLogID = [dict sea_stringForKey:@"log_id"];
    
    info.memberID = [dict sea_stringForKey:WMUserInfoId];
    
    info.orderID = [dict sea_stringForKey:@"order_id"];
    
    info.memberName = [dict sea_stringForKey:@"name"];
    
    info.sellLogPrice = [dict sea_stringForKey:@"price"];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.goodName = [dict sea_stringForKey:@"product_name"];
    
    info.goodSpecInfo = [dict sea_stringForKey:@"spec_info"];
    
    info.buyCount = [dict sea_stringForKey:@"number"];
    
    info.buyTime = [NSDate formatTimeInterval:[dict sea_stringForKey:@"createtime"] format:DateFromatYMd];
    
    return info;
}
@end
