//
//  WMCouponsInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCouponsInfo.h"

@implementation WMCouponsInfo

/**从字典中生成优惠券信息
 */
+ (id)infoFromDictionary:(NSDictionary*)dict
{
    WMCouponsInfo *info = [[WMCouponsInfo alloc] init];
    
    info.Id = [dict sea_stringForKey:@"cpns_id"];
    info.couponCode = [dict sea_stringForKey:@"memc_code"];
    
    info.isUseing = [[dict numberForKey:@"useing"] boolValue];
    
    info.firstTitle = [dict sea_stringForKey:@"cpns_name"];
    
    if ([dict sea_stringForKey:@"count"]) {
        
        info.couponCount = [[dict numberForKey:@"count"] intValue];
    }
    else{
        
        info.couponCount = 1;
    }
    
    if (info.isUseing) {
        
        info.couponCount -= 1;
        
        if (info.couponCount == 0) {
            
            info.title = info.firstTitle;
        }
        else{
            
            info.title = [NSString stringWithFormat:@"%@(x%d)",info.firstTitle,info.couponCount];
        }
    }
    else{
        
        info.title = [NSString stringWithFormat:@"%@(x%d)",info.firstTitle,info.couponCount];
    }
    
    info.subtitle = [NSString stringWithFormat:@"%@专享优惠券", appName()];
    
    NSString *toTime = [dict sea_stringForKey:@"to_time"];
    NSString *fromTime = [dict sea_stringForKey:@"from_time"];
    info.name = [dict sea_stringForKey:@"description"];
    
    info.beginTime = fromTime;
    info.endTime = toTime;
    
    
    info.validTime = [NSString stringWithFormat:@"有效期：%@ 至 %@", [NSDate formatTimeInterval:fromTime format:DateFromatYMd], [NSDate formatTimeInterval:toTime format:DateFromatYMd]];
    
    if ([dict sea_stringForKey:@"memc_code"]) {
        
        NSString *due = [dict sea_stringForKey:@"due"];
        
        if (due) {
            
            info.status = WMCouponsStatusCantUse;
            
            info.statusString = [dict sea_stringForKey:@"memc_status"];
        }
        else{
            
            info.status = WMCouponsStatusNormal;
            
            info.statusString = @"可使用";
        }
    }
    else{
        
        info.status = WMCouponsStatusOutTime;
        
        info.statusString = [dict sea_stringForKey:@"memc_status"];
        
    }
    
    return info;
}

/**生成领券中心的数据
 */
+ (NSArray *)returnActivityCouponInfosWithDictsArr:(NSArray *)arr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in arr) {
        
        WMCouponsInfo *info = [WMCouponsInfo new];
        
        info.couponCode = [dict sea_stringForKey:@"cpns_prefix"];
        
        info.Id = [dict sea_stringForKey:@"cpns_id"];
        
        info.title = [dict sea_stringForKey:@"cpns_name"];
        
        info.subtitle = [NSString stringWithFormat:@"%@专享优惠券", appName()];
        
        NSString *toTime = [dict sea_stringForKey:@"to_time"];
        
        NSString *fromTime = [dict sea_stringForKey:@"from_time"];

        info.validTime = [NSString stringWithFormat:@"有效期：%@ 至 %@", fromTime, toTime];

        info.statusString = [dict sea_stringForKey:@"receiveStatusName"];
        
        info.name = [dict sea_stringForKey:@"description"];

        if([[dict sea_stringForKey:@"receiveStatus"] isEqualToString:@"1"]){
            
            info.activityStatus = WMActivityStatusActive;
        }
        else{
            
            info.activityStatus = WMActivityStatusReceived;
        }
        
        [infosArr addObject:info];
    }
    
    return infosArr;
}

/**生成订单使用的优惠券信息
 */
+ (WMCouponsInfo *)returnCouponsInfoWithDict:(NSDictionary *)dict{
    
    WMCouponsInfo *info = [WMCouponsInfo new];
    
    info.couponCode = [dict sea_stringForKey:@"coupon"];
    
    info.couponCount = [[dict sea_stringForKey:@"quantity"] integerValue];
    
    info.isUseing = YES;
    
    info.name = [dict sea_stringForKey:@"name"];
        
    return info;
}


/**使用的优惠券的字典信息
 */
+ (id)infoFromUseInfoDict:(NSDictionary *)dict{
    
    WMCouponsInfo *couponInfo = [WMCouponsInfo new];
    
    couponInfo.couponCode = [dict sea_stringForKey:@"coupon"];
    
    couponInfo.Id = [dict sea_stringForKey:@"cpns_id"];
    
    couponInfo.name = [dict sea_stringForKey:@"name"];
    
    return couponInfo;
}

- (CGFloat)couponNameHeight{
    
    CGFloat nameHeight = MAX(18, [self.name stringSizeWithFont:[UIFont fontWithName:MainFontName size:12.0] contraintWith:_width_ - 40].height);
    
    return nameHeight + 110.0 - 10.0;
}

@end
