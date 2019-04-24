//
//  WMLogisticsInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMLogisticsInfo.h"

@implementation WMLogisticsInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMLogisticsInfo *info = [[WMLogisticsInfo alloc] init];
    
    NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
    
    NSString *name = [dataDic sea_stringForKey:@"logi_name"];
    NSString *number = [dataDic sea_stringForKey:@"logi_no"];
    
    info.name = [NSString stringWithFormat:@"快递公司：%@", [NSString isEmpty:name] ? @"暂无物流信息" : name];
    info.number = [NSString stringWithFormat:@"运单编号：%@", [NSString isEmpty:number] ? @"暂无物流信息" : number];

        ///物流详情
    NSArray *array = [dataDic arrayForKey:@"logi"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
    
    for(NSDictionary *dict in array)
    {
        WMLogisticsDetailInfo *detailInfo = [[WMLogisticsDetailInfo alloc] init];
        detailInfo.content = [dict sea_stringForKey:@"AcceptStation"];
        detailInfo.time = [dict sea_stringForKey:@"AcceptTime"];
        [infos addObject:detailInfo];
    }
    
    info.infos = infos;
    
    return info;
}

@end

@implementation WMLogisticsDetailInfo


@end
