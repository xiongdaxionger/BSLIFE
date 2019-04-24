//
//  WMAdviceTypeInfo.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceTypeInfo.h"

@implementation WMAdviceTypeInfo
/**批量初始化
 */
+ (NSArray *)returnAdviceTypeInfoArrWithDataArr:(NSArray *)dataArr{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataArr.count];
    
    for (NSDictionary *dict in dataArr) {
        
        [arr addObject:[WMAdviceTypeInfo returnAdviceTypeInfoWithDict:dict]];
    }
    
    WMAdviceTypeInfo *firstInfo = [arr firstObject];
    
    firstInfo.adviceTypeIsSelect = YES;
    
    return arr;
}
+ (instancetype)returnAdviceTypeInfoWithDict:(NSDictionary *)dataDict{
    
    WMAdviceTypeInfo *info = [WMAdviceTypeInfo new];
    
    info.adviceTypeID = [dataDict sea_stringForKey:@"type_id"];
    
    info.adviceTypeName = [dataDict sea_stringForKey:@"name"];
    
    info.adviceTypeNumber = [dataDict sea_stringForKey:@"total"];
    
    info.adviceTypeIsSelect = NO;
    
    return info;
}
@end
