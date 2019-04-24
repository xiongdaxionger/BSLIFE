//
//  WMGoodDetailParamInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailParamInfo.h"

@implementation WMGoodDetailParamValueInfo

/**初始化
 */
+ (NSArray *)returnGoodDetailParamValueInfosArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [infosArr addObject:[WMGoodDetailParamValueInfo returnGoodDetailParamValueInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnGoodDetailParamValueInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailParamValueInfo *value = [WMGoodDetailParamValueInfo new];
    
    value.paramContent = [dict sea_stringForKey:@"value"];
    
    value.paramName = [dict sea_stringForKey:@"name"];
    
    return value;
}

@end

@implementation WMGoodDetailParamInfo

/**初始化
 */
+ (NSArray *)returnGoodDetailParamInfosArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
//    dictArr = @[
//                                     @{
//                                         @"group_name": @"呵呵",
//                                         @"group_param": @[
//                                                         @{
//                                                             @"name": @"111",
//                                                             @"value": @"参数1值"
//                                                         },
//                                                         @{
//                                                             @"name": @"33",
//                                                             @"value": @"参数2值"
//                                                         },
//                                                         @{
//                                                             @"name": @"5454",
//                                                             @"value": @"参数3值"
//                                                         }
//                                                         ]
//                                     },
//                                     @{
//                                         @"group_name": @"呵呵",
//                                         @"group_param": @[
//                                                 @{
//                                                     @"name": @"111",
//                                                     @"value": @"参数1值"
//                                                     },
//                                                 @{
//                                                     @"name": @"33",
//                                                     @"value": @"参数2值"
//                                                     },
//                                                 @{
//                                                     @"name": @"5454",
//                                                     @"value": @"参数3值"
//                                                     }
//                                                 ]
//                                         }
//                                     ];
    
    for (NSDictionary *dict in dictArr) {
        
        [infosArr addObject:[WMGoodDetailParamInfo returnGoodDetailParamInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnGoodDetailParamInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailParamInfo *info = [WMGoodDetailParamInfo new];
    
    info.groupParamName = [dict sea_stringForKey:@"group_name"];
    
    info.groupParamsArr = [WMGoodDetailParamValueInfo returnGoodDetailParamValueInfosArrWithDictArr:[dict arrayForKey:@"group_param"]];
    
    return info;
}

@end
