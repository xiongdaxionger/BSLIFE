//
//  WMShopCarUnuseRuleInfo.m
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarPromotionRuleInfo.h"

@implementation WMShopCarPromotionRuleInfo

/**批量初始化
 */
+ (NSArray *)returnShopCarPromotionRuleInfosWithDictsArr:(NSArray *)dictsArr isGoodPromotion:(BOOL)isGoodPromotion
{
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMShopCarPromotionRuleInfo returnShopCarUnuseRuleInfoWithDict:dict isGoodPromotion:isGoodPromotion]];
    }
    
    return infosArr;
}

+ (instancetype)returnShopCarUnuseRuleInfoWithDict:(NSDictionary *)dict isGoodPromotion:(BOOL)isGoodPromotion{
    
    WMShopCarPromotionRuleInfo *info = [WMShopCarPromotionRuleInfo new];
    
    info.ruleName = [dict sea_stringForKey:@"name"];
    
    info.ruleTag = [dict sea_stringForKey:@"desc_tag"];
    
    info.canAction = isGoodPromotion ? YES : [[dict sea_stringForKey:@"fororder_status"] isEqualToString:@"true"];
        
    return info;
}

@end
