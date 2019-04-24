//
//  WMShopCarGoodInfo.m
//  StandardShop
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarGoodInfo.h"
#import "WMShopCarPromotionRuleInfo.h"
#import "WMOrderDetailOpeartion.h"
#import "WMMyOrderOperation.h"
#import "WMShopCarOperation.h"

/**购物车积分兑换商品模型
 */
@implementation WMShopCarExchangeGoodInfo
/**初始化
 */
+ (NSArray *)returnShopCarExchangeGoodInfosArrWithDictArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMShopCarExchangeGoodInfo returnShopCarExchangeGoodInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnShopCarExchangeGoodInfoWithDict:(NSDictionary *)dict{
    
    WMShopCarExchangeGoodInfo *info = [WMShopCarExchangeGoodInfo new];
    
    info.objIdent = [dict sea_stringForKey:@"obj_ident"];
        
    info.quantity = [dict sea_stringForKey:@"quantity"];
    
    info.salePrice = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.type = ShopCarGoodTypeExchangeGood;
    
    info.goodName = [dict sea_stringForKey:@"name"];
    
    info.formatGoodName = [WMMyOrderOperation returnGoodAttrNameWithType:OrderGoodTypePoint goodName:info.goodName];
    
    info.consumeScore = [dict sea_stringForKey:@"consume_score"];
        
    info.maxBuyCount = [dict sea_stringForKey:@"max"];
    
    info.specInfo = [dict sea_stringForKey:@"spec_info"];
    
    info.thumbnail = [dict sea_stringForKey:@"thumbnail"];
    
    info.isFav = [[dict numberForKey:@"is_fav"] boolValue];
    
    info.isSelect = [[dict sea_stringForKey:@"selected"] isEqualToString:@"true"];
    
    info.isEditSelect = NO;
        
    return info;
}

@end

/**订单/商品赠品模型
 */
@implementation WMShopCarOrderGiftGoodInfo
/**初始化
 */
+ (NSArray *)returnShopCarOrderGiftGoodInfosWithDictsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMShopCarOrderGiftGoodInfo returnShopCarOrderGiftGoodInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnShopCarOrderGiftGoodInfoWithDict:(NSDictionary *)dict{
    
    WMShopCarOrderGiftGoodInfo *info = [WMShopCarOrderGiftGoodInfo new];
        
    info.salePrice = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
        
    info.goodName = [dict sea_stringForKey:@"name"];
    
    info.formatGoodName = [WMMyOrderOperation returnGoodAttrNameWithType:OrderGoodTypeNormalGift goodName:info.goodName];
        
    info.specInfo = [dict sea_stringForKey:@"spec_info"];
    
    info.quantity = [dict sea_stringForKey:@"quantity"];
    
    info.thumbnail = [dict sea_stringForKey:@"thumbnail"];
    
    info.type = ShopCarGoodTypeGiftGood;
    
    info.descTag = [dict sea_stringForKey:@"desc_tag"];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    return info;
}

@end

/**配件商品模型
 */
@implementation WMShopCarAdjunctGoodInfo
/**初始化
 */
+ (NSArray *)returnShopCarAdjunctGoodInfosArrWithDcitsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMShopCarAdjunctGoodInfo returnShopCarAdjunctGoodInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnShopCarAdjunctGoodInfoWithDict:(NSDictionary *)dict{
    
    WMShopCarAdjunctGoodInfo *info = [WMShopCarAdjunctGoodInfo new];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodName = [dict sea_stringForKey:@"name"];
    
    info.formatGoodName = [WMMyOrderOperation returnGoodAttrNameWithType:OrderGoodTypeNormalAdjunct goodName:info.goodName];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.gainScore = [dict sea_stringForKey:@"subtotal_gain_score"];
    
    info.quantity = [dict sea_stringForKey:@"quantity"];
    
    info.specInfo = [dict sea_stringForKey:@"spec_info"];
    
    info.buyPrice = [dict sea_stringForKey:@"subtotal_price"];
    
    NSString *mktprice = [dict sea_stringForKey:@"mktprice"];
    
    if ([mktprice rangeOfString:[[dict sea_stringForKey:@"price"] substringWithRange:NSMakeRange(0, 1)]].location != NSNotFound) {
        
        info.salePrice = [WMPriceOperation formatPriceConbinationWithPrice:[dict sea_stringForKey:@"price"] priceFont:[UIFont fontWithName:MainFontName size:16.0] marketPrice:mktprice marketPriceFontSize:13.0];
    }
    else{
        
        info.salePrice = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    }
    
    info.maxBuyCount = [dict sea_stringForKey:@"max"];
    
    info.thumbnail = [dict sea_stringForKey:@"thumbnail"];
    
    info.type = ShopCarGoodTypeAdjunctGood;
    
    info.adjunctGroupID = [dict sea_stringForKey:@"group_id"];
    
    info.discountPirce = [dict sea_stringForKey:@"discount_amount"];
    
    info.subtotalPrice = [dict sea_stringForKey:@"subtotal_price"];
    
    info.isFav = [[dict numberForKey:@"is_fav"] boolValue];
    
    return info;
}


@end

/**购物车普通商品模型
 */
@implementation WMShopCarGoodInfo
/**批量初始化
 */
+ (NSArray *)returnShopCarGoodInfosArrWithDictsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMShopCarGoodInfo returnShopCarGoodInfoWithDict:dict]];
    }
    
    return infosArr;
}

+ (instancetype)returnShopCarGoodInfoWithDict:(NSDictionary *)dict{
    
    WMShopCarGoodInfo *goodInfo = [WMShopCarGoodInfo new];
    
    goodInfo.objIdent = [dict sea_stringForKey:@"obj_ident"];
        
    goodInfo.productID = [dict sea_stringForKey:@"product_id"];
    
    goodInfo.goodID = [dict sea_stringForKey:@"goods_id"];
    
    goodInfo.goodName = [dict sea_stringForKey:@"name"];
    
    goodInfo.gainScore = [dict sea_stringForKey:@"subtotal_gain_score"];
    
    goodInfo.specInfo = [dict sea_stringForKey:@"spec_info"];
    
    goodInfo.goodStore = [dict sea_stringForKey:@"store"];
    
    goodInfo.maxBuyCount = [dict sea_stringForKey:@"max"];
    
    goodInfo.salePrice = [dict sea_stringForKey:@"price"];
    
    NSString *mktprice = [dict sea_stringForKey:@"mktprice"];
        
    if ([mktprice rangeOfString:[[dict sea_stringForKey:@"price"] substringWithRange:NSMakeRange(0, 1)]].location != NSNotFound) {
        
        goodInfo.buyPrice = [WMPriceOperation formatPriceConbinationWithPrice:[dict sea_stringForKey:@"price"] priceFont:[UIFont fontWithName:MainFontName size:16.0] marketPrice:mktprice marketPriceFontSize:13.0];
    }
    else{
        
        goodInfo.buyPrice = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    }
    
    goodInfo.thumbnail = [dict sea_stringForKey:@"thumbnail"];
    
    goodInfo.quantity = [dict sea_stringForKey:@"quantity"];
    
    goodInfo.subtotalPrice = [dict sea_stringForKey:@"subtotal_prefilter_after"];
    
    goodInfo.discountPrice = [dict sea_stringForKey:@"discount_amount"];
    
    goodInfo.giftGoodsArr = [WMShopCarOrderGiftGoodInfo returnShopCarOrderGiftGoodInfosWithDictsArr:[dict arrayForKey:@"gift"]];
    
    goodInfo.adjunctGoodsArr = [WMShopCarAdjunctGoodInfo returnShopCarAdjunctGoodInfosArrWithDcitsArr:[dict arrayForKey:@"adjunct"]];
    
    goodInfo.goodGiftAdjunctsArr = [NSMutableArray new];
    
    [goodInfo.goodGiftAdjunctsArr addObjectsFromArray:goodInfo.giftGoodsArr];
    
    [goodInfo.goodGiftAdjunctsArr addObjectsFromArray:goodInfo.adjunctGoodsArr];
    
    NSString *special_type = [dict sea_stringForKey:@"special_type"];
    
    if (![NSString isEmpty:special_type]) {
        
        WMShopCarPromotionRuleInfo *ruleInfo = [WMShopCarPromotionRuleInfo new];
        
        ruleInfo.ruleName = [dict sea_stringForKey:@"special_name"];
        
        ruleInfo.ruleTag = special_type;
        
        goodInfo.goodPromotionsArr = @[ruleInfo];
    }
    else{
        
        goodInfo.goodPromotionsArr = [WMShopCarPromotionRuleInfo returnShopCarPromotionRuleInfosWithDictsArr:[dict arrayForKey:@"promotion"] isGoodPromotion:YES];
    }
    
    goodInfo.type = ShopCarGoodTypeNormalGood;
    
    goodInfo.goodPromotionAttrString = [WMOrderDetailOpeartion returnPromotionAttrStringWithPromotionsArr:goodInfo.goodPromotionsArr];
        
    if (goodInfo.goodStore.integerValue == 0) {
        
        goodInfo.isSelect = NO;
    }
    else{
        
        goodInfo.isSelect = [[dict sea_stringForKey:@"selected"] isEqualToString:@"true"];
    }
    
    goodInfo.isFav = [[dict numberForKey:@"is_fav"] boolValue];
    
    goodInfo.isEditSelect = NO;
    
    return goodInfo;
}



@end

/**购物车商品组别模型
 */
@implementation WMShopCarGoodGroupInfo
/**初始化
 */
+ (instancetype)returnShopCarGroupInfoWithType:(ShopCarGoodGroupType)type infosArr:(NSArray *)infosArr{
    
    WMShopCarGoodGroupInfo *groupInfo = [WMShopCarGoodGroupInfo new];
    
    groupInfo.type = type;
    
    NSArray *goodInfosArr;
    
    switch (type) {
        case ShopCarGoodGroupTypeNormalGroup:
        {
            goodInfosArr = [WMShopCarGoodInfo returnShopCarGoodInfosArrWithDictsArr:infosArr];
        }
            break;
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            goodInfosArr = [WMShopCarExchangeGoodInfo returnShopCarExchangeGoodInfosArrWithDictArr:infosArr];
        }
            break;
        case ShopCarGoodGroupTypeOrderGiftGroup:
        {
            goodInfosArr = [WMShopCarOrderGiftGoodInfo returnShopCarOrderGiftGoodInfosWithDictsArr:infosArr];
        }
            break;
        default:
            break;
    }
    
    groupInfo.goodInfosArr = [NSMutableArray arrayWithArray:goodInfosArr];
    
    return groupInfo;
}

/**返回对应的商品ID
 */
- (NSString *)returnGoodIDWithIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [self.goodInfosArr objectAtIndex:indexPath.row];
            
            return exchangeGoodInfo.goodID;
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [self.goodInfosArr firstObject];
            
            if (indexPath.row == 0) {
                
                return normalGoodInfo.goodID;
            }
            else{
                
                id otherGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                
                if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                    
                    WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)otherGoodInfo;
                    
                    return adjunctGoodInfo.goodID;
                }
                else {
                    
                    WMShopCarOrderGiftGoodInfo *giftGoodInfo = (WMShopCarOrderGiftGoodInfo *)otherGoodInfo;
                    
                    return giftGoodInfo.goodID;
                }
                
            }
        }
            break;
        case ShopCarGoodGroupTypeOrderGiftGroup:
        {
            WMShopCarOrderGiftGoodInfo *giftGoodInfo = [self.goodInfosArr objectAtIndex:indexPath.row];
            
            return giftGoodInfo.goodID;
        }
            break;
        default:
            break;
    }
}
/**返回对应的货品ID
 */
- (NSString *)returnProductIDWithIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [self.goodInfosArr objectAtIndex:indexPath.row];
            
            return exchangeGoodInfo.productID;
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [self.goodInfosArr firstObject];
            
            if (indexPath.row == 0) {
                
                return normalGoodInfo.productID;
            }
            else{
                
                id otherGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                
                if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                    
                    WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)otherGoodInfo;
                    
                    return adjunctGoodInfo.productID;
                }
                else {
                    
                    WMShopCarOrderGiftGoodInfo *giftGoodInfo = (WMShopCarOrderGiftGoodInfo *)otherGoodInfo;
                    
                    return giftGoodInfo.productID;
                }
                
            }
        }
            break;
        case ShopCarGoodGroupTypeOrderGiftGroup:
        {
            WMShopCarOrderGiftGoodInfo *giftGoodInfo = [self.goodInfosArr objectAtIndex:indexPath.row];
            
            return giftGoodInfo.productID;
        }
            break;
        default:
            break;
    }
}

/**返回能否侧滑控制
 */
- (BOOL)returnCanEditWithIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            return YES;
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [self.goodInfosArr firstObject];
            
            if (indexPath.row == 0) {
                
                return YES;
            }
            else{
                
                id otherGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                
                if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                    
                    return YES;
                }
                else{
                    
                    return NO;
                }
                
            }
        }
            break;
        case ShopCarGoodGroupTypeOrderGiftGroup:
        {
            return NO;
        }
            break;
        default:
            break;
    }
}

/**改变对应商品的收藏状态
 */
- (void)changeGoodFavStatusWithIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.type) {
        case ShopCarGoodGroupTypeExchangeGroup:
        {
            WMShopCarExchangeGoodInfo *exchangeGoodInfo = [self.goodInfosArr objectAtIndex:indexPath.row];
            
            exchangeGoodInfo.isFav = YES;
        }
            break;
        case ShopCarGoodGroupTypeNormalGroup:
        {
            WMShopCarGoodInfo *normalGoodInfo = [self.goodInfosArr firstObject];
            
            if (indexPath.row == 0) {
                
                normalGoodInfo.isFav = YES;
            }
            else{
                
                id otherGoodInfo = [normalGoodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                
                if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                    
                    WMShopCarAdjunctGoodInfo *adjunctGoodInfo = (WMShopCarAdjunctGoodInfo *)otherGoodInfo;
                    
                    adjunctGoodInfo.isFav = YES;
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


@end

/**凑单商品模型
 */
@implementation WMShopCarForOrderGoodInfo

/**批量初始化
 */
+ (NSArray *)returnForOrderGoodInfosArrWithDictsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        WMShopCarForOrderGoodInfo *info = [WMShopCarForOrderGoodInfo new];
        
        info.store = [dict sea_stringForKey:@"store"];
        
        info.name = [dict sea_stringForKey:@"name"];
        
        info.image = [dict sea_stringForKey:@"image_default_id"];
        
        info.price = [dict sea_stringForKey:@"price"];
        
        info.productID = [dict sea_stringForKey:@"product_id"];
        
        info.goodID = [dict sea_stringForKey:@"goods_id"];
        
        [infosArr addObject:info];
    }
    
    return infosArr;
}





@end








