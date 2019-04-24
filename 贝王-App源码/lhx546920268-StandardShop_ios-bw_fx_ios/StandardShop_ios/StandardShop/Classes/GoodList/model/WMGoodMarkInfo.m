//
//  WMGoodMarkInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodMarkInfo.h"

@implementation WMGoodMarkInfo

/**通过字典创建
 *@param dic 包含标记信息的字典
 *@return 数组元素是 WMGoodMarkInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic
{
    NSArray *array = [dic arrayForKey:@"promotion_tags"];
    if(array.count > 0)
    {
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

        for(NSDictionary *dict in array)
        {
            WMGoodMarkInfo *info = [[WMGoodMarkInfo alloc] init];
            info.text = [dict sea_stringForKey:@"tag_name"];
            [infos addObject:info];
        }

        return infos;
    }

    return nil;
}

@end
