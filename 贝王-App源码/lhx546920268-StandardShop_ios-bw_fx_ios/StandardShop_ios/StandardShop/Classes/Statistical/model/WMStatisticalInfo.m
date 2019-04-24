//
//  WMStatisticalInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMStatisticalInfo.h"

///统计时间格式
#define WMStatisticalTimeFormat @"yyyy年mm月dd日"

@implementation WMStatisticalNodeInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMStatisticalNodeInfo *info = [[WMStatisticalNodeInfo alloc] init];
    info.yValue = [dic sea_stringForKey:@"data"];
    info.xTitle = [dic sea_stringForKey:@"day"];
    
    info.time = [dic sea_stringForKey:@"date"];
    
    return info;
}

@end

@implementation WMStatisticalDataInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMStatisticalDataInfo *info = [[WMStatisticalDataInfo alloc] init];
    info.sum = [dic sea_stringForKey:@"sum"];
    info.sumTitle = [dic sea_stringForKey:@"label"];
    
    ///节点数组
    NSArray *array = [dic arrayForKey:@"list"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
    
    for(NSDictionary *dict in array)
    {
        [infos addObject:[WMStatisticalNodeInfo infoFromDictionary:dict]];
    }
    
    info.infos = infos;
    
    return info;
}

@end

@implementation WMStatisticalInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMStatisticalInfo *info = [[WMStatisticalInfo alloc] init];
    info.menuTitle = [dic sea_stringForKey:@"label"];
    
    ///统计数据
    NSArray *array = [dic arrayForKey:@"list"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
    
    for(NSDictionary *dict in array)
    {
        [infos addObject:[WMStatisticalDataInfo infoFromDictionary:dict]];
    }
    
    info.infos = infos;
    
    return info;
}

@end
