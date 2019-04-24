//
//  WMGoodDetailPrepareInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailPrepareInfo.h"

@implementation WMGoodDetailPrepareInfo
/**初始化
 */
+ (instancetype)returnGoodDetailPrepareInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailPrepareInfo *prepareInfo = [WMGoodDetailPrepareInfo new];
    
    prepareInfo.prepareBargainMoney = [dict sea_stringForKey:@"preparesell_price"];
    
    prepareInfo.prepareBragainBeginTime = [dict sea_stringForKey:@"begin_time"];
    
    prepareInfo.prepareBragainEndTime = [dict sea_stringForKey:@"end_time"];
    
    prepareInfo.prepareFinalBeginTime = [dict sea_stringForKey:@"begin_time_final"];
    
    prepareInfo.prepareFinalEndTime = [dict sea_stringForKey:@"end_time_final"];
    
    prepareInfo.prepareGoodPrice = [dict sea_stringForKey:@"promotion_price"];
    
    prepareInfo.prepareID = [dict sea_stringForKey:@"prepare_id"];
    
    prepareInfo.prepareProductID = [dict sea_stringForKey:@"product_id"];
    
    prepareInfo.prepareRuleName = [dict sea_stringForKey:@"preparename"];
    
    prepareInfo.prepareStatusMessage = [dict sea_stringForKey:@"message"];
    
    prepareInfo.prepareRuleDescription = [dict sea_stringForKey:@"description"];
    
    prepareInfo.prepareStore = [dict sea_stringForKey:@"initial_num"];
    
    prepareInfo.type = [[dict sea_stringForKey:@"status"] integerValue];
    
    return prepareInfo;
}

@end

@implementation WMGoodDetailSecondKillInfo
/**初始化
 */
+ (instancetype)returnGoodDetailSecondKillInfoWithDict:(NSDictionary *)dict{

    WMGoodDetailSecondKillInfo *secondKillInfo = [WMGoodDetailSecondKillInfo new];
    
    secondKillInfo.secondKillName = [dict sea_stringForKey:@"name"];

    secondKillInfo.secondKillDescription = [dict sea_stringForKey:@"description"];
    
    secondKillInfo.secondKillBeginTime = [dict sea_stringForKey:@"begin_time"];
    
    secondKillInfo.secondKillEndTime = [dict sea_stringForKey:@"end_time"];
    
    return secondKillInfo;
}
@end
