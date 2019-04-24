//
//  WMCouponsInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**优惠券状态
 */
typedef NS_ENUM(NSInteger, WMCouponsStatus)
{
    ///正常
    WMCouponsStatusNormal = 0,
    
    ///不可使用
    WMCouponsStatusCantUse = 1,
    
    ///过期
    WMCouponsStatusOutTime = 2,
};

/**优惠券领取状态
 */
typedef NS_ENUM(NSInteger,WMActivityStatus)
{
    //未领取
    WMActivityStatusActive = 0,
    
    //已领取
    WMActivityStatusReceived = 1,
    
};

/**优惠券信息
 */
@interface WMCouponsInfo : NSObject

/**优惠券Id
 */
@property(nonatomic,copy) NSString *Id;

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**原名称
 */
@property (copy,nonatomic) NSString *firstTitle;

/**副标题
 */
@property(nonatomic,copy) NSString *subtitle;

/**名称
 */
@property(nonatomic,copy) NSString *name;

/**优惠码 用于使用优惠券
 */
@property(nonatomic,copy) NSString *couponCode;

/**起始时间
 */
@property(nonatomic,copy) NSString *beginTime;

/**结束时间
 */
@property(nonatomic,copy) NSString *endTime;

/**有效期
 */
@property(nonatomic,copy) NSString *validTime;

/**优惠券的数量
 */
@property(nonatomic,assign) int couponCount;

/**优惠券状态 0 正常，1已过期，2已使用
 */
@property(nonatomic,assign) WMCouponsStatus status;

/**状态名称
 */
@property(nonatomic,copy) NSString *statusString;

/**当前优惠券是否正在使用
 */
@property (assign,nonatomic) BOOL isUseing;

/**优惠券的领取状态--领券中心专属字段
 */
@property (assign,nonatomic) WMActivityStatus activityStatus;
/**从字典中生成优惠券信息
 */
+ (id)infoFromDictionary:(NSDictionary *)dict;

/**生成领券中心的数据
 */
+ (NSArray *)returnActivityCouponInfosWithDictsArr:(NSArray *)arr;
/**生成订单使用的优惠券信息
 */
+ (WMCouponsInfo *)returnCouponsInfoWithDict:(NSDictionary *)dict;
/**使用的优惠券的字典信息
 */
+ (id)infoFromUseInfoDict:(NSDictionary *)dict;

- (CGFloat)couponNameHeight;

@end
