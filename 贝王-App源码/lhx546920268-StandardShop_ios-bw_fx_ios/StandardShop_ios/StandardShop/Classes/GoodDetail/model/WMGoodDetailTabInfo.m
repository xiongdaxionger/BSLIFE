//
//  WMGoodDetailTabInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailTabInfo.h"

@implementation WMGoodDetailTabInfo
/**批量初始化
 */
+ (NSArray *)returnGoodTabInfoArrWithDictArr:(NSArray *)arr{
    
    NSMutableArray *infoArr = [NSMutableArray new];
    
    for (NSDictionary *dict in arr) {
        
        [infoArr addObject:[WMGoodDetailTabInfo returnGoodTabInfoWithDict:dict]];
    }
    
    return infoArr;
}

+ (instancetype)returnGoodTabInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailTabInfo *info = [WMGoodDetailTabInfo new];
    
    info.tabContent = [dict sea_stringForKey:@"content"];
    
    info.tabName = [dict sea_stringForKey:@"name"];
    
    info.type = GoodGraphicDetailTypeWeb;
    
    info.graphicHeight = 0.0;
    
    return info;
}
@end
