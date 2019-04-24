//
//  WMShakeOperation.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeOperation.h"
#import "WMShakeInfo.h"
#import "WMUserOperation.h"
#import "WMShakeResultInfo.h"
#import "WMShakeWinnerInfo.h"

@implementation WMShakeOperation

/**获取摇一摇信息，包括可摇次数，摇一摇规则，获奖名单等 参数
 *@param pageIndex 页码 第一页有 摇一摇信息，包括可摇次数，摇一摇规则
 */
+ (NSDictionary*)shakeInfoParamsWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"game.yiy.index", WMHttpMethod, pageIndex == WMHttpPageIndexStartingValue ? @"1" : @"3", @"type", [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
}

/**获取摇一摇信息，包括可摇次数，摇一摇规则，获奖名单等 结果
 *@param totalSize 获取名单总数
 *@param info 摇一摇信息
 *@return 获奖名单 数组元素是 WMShakeWinnerInfo
 */
+ (NSArray*)shakeInfoFromData:(NSData*) data totalSize:(long long*) totalSize info:(WMShakeInfo**) info
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        if(totalSize != nil)
        {
            NSDictionary *pageDic = [dataDic dictionaryForKey:@"winners_list_pager"];
            *totalSize = [[pageDic numberForKey:@"dataCount"] longLongValue];
        }
        
        ///摇一摇信息
        if(info != nil)
        {
            WMShakeInfo *shakeInfo = [[WMShakeInfo alloc] init];
            
            long long count = [[dataDic numberForKey:@"limit_count"] intValue];
            shakeInfo.isInfinite = count == 0;
            shakeInfo.timesToShake = [[dataDic numberForKey:@"usage_limit"] intValue];
            shakeInfo.rule = [dataDic sea_stringForKey:@"rule_desc"];
            *info = shakeInfo;
        }
        
        ///获奖名单
        NSArray *array = [dataDic arrayForKey:@"winners_list"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            NSString *name = [dict sea_stringForKey:@"username"];
            NSString *prize = [[dict dictionaryForKey:@"data"] sea_stringForKey:@"name"];
            
            if(!name)
                name = @"";
            if(!prize)
                prize = @"";
            
            WMShakeWinnerInfo *info = [[WMShakeWinnerInfo alloc] init];
            info.text = [NSString stringWithFormat:@"%@获得%@", name, prize];
            
            [infos addObject:info];
        }
        
        return infos;
    }
    
    return nil;
}

/**摇一摇结果 参数
 */
+ (NSDictionary*)shakeResultParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"game.yiy.action", WMHttpMethod, @"1", @"type", nil];
}

/**摇一摇结果
 *@return 成功返回结果，否则返回nil
 */
+ (WMShakeResultInfo*)shakeResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        return [WMShakeResultInfo infoFromDictionary:dataDic];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

@end
