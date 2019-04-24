//
//  WMLogisticsOperation.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求标识

#define WMLogisticsInfoIdentifier @"WMLogisticsInfoIdentifier" ///物流信息

@class WMLogisticsInfo;

///物流网络操作
@interface WMLogisticsOperation : NSObject

/**获取物流信息 参数
 */
+ (NSDictionary*)logisticsInfoParamWithOrderId:(NSString*) orderId isOrder:(BOOL)isOrder;

/**获取物流信息 结果
 *@return 物流信息
 */
+ (WMLogisticsInfo*)logisticsInfoFromData:(NSData*) data;

@end
