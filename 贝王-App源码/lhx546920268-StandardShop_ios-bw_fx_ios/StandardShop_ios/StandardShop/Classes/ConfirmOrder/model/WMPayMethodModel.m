//
//  WMPayMethodModel.m
//  StandardFenXiao
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMPayMethodModel.h"

@implementation WMPayMethodModel
/**批量初始化
 */
+ (NSMutableArray *)returnPayInfoArrWith:(NSArray *)dataArr{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:dataArr.count];
    
    for (NSDictionary *dict in dataArr) {
        
        [mutArr addObject:[WMPayMethodModel returnModelWith:dict]];
    }
    
    return mutArr;
}

+ (instancetype)returnModelWith:(NSDictionary *)dict{
    
    WMPayMethodModel *model = [[WMPayMethodModel alloc] init];
    
    model.payInfoDesc = [dict sea_stringForKey:@"app_pay_brief"];
    
    model.payInfoIcon = [dict sea_stringForKey:@"icon_src"];
    
    model.payInfoID = [dict sea_stringForKey:@"app_id"];
    
    model.payInfoName = [NSString isEmpty:[dict sea_stringForKey:@"app_name"]] ? [dict sea_stringForKey:@"app_display_name"] : [dict sea_stringForKey:@"app_name"];
    
    model.payJsonString = [dict sea_stringForKey:@"value"];
    
    model.payIsSelect = [[dict sea_stringForKey:@"checked"] isEqualToString:@"true"];
    
    return model;
}
@end
