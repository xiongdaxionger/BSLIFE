//
//  WMShippingTimeInfo.m
//  StandardShop
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippingTimeInfo.h"

#import "NSDate+Utilities.h"
/**配送时间模型
 */
@implementation WMShippingTimeInfo
/**初始化
 */
+ (NSArray *)returnShippingTimeInfosArrWithDict:(NSDictionary *)dict{
    
    NSArray *timesArr = [dict arrayForKey:@"days_options"];
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    NSArray *normalInfoTimeZones = [dict arrayForKey:@"times_options"];
    
    for (NSDictionary *timeDict in timesArr) {
        
        NSString *value = [timeDict sea_stringForKey:@"value"];
        
        WMShippingTimeInfo *timeInfo = [WMShippingTimeInfo new];
        
        timeInfo.shippingTimeName = [timeDict sea_stringForKey:@"name"];
        
        timeInfo.shippingTimeValue = value;
        
        if (![value isEqualToString:@"special"]) {
            
            timeInfo.type = ShippingTimeTypeNormal;
            
            timeInfo.shippingTimeZones = normalInfoTimeZones;
        }
        else{
            
            timeInfo.type = ShippingTimeTypeSpecial;
            
            timeInfo.specialShippingTimeZones = [NSMutableArray new];
            
            NSString *endTime = [dict sea_stringForKey:@"end_time"];
            
            NSString *beginDay = [dict sea_stringForKey:@"begin_day"];
            
            NSString *beginDayDate = [NSDate formatTimeInterval:beginDay format:DateFormatYMdHm];
            
            NSString *hourTime = [beginDayDate substringWithRange:NSMakeRange(11, 2)];
                
            if (hourTime.integerValue > 0 && hourTime.integerValue < 8) {
                
                //从当天开始
                NSInteger newBeginTime = beginDay.integerValue;
                
                for (NSInteger i = 0; i < 7; i++) {
                    
                    WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo returnSpecialTimeZoneInfoTime:newBeginTime];
                    
                    specialTimeZoneInfo.specialTimeZones = [NSMutableArray arrayWithObjects:@"上午",@"下午",nil];
                    
                    //是否开启夜间配送
                    if (endTime.integerValue > 18) {
                        
                        [specialTimeZoneInfo.specialTimeZones addObject:@"晚上"];
                    }
                    
                    [timeInfo.specialShippingTimeZones addObject:specialTimeZoneInfo];
                    
                    newBeginTime += 24 * 60 * 60;
                }
            }
            else if (hourTime.integerValue >= 8 && hourTime.integerValue < 12) {
                
                //从当天开始
                NSInteger newBeginTime = beginDay.integerValue;
                
                for (NSInteger i = 0; i < 7; i++) {
                    
                    WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo returnSpecialTimeZoneInfoTime:newBeginTime];
                    
                    specialTimeZoneInfo.specialTimeZones = i == 0 ? [NSMutableArray arrayWithObjects:@"下午",nil] : [NSMutableArray arrayWithObjects:@"上午",@"下午",nil];
                    
                    //是否开启夜间配送
                    if (endTime.integerValue > 18) {
                        
                        [specialTimeZoneInfo.specialTimeZones addObject:@"晚上"];
                    }
                    
                    [timeInfo.specialShippingTimeZones addObject:specialTimeZoneInfo];

                    newBeginTime += 24 * 60 * 60;
                }
            }
            else if (hourTime.integerValue >= 12 && hourTime.integerValue < 18){
                
                if (endTime.integerValue > 18) {
                    
                    //从当天开始
                    NSInteger newBeginTime = beginDay.integerValue;
                    
                    for (NSInteger i = 0; i < 7; i++) {
                        
                        WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo returnSpecialTimeZoneInfoTime:newBeginTime];
                        
                        specialTimeZoneInfo.specialTimeZones = i == 0 ? [NSMutableArray arrayWithObjects:@"晚上",nil] : [NSMutableArray arrayWithObjects:@"上午",@"下午",nil];
                        
                        //是否开启夜间配送
                        if (i > 0) {
                            
                            [specialTimeZoneInfo.specialTimeZones addObject:@"晚上"];
                        }
                        
                        [timeInfo.specialShippingTimeZones addObject:specialTimeZoneInfo];

                        newBeginTime += 24 * 60 * 60;
                    }
                }
                else{
                    
                    //从新一天开始
                    NSInteger newBeginTime = beginDay.integerValue + 24 * 60 * 60;
                    
                    for (NSInteger i = 0; i < 6; i++) {
                        
                        WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo returnSpecialTimeZoneInfoTime:newBeginTime];
                        
                        specialTimeZoneInfo.specialTimeZones = [NSMutableArray arrayWithObjects:@"上午",@"下午",nil];
                        
                        [timeInfo.specialShippingTimeZones addObject:specialTimeZoneInfo];

                        newBeginTime += 24 * 60 * 60;
                    }
                }
            }
            else if (hourTime.integerValue >= 18 && hourTime.integerValue < 24){
                
                //从新一天开始
                NSInteger newBeginTime = beginDay.integerValue + 24 * 60 * 60;
                
                for (NSInteger i = 0; i < 6; i++) {
                    
                    WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo returnSpecialTimeZoneInfoTime:newBeginTime];
                    
                    specialTimeZoneInfo.specialTimeZones = [NSMutableArray arrayWithObjects:@"上午",@"下午",nil];
                    
                    //是否开启夜间配送
                    if (endTime.integerValue > 18) {
                        
                        [specialTimeZoneInfo.specialTimeZones addObject:@"晚上"];
                    }
                    
                    [timeInfo.specialShippingTimeZones addObject:specialTimeZoneInfo];
                    
                    newBeginTime += 24 * 60 * 60;
                }
            }
            
        }
        
        [infosArr addObject:timeInfo];
    }
    
    return infosArr;
}

+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:BeiJingTimeZone];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


@end


/**指定配送时间区间模型
 */
@implementation WMSpecialTimeZoneInfo

+ (WMSpecialTimeZoneInfo *)returnSpecialTimeZoneInfoTime:(NSInteger)newBeginTime{
    
    NSString *timeFormat = [NSDate formatTimeInterval:[NSString stringWithFormat:@"%ld",(long)newBeginTime] format:DateFormatYMdHm];
    
    WMSpecialTimeZoneInfo *specialTimeZoneInfo = [WMSpecialTimeZoneInfo new];
    
    NSDate *timeDate = [NSDate dateFromString:timeFormat format:DateFormatYMdHm];

    NSString *week = [WMShippingTimeInfo weekdayStringFromDate:timeDate];
    
    specialTimeZoneInfo.specialTime = [NSString stringWithFormat:@"%@(%@)",[NSDate formatTimeInterval:[NSString stringWithFormat:@"%ld",(long)newBeginTime] format:DateFromatYMd],week];
    
    return specialTimeZoneInfo;
}







@end


