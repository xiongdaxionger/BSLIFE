//
//  WMStatisticalOperation.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/16.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


#import "WMStatisticalOperation.h"
#import "WMUserOperation.h"
#import "WMStatisticalInfo.h"
#import "WMHomeStatisticalInfo.h"
#import "WMUserInfo.h"

@implementation WMStatisticalOperation

/**获取访客统计数据 参数
 */
+ (NSDictionary*)visitorStatisticalParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.stats.visit", WMHttpMethod, nil];
}

/**获取访客统计数据 结果
 *@return 数组元素是WMStatisticalInfo
 */
+ (NSArray*)visitorStatisticalResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
  //  NSLog(@"%@", dic);
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSArray *array = [dic arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            WMStatisticalInfo *info = [WMStatisticalInfo infoFromDictionary:dict];
            info.type = WMStatisticalTypeOrder;
            [infos addObject:info];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**获取订单统计数据 参数
 */
+ (NSDictionary*)orderStatisticalParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.stats.order", WMHttpMethod, nil];
}

/**获取订单统计数据 结果
 *@return 数组元素是WMStatisticalInfo
 */
+ (NSArray*)orderStatisticalResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSArray *array = [[dic dictionaryForKey:WMHttpData] arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            WMStatisticalInfo *info = [WMStatisticalInfo infoFromDictionary:dict];
            info.type = WMStatisticalTypeOrder;
            [infos addObject:info];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**获取收入统计数据 参数
 */
+ (NSDictionary*)incomeStatisticalParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.stats.income", WMHttpMethod, nil];
}

/**获取收入统计数据 结果
 *@return  数组元素是WMStatisticalInfo
 */
+ (NSArray*)incomeStatisticalResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSArray *array = [[dic dictionaryForKey:WMHttpData] arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            WMStatisticalInfo *info = [WMStatisticalInfo infoFromDictionary:dict];
            info.type = WMStatisticalTypeEarn;
            [infos addObject:info];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**获取首页统计数据 参数
 */
+ (NSDictionary*)homeStatisticalInfoParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.stats.index", WMHttpMethod, nil];
}

/**获取首页统计数据 结果
 *@return 首页统计信息
 */
+ (WMHomeStatisticalInfo*)homeStatisticalInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    //NSLog(@"%@", dic);
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSDictionary *dataDic = [[dic dictionaryForKey:WMHttpData] dictionaryForKey:WMHttpData];
        WMHomeStatisticalInfo *info = [WMHomeStatisticalInfo infoFromDictionary:dataDic];
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

@end
