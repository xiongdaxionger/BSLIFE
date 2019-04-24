//
//  WMSecondKillInfo.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///秒杀状态
typedef NS_ENUM(NSInteger, WMSecondKillStatus)
{
    ///已结束
    WMSecondKillStatusEnd,
    
    ///是否可订阅
    WMSecondKillStatusEnableSubscrible,
    
    ///未开始
    WMSecondKillStatusNotBegan,
    
    ///抢购中
    WMSecondKillStatusBuying,
};

///秒杀模块信息
@interface WMSecondKillInfo : NSObject

/**秒杀场次id
 */
@property(nonatomic,copy) NSString *Id;

/**秒杀名称
 */
@property(nonatomic,copy) NSString *name;

/**开始时间
 */
@property(nonatomic,assign) NSTimeInterval beginTime;

/**结束时间
 */
@property(nonatomic,assign) NSTimeInterval endTime;

/**订阅提醒时间
 */
@property(nonatomic,assign) NSTimeInterval remindTime;

/**提醒信息
 */
@property(nonatomic,readonly) NSString *remindmMsg;

/**秒杀是否已经开始
 */
@property(nonatomic,readonly) BOOL isSecondKillBegan;

/**秒杀是否已结束
 */
@property(nonatomic,readonly) BOOL isSecondKillEnded;

/**秒杀是否可以订阅
 */
@property(nonatomic,readonly) BOOL enableSunscrible;

///时间
@property(nonatomic,copy) NSString *time;

///日期
@property(nonatomic,copy) NSString *date;

///状态字符串
@property(nonatomic,readonly) NSString *statusString;

///状态
@property(nonatomic,readonly) WMSecondKillStatus status;

///是否选中
@property(nonatomic,assign) BOOL selected;

///秒杀商品信息 数组元素是 WMGoodInfo
@property(nonatomic,strong) NSMutableArray *goodInfos;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
