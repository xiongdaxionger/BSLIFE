//
//  WMGoodListOrderByInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListOrderByInfo.h"
#import "WMGoodListOperation.h"

@implementation WMGoodListOrderByInfo

/**通过字典获取排序信息
 *@param dic 包含排序信息的字典
 *@return 数组元素是 WMGoodListOrderByInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic
{
    NSArray *array = [dic arrayForKey:@"orderBy"];

    if(array.count > 0)
    {
        NSMutableArray *infos = [NSMutableArray array];

        for(NSDictionary *dict in array)
        {
            NSString *key = [dict sea_stringForKey:@"sql"];

            ///去掉销量、价格升序、价格降序
            if(!([key isEqualToString:WMGoodOrderByPiceAsc] || [key isEqualToString:WMGoodOrderByPiceDesc] || [key isEqualToString:WMGoodOrderByBuyCountDesc] || [key isEqualToString:WMGoodOrderByWeekBuyCountDesc]))
            {
                WMGoodListOrderByInfo *info = [[WMGoodListOrderByInfo alloc] init];
                info.name = [dict sea_stringForKey:@"label"];
                info.key = key;

                [infos addObject:info];
            }
        }
        
        return infos;
    }

    return nil;
}

@end
