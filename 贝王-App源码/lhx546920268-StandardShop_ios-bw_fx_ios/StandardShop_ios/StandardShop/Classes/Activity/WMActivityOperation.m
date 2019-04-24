//
//  WMActivityOperation.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMActivityOperation.h"
#import "WMUserOperation.h"
#import "WMActivityInfo.h"

@implementation WMActivityOperation

/**获取活动列表 参数
 */
+ (NSDictionary*)activityListParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.activity.alist", WMHttpMethod, nil];
}

/**获取活动列表 结果
 *@return 数组元素是 WMActivityInfo
 */
+ (NSArray*)activityListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSArray *array = [dic arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMActivityInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }

    return nil;
}

@end
