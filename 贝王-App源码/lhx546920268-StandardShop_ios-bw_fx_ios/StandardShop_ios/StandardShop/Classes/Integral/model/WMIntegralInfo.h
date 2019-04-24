//
//  Mysoure.h
//  WuMei
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

///积分信息
@interface WMIntegralInfo : NSObject

/**消费冻结名称
 */
@property(nonatomic,copy) NSString *consumptionFreezeName;

/**消费冻结积分
 */
@property(nonatomic,copy) NSString *consumptionFreezeIntegral;

/**可用积分
 */
@property(nonatomic,copy) NSString *availableIntegral;

/**获取冻结名称
 */
@property(nonatomic,copy) NSString *obtainFreezeName;

/**获取冻结积分
 */
@property(nonatomic,copy) NSString *obtainFreezeIntegral;

/**积分使用按钮标题
 */
@property(nonatomic,copy) NSString *useTitle;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

///积分历史记录
@interface WMIntegralHistoryInfo : NSObject

/**积分
 */
@property(nonatomic,strong) NSString *integral;

/**积分宽度
 */
@property(nonatomic,assign) CGFloat integralWidth;

/**使用原因
 */
@property(nonatomic,strong) NSString *reason;

/**使用时间
 */
@property(nonatomic,strong) NSString *time;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
