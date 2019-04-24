//
//  WMCouponsOperation.h
//  WuMei
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取优惠券列表请求标识
#define WMCouponsListIdentifier @"WMCouponsListIdentifier"
//通过优惠券码创建优惠券
#define WMCouponsCreateIdentifier @"WMCouponsCreateIdentifier"
//领券中心
#define WMActivityCouponIdentifier @"WMActivityCouponIdentifier"
//使用优惠券
#define WMUseCouponIdentifier @"WMUseCouponIdentifier"
//取消使用优惠券
#define WMCancelUseCouponIdentifier @"WMCancelUseCouponIdentifier"
@class WMCouponsInfo;

/**优惠券网络操作
 */
@interface WMCouponsOperation : NSObject

/**获取我的优惠券 参数
 *@param status use 有效的，unuse已过期或已使用的
 *@param filter 筛选 0 不筛选，1 筛选，下单时需要传
 *@param page_no 分页
 *@param isFastBuy 是否快速购买
 */
+ (NSDictionary*)couponsListParamWithType:(NSInteger) type filterType:(NSInteger)filterType pageNumber:(NSInteger)pageNo isFastBuy:(NSString *)isFastBuy;

/**从返回的数据获取我的优惠券
 *@param totalSize 优惠券总数
 *@return NSArray 数组元素是 WMCouponsInfo
 */
+ (NSArray*)couponsListFromData:(NSData*) data totalSize:(long long*) totalSize;

/**生成优惠券 参数
 *@param code 优惠券编码
 */
+ (NSDictionary*)couponsCreateWithCode:(NSString*)code;

/*生成优惠券 结果
 *@return BOOL
 */
+ (BOOL)couponsCreateInfoFromData:(NSData*)data;

/**返回使用优惠券 参数
 *@param 优惠券码 couponCode
 *@param 操作类型 objType
 *@param 是否快速购买
 */
+ (NSDictionary *)returnUseCouponWithCouponCode:(NSString *)couponCode isFastBuy:(NSString *)isFastBuy objType:(NSString *)objType;

/**返回使用优惠券 结果
 */
+ (NSDictionary *)returnCouponUseResultWithData:(NSData *)data;

/**获取优惠券使用说明 参数
 */
+ (NSDictionary*)couponsUseIntroParams;

/**获取优惠券使用说明 结果
 *@return 说明html
 */
+ (NSString*)couponsUseIntroFromData:(NSData*) data;

/**取消使用优惠券 参数
 *@param 优惠券码 couponCode
 *@param 是否立即构面 isFastBuy
 */
+ (NSDictionary *)returnCancelUseCouponParamWithCouponCode:(NSString *)couponCode isFastBuy:(NSString *)isFastBuy;
/**取消使用优惠券 结果
 */
+ (NSDictionary *)returnCancelUseCouponResultWithData:(NSData *)data;

/**领券中心 参数
 */
+ (NSDictionary *)returnActivityCouponParam;
/**领券中心 结果
 *@return 数组 元素是WMCouponsInfo
 */
+ (NSArray *)returnActivityCouponInfosWithData:(NSData *)data;
@end
