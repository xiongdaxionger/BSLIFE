//
//  WMStatisticalOperation.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMHomeStatisticalInfo;

///网络请求标识
#define WMVisitorStatisticalIdentifier @"WMVisitorStatisticalIdentifier" ///访客
#define WMOrderStatisticalIdentifier @"WMOrderStatisticalIdentifier" ///订单
#define WMIncomeStatisticalIdentifier @"WMIncomeStatisticalIdentifier" ///收入
#define WMHomeStatisticalInfoIdentifier @"WMHomeStatisticalInfoIdentifier" ///首页统计信息

/**统计网络操作
 */
@interface WMStatisticalOperation : NSObject

/**获取访客统计数据 参数
 */
+ (NSDictionary*)visitorStatisticalParam;

/**获取访客统计数据 结果
 *@return 数组元素是WMStatisticalInfo
 */
+ (NSArray*)visitorStatisticalResultFromData:(NSData*) data;

/**获取订单统计数据 参数
 */
+ (NSDictionary*)orderStatisticalParam;

/**获取订单统计数据 结果
 *@return  数组元素是WMStatisticalInfo
 */
+ (NSArray*)orderStatisticalResultFromData:(NSData*) data;

/**获取收入统计数据 参数
 */
+ (NSDictionary*)incomeStatisticalParam;

/**获取收入统计数据 结果
 *@return  数组元素是WMStatisticalInfo
 */
+ (NSArray*)incomeStatisticalResultFromData:(NSData*) data;

/**获取首页统计数据 参数
 */
+ (NSDictionary*)homeStatisticalInfoParam;

/**获取首页统计数据 结果
 *@return 首页统计信息
 */
+ (WMHomeStatisticalInfo*)homeStatisticalInfoFromData:(NSData*) data;

@end
