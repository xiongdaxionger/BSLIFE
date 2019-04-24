//
//  WMAreaInfo.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMAreaInfo.h"


@implementation WMAreaInfo

- (id)copyWithZone:(NSZone *)zone
{
    WMAreaInfo *info = [[WMAreaInfo allocWithZone:zone] init];
    info.Id = self.Id;
    info.name = self.name;
    
    return info;
}

/**通过字典创建
 *@param treeDic 包含地区结构的字典
 *@param infoDic 包含所有地区信息的字典
 *@param areaId 地区id
 *@return 如果存在，则返回对应的地区信息，否则返回nil
 */
+ (instancetype)infoFromTreeDic:(NSDictionary*) treeDic infoDic:(NSDictionary*) infoDic areaId:(NSString*) areaId
{
    NSDictionary *dict = [infoDic objectForKey:areaId];
    if(!dict)
        return nil;
    
    WMAreaInfo *info = [[WMAreaInfo alloc] init];
    info.Id = [[dict numberForKey:@"region_id"] longLongValue];
    info.name = [dict sea_stringForKey:@"local_name"];
    
    ///拿次级地区
    NSArray *items = [treeDic objectForKey:areaId];
    if(items.count > 0)
    {
        info.childAreaInfos = [NSMutableArray arrayWithCapacity:items.count];
        for(NSString *Id2 in items)
        {
            [info.childAreaInfos addNotNilObject:[WMAreaInfo infoFromTreeDic:treeDic infoDic:infoDic areaId:Id2]];
        }
    }
    
    return info;
}

@end

