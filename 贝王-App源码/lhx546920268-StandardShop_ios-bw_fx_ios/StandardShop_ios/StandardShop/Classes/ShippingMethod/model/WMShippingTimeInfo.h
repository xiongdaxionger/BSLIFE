//
//  WMShippingTimeInfo.h
//  StandardShop
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**配送时间类型
 */
typedef NS_ENUM(NSInteger, ShippingTimeType){
    
    //普通配送
    ShippingTimeTypeNormal = 0,
    
    //指定配送
    ShippingTimeTypeSpecial = 1,
};

/**配送时间模型
 */
@interface WMShippingTimeInfo : NSObject
/**配送时间类型
 */
@property (assign,nonatomic) ShippingTimeType type;
/**配送时间的名称
 */
@property (copy,nonatomic) NSString *shippingTimeName;
/**配送时间的值
 */
@property (copy,nonatomic) NSString *shippingTimeValue;
/**普通配送时间对应的时间区间,元素是NSDictionary,key为name时对应时间区间名称,key为value时对应时间区间值,对任意时间、上午、下午、晚上(晚上时间后台控制开启)
 */
@property (strong,nonatomic) NSArray *shippingTimeZones;
/**指定配送时间对应的时间区间,元素是WMSpecialTimeZoneInfo
 */
@property (strong,nonatomic) NSMutableArray *specialShippingTimeZones;
/**初始化
 */
+ (NSArray *)returnShippingTimeInfosArrWithDict:(NSDictionary *)dict;


@end

/**指定配送时间区间模型
 */
@interface WMSpecialTimeZoneInfo : NSObject
/**指定时间日期,例:2016-7-20
 */
@property (copy,nonatomic) NSString *specialTime;
/**指定时间日期的时间区间,元素是NSString,8:00-12:00,12:00-18:00,18:00-22:00(夜间配送后台开启)
 */
@property (strong,nonatomic) NSMutableArray *specialTimeZones;

+ (WMSpecialTimeZoneInfo *)returnSpecialTimeZoneInfoTime:(NSInteger)newBeginTime;

@end
















