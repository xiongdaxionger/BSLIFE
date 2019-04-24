//
//  WMLogisticsOperation.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMLogisticsOperation.h"
#import "WMLogisticsInfo.h"

@implementation WMLogisticsOperation

/**获取物流信息 参数
 */
+ (NSDictionary*)logisticsInfoParamWithOrderId:(NSString*) orderId isOrder:(BOOL)isOrder
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.order.get_delivery", WMHttpMethod, orderId, isOrder ? @"order_id" : @"delivery_id", nil];
}

/**获取物流信息 结果
 *@return 物流信息
 */
+ (WMLogisticsInfo*)logisticsInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    return [WMLogisticsInfo infoFromDictionary:dic];
}

@end
