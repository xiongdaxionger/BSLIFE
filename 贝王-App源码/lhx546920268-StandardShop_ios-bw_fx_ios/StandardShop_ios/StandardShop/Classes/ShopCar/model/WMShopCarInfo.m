//
//  WMShopCarInfo.m
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarInfo.h"
#import "WMShopCarGoodInfo.h"
#import "WMShopCarPromotionRuleInfo.h"

@implementation WMShopCarInfo
/**初始化
 */
+ (instancetype)returnShopCarInfoWithDict:(NSDictionary *)dict{
    
    WMShopCarInfo *info = [WMShopCarInfo new];
    
    info.showUnusePromotion = [[dict sea_stringForKey:@"cart_promotion_display"] isEqualToString:@"true"];
    
    info.unuseRuleInfosArr = [WMShopCarPromotionRuleInfo returnShopCarPromotionRuleInfosWithDictsArr:[dict arrayForKey:@"unuse_rule"] isGoodPromotion:NO];
    
    NSDictionary *aCartDict = [dict dictionaryForKey:@"aCart"];
    
    info.useRuleInfosArr = [WMShopCarPromotionRuleInfo returnShopCarPromotionRuleInfosWithDictsArr:[[aCartDict dictionaryForKey:@"promotion"] arrayForKey:@"order"] isGoodPromotion:NO];
    
    info.subtotalDiscount = [aCartDict sea_stringForKey:@"discount_amount_order"];
    
    info.subtotalGainScore = [aCartDict sea_stringForKey:@"subtotal_gain_score"];
    
    info.subtotalPrice = [aCartDict sea_stringForKey:@"promotion_subtotal"];
    
    info.shopCarGoodsArr = [NSMutableArray new];
    
    NSDictionary *objectDict = [aCartDict dictionaryForKey:@"object"];
    
    NSArray *normalGoodsArr = [objectDict arrayForKey:@"goods"];
    
    if (normalGoodsArr.count && normalGoodsArr) {
        
        NSArray *shopCarGoodInfos = [WMShopCarGoodInfo returnShopCarGoodInfosArrWithDictsArr:normalGoodsArr];
        
        for (WMShopCarGoodInfo *goodInfo in shopCarGoodInfos) {
            
            WMShopCarGoodGroupInfo *goodGroupInfo = [WMShopCarGoodGroupInfo new];
            
            goodGroupInfo.goodInfosArr = [NSMutableArray arrayWithObject:goodInfo];
            
            goodGroupInfo.type = ShopCarGoodGroupTypeNormalGroup;
            
            [info.shopCarGoodsArr addObject:goodGroupInfo];
        }
    }
    
    NSDictionary *giftDict = [objectDict dictionaryForKey:@"gift"];
    
    NSArray *exchangeGoodsArr = [giftDict arrayForKey:@"cart"];
    
    if (exchangeGoodsArr.count && exchangeGoodsArr) {
        
        [info.shopCarGoodsArr addObject:[WMShopCarGoodGroupInfo returnShopCarGroupInfoWithType:ShopCarGoodGroupTypeExchangeGroup infosArr:exchangeGoodsArr]];
    }
    
    NSArray *orderGiftGoodsArr = [giftDict arrayForKey:@"order"];
    
    if (orderGiftGoodsArr.count && orderGiftGoodsArr) {
        
        [info.shopCarGoodsArr addObject:[WMShopCarGoodGroupInfo returnShopCarGroupInfoWithType:ShopCarGoodGroupTypeOrderGiftGroup infosArr:orderGiftGoodsArr]];
    }
    
    BOOL isContaintOrderGift = NO;
    
    for (WMShopCarGoodGroupInfo *groupInfo in info.shopCarGoodsArr) {
        
        isContaintOrderGift = groupInfo.type == ShopCarGoodGroupTypeOrderGiftGroup ? YES : NO;
    }
    
    info.isContaintOrderGift = isContaintOrderGift;
    
    return info;
}

/**返回当前购物车的已选商品数量--普通商品、配件商品和积分兑换商品
 */
- (NSInteger)returnCurrentShopCarQuantity{
    
    NSInteger quantity = 0;
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    quantity = quantity + (exchangeGoodInfo.isSelect ? exchangeGoodInfo.quantity.integerValue : 0);
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (normalGoodInfo.isSelect) {
                    
                    quantity = quantity + normalGoodInfo.quantity.integerValue;
                    
                    for (WMShopCarAdjunctGoodInfo *adjunctGoodInfo in normalGoodInfo.adjunctGoodsArr) {
                        
                        quantity = quantity + adjunctGoodInfo.quantity.integerValue;
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
//                quantity += groupInfo.goodInfosArr.count;
            }
                break;
            default:
                break;
        }
    }
    
    return quantity;
}

/**返回当前购物车的未选商品数量--只包括普通商品和普通商品的配件商品，此外商品不计算
 */
- (NSInteger)returnCurrentUnSelectShopCarQuantity{
    
    NSInteger quantity = 0;
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                quantity = quantity + normalGoodInfo.quantity.integerValue;
                
                for (WMShopCarAdjunctGoodInfo *adjunctGoodInfo in normalGoodInfo.adjunctGoodsArr) {
                    
                    quantity = quantity + adjunctGoodInfo.quantity.integerValue;
                }
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                
            }
                break;
            default:
                break;
        }
    }
    
    return quantity;
}

/**返回当前购物车商品是否全部选中--网络状态的选中
 */
- (BOOL)returnCurrentShopCarSelectStatus{
    
    BOOL isSelectAll = YES;
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    if (!exchangeGoodInfo.isSelect) {
                        
                        isSelectAll = NO;
                        
                        break;
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (normalGoodInfo.goodStore.integerValue != 0 && !normalGoodInfo.isSelect) {
                    
                    isSelectAll = NO;
                }
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
            }
                break;
            default:
                break;
        }
    }
    
    return isSelectAll;
}

/**返回当前购物车商品是否全部选中--编辑状态的选中
 */
- (BOOL)returnCurrentShopCarEditSelectStatus{
    
    BOOL isSelectAll = YES;
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    if (!exchangeGoodInfo.isEditSelect) {
                        
                        isSelectAll = NO;
                        
                        break;
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (!normalGoodInfo.isEditSelect && normalGoodInfo.goodStore.integerValue != 0) {
                    
                    isSelectAll = NO;
                }
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
            }
                break;
            default:
                break;
        }
    }
    
    return isSelectAll;
}

/**返回当前购物车选中的商品obj_ident[]
 */
- (NSArray *)returnCurrentShopCarSelectGoodsIdent:(BOOL)isEdit{
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    if (isEdit) {
                        
                        if (exchangeGoodInfo.isEditSelect) {
                            
                            [arr addObject:exchangeGoodInfo.objIdent];
                        }
                    }
                    else{
                        
                        if (exchangeGoodInfo.isSelect) {
                            
                            [arr addObject:exchangeGoodInfo.objIdent];
                        }
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (isEdit) {
                   
                    if (normalGoodInfo.isEditSelect) {
                        
                        [arr addObject:normalGoodInfo.objIdent];
                    }
                }
                else{
                    
                    if (normalGoodInfo.isSelect) {
                        
                        [arr addObject:normalGoodInfo.objIdent];
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
            }
                break;
            default:
                break;
        }
    }
    
    return arr;
}

- (void)selectAllGoodIsSelect:(BOOL)isSelect{
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    exchangeGoodInfo.isSelect = isSelect;
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (normalGoodInfo.goodStore.integerValue == 0) {
                    
                    normalGoodInfo.isSelect = NO;
                }
                else{
                    
                    normalGoodInfo.isSelect = isSelect;
                }
            }
            default:
                break;
        }
    }
}

/**编辑状态下所有商品的选中/取消选中
 */
- (void)changeEditStatusSelect:(BOOL)isEditSelect{
    
    for (WMShopCarGoodGroupInfo *groupInfo in self.shopCarGoodsArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    exchangeGoodInfo.isEditSelect = isEditSelect;
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];
                
                if (normalGoodInfo.goodStore.integerValue == 0) {
                    
                    normalGoodInfo.isEditSelect = NO;
                }
                else{
                    
                    normalGoodInfo.isEditSelect = isEditSelect;
                }
            }
            default:
                break;
        }
    }
}

/**返回组数
 */
- (NSInteger)returnSectionNumbers{
    
    if (self.unuseRuleInfosArr.count && self.useRuleInfosArr.count) {
        
        return self.showUnusePromotion ? self.shopCarGoodsArr.count + 2 : self.shopCarGoodsArr.count + 1;
    }
    else if (self.unuseRuleInfosArr.count || self.useRuleInfosArr.count){
        
        if (self.unuseRuleInfosArr.count) {
            
            return self.showUnusePromotion ? self.shopCarGoodsArr.count + 1 : self.shopCarGoodsArr.count;
        }
        else{
            
            return self.shopCarGoodsArr.count + 1;
        }
    }
    else{
        
        return self.shopCarGoodsArr.count;
    }
}

/**返回每组行数
 */
- (NSInteger)returnRowNumberOfSection:(NSInteger)section{
    
    if (section >= 0 && section < self.shopCarGoodsArr.count) {
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [self.shopCarGoodsArr objectAtIndex:section];
        
        switch (goodGroupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                return goodGroupInfo.goodInfosArr.count;
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr firstObject];
                
                return goodInfo.goodPromotionsArr.count ? goodInfo.goodGiftAdjunctsArr.count + 2 : goodInfo.goodGiftAdjunctsArr.count + 1;
            }
                break;
            default:
            {
                return CGFLOAT_MIN;
            }
                break;
        }
    }
    
    if (self.unuseRuleInfosArr.count && self.useRuleInfosArr.count) {
        
        if (self.showUnusePromotion) {
            
            if (section == self.shopCarGoodsArr.count) {
                
                return self.useRuleInfosArr.count;
            }
            else{
                
                return self.unuseRuleInfosArr.count;
            }
        }
        else{
            
            return self.useRuleInfosArr.count;
        }
    }
    else if (self.unuseRuleInfosArr.count || self.useRuleInfosArr.count){
        
        if (self.unuseRuleInfosArr.count) {
            
            return self.showUnusePromotion ? self.unuseRuleInfosArr.count : CGFLOAT_MIN;
        }
        else{
            
            return self.useRuleInfosArr.count;
        }
    }
    else{
        
        return CGFLOAT_MIN;
    }
}
/**返回数据模型
 */
- (id)returnInfoWithIndexPath:(NSIndexPath *)indexPath{
    
    if (self.unuseRuleInfosArr.count && self.useRuleInfosArr.count) {
        
        if (self.showUnusePromotion) {
            
            if (indexPath.section == self.shopCarGoodsArr.count) {
                
                return [self.useRuleInfosArr objectAtIndex:indexPath.row];
            }
            else{
                
                return [self.unuseRuleInfosArr objectAtIndex:indexPath.row];
            }
        }
        else{
            
            return [self.useRuleInfosArr objectAtIndex:indexPath.row];
        }
    }
    else if (self.unuseRuleInfosArr.count || self.useRuleInfosArr.count){
        
        if (self.unuseRuleInfosArr.count) {
            
            return [self.unuseRuleInfosArr objectAtIndex:indexPath.row];
        }
        else{
            
            return [self.useRuleInfosArr objectAtIndex:indexPath.row];
        }
    }
    else{
        
        return nil;
    }
}





@end
