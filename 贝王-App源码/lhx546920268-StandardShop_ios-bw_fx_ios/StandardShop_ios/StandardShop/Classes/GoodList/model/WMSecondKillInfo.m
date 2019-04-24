//
//  WMSecondKillInfo.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSecondKillInfo.h"
#import "WMGoodInfo.h"
#import "WMServerTimeOperation.h"

@implementation WMSecondKillInfo

/**特卖是否已经开始
 */
- (BOOL)isSecondKillBegan
{
    return self.beginTime <= [WMServerTimeOperation sharedInstance].time;
}

/**特卖是否已结束
 */
- (BOOL)isSecondKillEnded
{
    return self.endTime <= [WMServerTimeOperation sharedInstance].time;
}

/**秒杀是否可以订阅
 */
- (BOOL)enableSunscrible
{
    return self.remindTime > [WMServerTimeOperation sharedInstance].time;
}

- (NSString*)remindmMsg
{
    long long interval = (self.beginTime - self.remindTime) / 60;
    if(interval >= 60)
    {
        int hour = interval / 60;
        if(interval % 60 == 0)
        {
            return [NSString stringWithFormat:@"设置成功\n开卖前%d小时提醒您", hour];
        }
        else
        {
            return [NSString stringWithFormat:@"设置成功\n开卖前%d小时%lld分钟提醒您", hour, interval % 60];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"设置成功\n开卖前%lld分钟提醒您", interval];
    }
}

- (NSString*)statusString
{
    WMSecondKillStatus status = self.status;
    
    switch (status)
    {
        case WMSecondKillStatusEnd :
        {
            return @"已结束";
        }
            break;
        case WMSecondKillStatusBuying :
        {
            return @"抢购中";
        }
            break;
        case WMSecondKillStatusNotBegan :
        case WMSecondKillStatusEnableSubscrible :
        {
            return @"即将开始";
        }
            break;
        default:
            break;
    }
}

- (WMSecondKillStatus)status
{
    if(self.isSecondKillEnded)
    {
        return WMSecondKillStatusEnd;
    }
    else if (self.isSecondKillBegan)
    {
        return WMSecondKillStatusBuying;
    }
    else if (self.enableSunscrible)
    {
        return WMSecondKillStatusEnableSubscrible;
    }
    else
    {
        return WMSecondKillStatusNotBegan;
    }
}

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMSecondKillInfo *info = [[WMSecondKillInfo alloc] init];
    NSDictionary *infoDic = [dic dictionaryForKey:@"info"];
    
    info.Id = [infoDic sea_stringForKey:@"special_id"];
    info.name = [infoDic sea_stringForKey:@"name"];
    info.remindTime = [[infoDic numberForKey:@"remind_time"] doubleValue];
    NSString *time = [infoDic sea_stringForKey:@"begin_time"];
    info.beginTime = [time doubleValue];
    info.endTime = [[infoDic numberForKey:@"end_time"] doubleValue];
    
    time = [NSDate formatTimeInterval:time format:@"M月d日 HH:mm"];
    NSArray *times = [time componentsSeparatedByString:@" "];
    info.time = [times lastObject];
    info.date = [times firstObject];
    
    NSArray *goods = [dic arrayForKey:@"goods"];
    info.goodInfos = [NSMutableArray arrayWithCapacity:goods.count];
    
    for(NSDictionary *dict in goods)
    {
        WMGoodInfo *goodInfo = [[WMGoodInfo alloc] init];
        goodInfo.goodId = [dict sea_stringForKey:@"goods_id"];
        goodInfo.productId = [dict sea_stringForKey:@"product_id"];
        goodInfo.goodName = [dict sea_stringForKey:@"product_name"];
        goodInfo.imageURL = [dict sea_stringForKey:@"image_default_id"];
        goodInfo.price = [dict sea_stringForKey:@"promotion_price"];
        goodInfo.marketPrice = [dict sea_stringForKey:@"price"];
        goodInfo.actorCount = [[dict numberForKey:@"initial_num"] longLongValue];
        goodInfo.secondKillIsSoldout = ![[dict sea_stringForKey:@"status"] boolValue];
        goodInfo.isSubscribed = [[dict sea_stringForKey:@"is_remind"] boolValue];
        
        [info.goodInfos addObject:goodInfo];
    }
    
    return info;
}

@end
