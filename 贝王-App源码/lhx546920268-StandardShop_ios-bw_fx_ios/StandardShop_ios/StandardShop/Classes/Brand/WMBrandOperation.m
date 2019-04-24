//
//  WMBrandOperation.m
//  WanShoes
//
//  Created by 罗海雄 on 16/4/1.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMBrandOperation.h"
#import "WMBrandInfo.h"
#import "WMHomeAdInfo.h"
#import "WMUserOperation.h"

@implementation WMBrandOperation

/**获取所有品牌列表 参数
 *@param pageIndex 页码
 *@param pageSize 每页数量
 */
+ (NSDictionary*)brandListParamsWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.brand.showList", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
}

/**获取所有品牌列表 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMBrandInfo
 */
+ (NSArray*)brandListFromData:(NSData*) data totalSize:(long long *) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        NSArray *array = [dataDic arrayForKey:@"brandList"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMBrandInfo infoFromDictionary:dict]];
        }

        ///所有品牌数量
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        return infos;
    }
    
    return nil;
}

@end
