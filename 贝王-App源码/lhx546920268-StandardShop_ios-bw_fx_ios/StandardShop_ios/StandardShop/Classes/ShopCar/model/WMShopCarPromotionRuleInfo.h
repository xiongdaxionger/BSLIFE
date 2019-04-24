//
//  WMShopCarUnuseRuleInfo.h
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**购物车未享受优惠/商品享受的优惠模型
 */
@interface WMShopCarPromotionRuleInfo : NSObject
/**优惠名称
 */
@property (copy,nonatomic) NSString *ruleName;
/**优惠标签
 */
@property (copy,nonatomic) NSString *ruleTag;
/**显示未享受优惠时用于判断能否凑单/显示商品享受优惠时用于判断能否显示优惠
 */
@property (assign,nonatomic) BOOL canAction;
/**批量初始化
 */
+ (NSArray *)returnShopCarPromotionRuleInfosWithDictsArr:(NSArray *)dictsArr isGoodPromotion:(BOOL)isGoodPromotion;
@end
