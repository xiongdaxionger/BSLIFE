//
//  WMShakeResultInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCouponsInfo.h"

///摇一摇结果类型
typedef NS_ENUM(NSInteger, WMShakeResult)
{
    ///人品+1
    WMShakeResultCharacterAdd = 0,
    
    ///摇到优惠券
    WMShakeResultCoupons = 1,
    
    ///今日已摇完
    WMShakeResultShakeEnd = 2,
    
    ///其他
    WMShakeResultOther = 3,
};

///摇一摇结果
@interface WMShakeResultInfo : NSObject

///结果类型
@property(nonatomic,assign) WMShakeResult result;

///提示信息
@property(nonatomic,copy) NSString *message;

///优惠券
@property(nonatomic,strong) WMCouponsInfo *couponsInfo;

///优惠券领用人
@property(nonatomic,copy) NSString *couponsHolder;

///今日可摇次数
@property(nonatomic,assign) int timesToShake;

///是否是无限次
@property(nonatomic,assign) BOOL isInfinite;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
