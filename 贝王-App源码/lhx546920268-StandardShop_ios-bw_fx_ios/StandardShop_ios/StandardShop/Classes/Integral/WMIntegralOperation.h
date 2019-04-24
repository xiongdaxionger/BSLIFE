//
//  WMIntegralOperation.h
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络请求标识
#define WMIntegralUseHistoryIdentifier @"WMIntegralUseHistoryIdentifier" ///积分使用记录
#define WMIntegralRuleIdentifier @"WMIntegralRuleIdentifier" ///积分规则
#define WMIntegralSignInIdentifier @"WMIntegralSignInIdentifier" ///积分签到
#define WMIntegralGoodListIdentifier @"WMIntegralGoodListIdentifier" ///积分商品

@class WMIntegralSignInInfo, WMIntegralInfo;

///积分网络操作
@interface WMIntegralOperation : NSObject

/**获取积分使用记录 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)integralUseHistoryParamWithPageIndex:(int) pageIndex;

/**获取积分使用记录 结果
 *@param integralInfo 积分信息
 *@param totalSize 积分历史记录总数
 *@return 数组元素是 WMIntegralHistoryInfo
 */
+ (NSArray*)integralUseHistoryFromData:(NSData*) data integralInfo:(WMIntegralInfo**) integralInfo totalSize:(long long*) totalSize;

/**获取积分规则 参数
 */
+ (NSDictionary*)integralRuleParam;

/**获取积分规则，结果
 *@return html 字符串
 */
+ (NSString*)integralRuleResultFromData:(NSData*) data;

/**积分签到 参数
 */
+ (NSDictionary*)integralSignInParams;

/**积分签到 结果
 */
+ (WMIntegralSignInInfo*)integralSignInResultFromData:(NSData*) data;

/**积分商品列表 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)integralGoodListParamWithPageIndex:(int) pageIndex;

/**积分商品列表 结果
 *@param totalSize 总数
 *@return 数组元素是 WMInegralGoodInfo
 */
+ (NSArray*)integralGoodListFromData:(NSData*) data totalSize:(long long*) totalSize;

@end
