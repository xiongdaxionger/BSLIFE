//
//  WMGoodSpecInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailSpecInfo.h"

@implementation WMGoodDetailSpecValueInfo
/**批量初始化
 */
+ (NSArray *)returnGoodSpecValueInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [infosArr addObject:[WMGoodDetailSpecValueInfo returnGoodSpecValueInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnGoodSpecValueInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailSpecValueInfo *info = [WMGoodDetailSpecValueInfo new];
    
    info.valueSelect = [[dict sea_stringForKey:@"select"] isEqualToString:@"true"];
    
    info.valueProductID = [dict sea_stringForKey:@"product_id"];
    
    info.valueSpecImage = [dict sea_stringForKey:@"spec_image"];
    
    info.valueSpecName = [dict sea_stringForKey:@"spec_value"];
    
    return info;
}

@end

@implementation WMGoodDetailSpecInfo
/**批量初始化
 */
+ (NSArray *)returnGoodSpecInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [infosArr addObject:[WMGoodDetailSpecInfo returnGoodSpecInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnGoodSpecInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailSpecInfo *info = [WMGoodDetailSpecInfo new];

    info.specInfoName = [dict sea_stringForKey:@"group_name"];
    
    info.specValueInfosArr = [WMGoodDetailSpecValueInfo returnGoodSpecValueInfoArrWithDictArr:[dict arrayForKey:@"group_spec"]];
    
    if (info.specValueInfosArr.count) {
        
        WMGoodDetailSpecValueInfo *value = [info.specValueInfosArr firstObject];
        
        if ([NSString isEmpty:value.valueSpecImage]) {
            
            info.specInfoIsImage = NO;
        }
        else{
            
            info.specInfoIsImage = YES;
        }
    }
    
    info.titlesArr = [NSMutableArray new];
        
    for (WMGoodDetailSpecValueInfo *valueInfo in info.specValueInfosArr) {
        
        [info.titlesArr addObject:valueInfo.valueSpecName];
        
        if (valueInfo.valueSelect) {
            
            info.selectIndex = [info.specValueInfosArr indexOfObject:valueInfo];
        }
    }
    
    return info;
}




@end
