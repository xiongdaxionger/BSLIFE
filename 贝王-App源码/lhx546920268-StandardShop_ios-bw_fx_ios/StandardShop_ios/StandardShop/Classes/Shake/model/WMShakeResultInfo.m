//
//  WMShakeResultInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeResultInfo.h"

@implementation WMShakeResultInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMShakeResultInfo *info = [[WMShakeResultInfo alloc] init];
    info.timesToShake = [[dic numberForKey:@"limit_count"] intValue];
    info.isInfinite = [[dic numberForKey:@"limit"] longLongValue] == 0;
    info.message = [dic sea_stringForKey:@"msg"];
    
    int code = [[dic numberForKey:@"status"] intValue];
    
    switch (code)
    {
        case 0 :
        {
            ///要到优惠券
            info.result = WMShakeResultCoupons;
            
            NSDictionary *coupon = [dic dictionaryForKey:@"coupon"];
            WMCouponsInfo *couponsInfo = [[WMCouponsInfo alloc] init];
            couponsInfo.name = [coupon sea_stringForKey:@"cpns_name"];
            info.couponsHolder = [coupon sea_stringForKey:@"username"];
            
            NSDictionary *ruleDic = [coupon dictionaryForKey:@"rule"];
            
            couponsInfo.beginTime = [NSDate formatTimeInterval:[ruleDic sea_stringForKey:@"from_time"] format:@"yyyy.MM.dd"];
            couponsInfo.endTime = [NSDate formatTimeInterval:[ruleDic sea_stringForKey:@"to_time"] format:@"yyyy.MM.dd"];
            
            info.couponsInfo = couponsInfo;
        }
            break;
        case 5 :
        {
            info.result = WMShakeResultShakeEnd;
        }
            break;
        case 8 :
        {
            info.result = WMShakeResultCharacterAdd;
        }
            break;
        case 9 :
        {
            info.result = WMShakeResultOther;
            if([NSString isEmpty:info.message])
            {
                info.message = @"客官，别太累了，休息下再摇吧！";
            }
        }
            break;
        default:
        {
            info.result = WMShakeResultOther;
        }
            break;
    }

    
    return info;
}

@end
