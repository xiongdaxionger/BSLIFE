//
//  WMShopCarOpeartion.m
//  SuYan
//
//  Created by mac on 16/4/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarOperation.h"
#import "WMUserOperation.h"
#import "WMShopCarInfo.h"
#import "WMShopCarGoodInfo.h"
#import "WMTabBarController.h"
#import "WMUserInfo.h"

@implementation WMShopCarOperation

#pragma mark - new
/**加入购物车/立即购买
 *@param 购买类型 btype--is_fastbuy(立即购买)/不传为加入购物车
 *@param 商品ID goods[goods_id]
 *@param 货品ID goods[product_id]
 *@param 购买数量 goods[num]
 *@param 配件参数 goods[adjunct][0][10781]--选择配件加入购物车的参数，0是配件组别的下标，10781是对应配件的货品ID，配件购买数量 
 #@param 商品类型 obj_type--goods商品/gift积分商品
 */
+ (NSMutableDictionary *)returnAddShopCarParamWithBuyType:(NSString *)buyType goodsID:(NSString *)goodsID productID:(NSString *)productID buyQuantity:(NSInteger)buyQuantity adjunctIndex:(NSInteger)adjunctIndex adjunctGoodID:(NSString *)adjunctGoodID adjunctGoodQuantity:(NSInteger)adjunctGoodQuantity goodType:(NSString *)goodsType{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    [paramDict setObject:goodsID forKey:@"goods[goods_id]"];
    
    [paramDict setObject:productID forKey:@"goods[product_id]"];
    
    [paramDict setObject:@(buyQuantity) forKey:@"goods[num]"];
    
    [paramDict setObject:goodsType forKey:@"obj_type"];
    
    if (![NSString isEmpty:buyType]) {
        
        [paramDict setObject:buyType forKey:@"btype"];
    }
    
    if (![NSString isEmpty:adjunctGoodID]) {
        
        [paramDict setObject:@(adjunctGoodQuantity) forKey:[NSString stringWithFormat:@"adjunct[%@][%@]",@(adjunctIndex),adjunctGoodID]];
    }
    
    [paramDict setObject:@"b2c.cart.add" forKey:WMHttpMethod];
    
    return paramDict;
}

/**加入购物车/立即购买 结果
 */
+ (BOOL)returnAddShopCarResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**购物车首页 参数
 */
+ (NSDictionary *)returnShopCarPageParam{
    
    return @{WMHttpMethod:@"b2c.cart.index"};
}
/**购物车首页 结果
 */
+ (id)returnShopCarPageResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
        
    NSString *code = [dict sea_stringForKey:@"code"];
    
    if ([code isEqualToString:@"cart_empty"]) {
        
        return @(YES);
    }
    else if ([code isEqualToString:WMHttpSuccess]){
        
        return [WMShopCarInfo returnShopCarInfoWithDict:[dict dictionaryForKey:WMHttpData]];
    }
    else{
        
        return nil;
    }
}

/**获得凑单商品 参数
 *@param 价格区间 tab_name
 */
+ (NSDictionary *)returnForOrderGoodWithPriceFilter:(NSString *)tabName{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.fororder" forKey:WMHttpMethod];
    
    if (![NSString isEmpty:tabName]) {
        
        [param setObject:tabName forKey:@"tab_name"];
    }
    
    return param;
}
/**返回凑单商品 结果
 *@return key为fororder_tab时返回凑单商品的价格区间 key为list时返回凑单商品数组
 */
+ (NSDictionary *)returnForOrderGoodResutlWithData:(NSData *)data{
    
    NSDictionary *dataDict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *codeString = [dataDict sea_stringForKey:@"code"];
    
    if ([codeString isEqualToString:WMHttpSuccess]) {
        
        NSDictionary *dict = [dataDict dictionaryForKey:WMHttpData];
                
        NSArray *tabsArr = [dict arrayForKey:@"fororder_tab"];
        
        NSArray *goodInfosArr = [WMShopCarForOrderGoodInfo returnForOrderGoodInfosArrWithDictsArr:[dict arrayForKey:@"list"]];
        
        return @{@"fororder_tab":tabsArr,@"list":goodInfosArr};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dataDict alertErrorMsg:NO];
    }
    
    return nil;
}

/**修改购物车数量 参数
 *@param 商品类型 objType
 *@param 商品对象ID goodIdent
 *@param 商品ID goodID
 *@param 修改数量 goodQuantity
 *@param 修改配件数量 adjunctGoodQuantity
 *@param 配件所在的组别 groupID
 *@param 配件货品ID adjunctGoodProductID
 *@param 已选中的商品对象ID数组 objIdentsArr
 */
+ (NSDictionary *)returnModifyShopCarQuantityWithGoodType:(NSString *)goodType goodIdent:(NSString *)goodIdent goodID:(NSString *)goodID modifyGoodQuantity:(NSInteger)goodQuantity modifyAdjunctGoodQuantity:(NSInteger)adjunctGoodQuantity adjunctGroupID:(NSString *)groupID adjunctGoodProductID:(NSString *)adjunctGoodProductID selectObjIdentsArr:(NSArray *)objIdentsArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.update" forKey:WMHttpMethod];
    
    [param setObject:goodType forKey:@"obj_type"];
    
    if (![NSString isEmpty:goodID]) {
        
        [param setObject:goodID forKey:@"goods_id"];
    }
    
    if ([NSString isEmpty:adjunctGoodProductID]) {
        
        [param setObject:goodIdent forKey:@"goods_ident"];
        
        if ([goodType isEqualToString:@"goods"]) {
            
            [param setObject:@(goodQuantity) forKey:[NSString stringWithFormat:@"modify_quantity[%@][quantity]",goodIdent]];
        }
        else{
            
            [param setObject:@(goodQuantity) forKey:[NSString stringWithFormat:@"modify_quantity[%@]",goodIdent]];
        }
    }
    else{
        
//        [param setObject:[NSString stringWithFormat:@"goods_%@_%@",goodID,adjunctGoodProductID] forKey:@"goods_ident"];
        
        [param setObject:@(adjunctGoodQuantity) forKey:[NSString stringWithFormat:@"modify_quantity[%@][adjunct][%@][%@][quantity]",goodIdent,groupID,adjunctGoodProductID]];
    }
    
//    for (NSString *selectGoodIdent in objIdentsArr) {
//        
//        NSInteger i = [objIdentsArr indexOfObject:selectGoodIdent];
//        
//        [param setObject:selectGoodIdent forKey:[NSString stringWithFormat:@"obj_ident[%ld]",(long)i]];
//    }
    
    return param;
}
/**修改购物车数量 结果
 */
+ (BOOL)returnModifyShopCarQuantityResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**删除购物车商品 参数
 *@param 商品类型 objType--传all时表示删除所有商品
 *@param 商品对象ID goodIdent
 *@param 商品ID goodID
 *@param 修改数量 goodQuantity
 *@param 修改配件数量 adjunctGoodQuantity
 *@param 配件所在的组别 groupID
 *@param 配件货品ID adjunctGoodProductID
 *@param 已选中的商品对象ID数组 objIdentsArr
 */
+ (NSDictionary *)returnDeleteShopCarGoodWithGoodType:(NSString *)goodType goodIdent:(NSString *)goodIdent goodID:(NSString *)goodID modifyGoodQuantity:(NSInteger)goodQuantity modifyAdjunctGoodQuantity:(NSInteger)adjunctGoodQuantity adjunctGroupID:(NSString *)groupID adjunctGoodProductID:(NSString *)adjunctGoodProductID selectObjIdentsArr:(NSArray *)objIdentsArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.remove" forKey:WMHttpMethod];
    
    if ([goodType isEqualToString:@"all"]) {
        
        [param setObject:@"all" forKey:@"obj_type"];
        
        return param;
    }
    
    if ([NSString isEmpty:adjunctGoodProductID]) {
        
        [param setObject:goodType forKey:@"obj_type"];
        
        [param setObject:goodID forKey:@"goods_id"];
        
        [param setObject:goodIdent forKey:@"goods_ident"];
        
        [param setObject:@(goodQuantity) forKey:[NSString stringWithFormat:@"modify_quantity[%@][quantity]",goodIdent]];
    }
    else{
        
        [param setObject:@(adjunctGoodQuantity) forKey:[NSString stringWithFormat:@"modify_quantity[%@][adjunct][%@][%@][quantity]",goodIdent,groupID,adjunctGoodProductID]];
    }
    
    for (NSString *selectGoodIdent in objIdentsArr) {
        
        NSInteger i = [objIdentsArr indexOfObject:selectGoodIdent];
        
        [param setObject:selectGoodIdent forKey:[NSString stringWithFormat:@"obj_ident[%ld]",(long)i]];
    }
    
    return param;
    
}
/**删除购物车多件商品 参数
 *@param 购物车商品数组 WMShopCarGoodGroupInfo
 */
+ (NSDictionary *)returnBatchDeleteShopCarGoodWithInfosArr:(NSArray *)infosArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.remove" forKey:WMHttpMethod];

    for (WMShopCarGoodGroupInfo *groupInfo in infosArr) {
        
        switch (groupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                for (WMShopCarExchangeGoodInfo *exchangeGoodInfo in groupInfo.goodInfosArr) {
                    
                    if (exchangeGoodInfo.isEditSelect) {
                        
//                        [param setObject:@"gift" forKey:@"obj_type"];
                        
//                        [param setObject:exchangeGoodInfo.goodID forKey:@"goods_id"];
                        
//                        [param setObject:[NSString stringWithFormat:@"gift_%@_%@",exchangeGoodInfo.goodID,exchangeGoodInfo.productID] forKey:@"goods_ident"];
                        
                        [param setObject:exchangeGoodInfo.quantity forKey:[NSString stringWithFormat:@"modify_quantity[%@][quantity]",[NSString stringWithFormat:@"gift_%@_%@",exchangeGoodInfo.goodID,exchangeGoodInfo.productID]]];
                    }
                }
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *normalGoodInfo = [groupInfo.goodInfosArr firstObject];

                if (normalGoodInfo.isEditSelect) {
                    
//                    [param setObject:@"goods" forKey:@"obj_type"];
                    
//                    [param setObject:normalGoodInfo.goodID forKey:@"goods_id"];
                    
//                    [param setObject:[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID] forKey:@"goods_ident"];
                    
                    [param setObject:normalGoodInfo.quantity forKey:[NSString stringWithFormat:@"modify_quantity[%@][quantity]",[NSString stringWithFormat:@"goods_%@_%@",normalGoodInfo.goodID,normalGoodInfo.productID]]];
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
    
    return param;
}

/**删除购物车数量 结果
 */
+ (BOOL)returnDeleteShopCarGoodWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**选中购物车的商品 参数
 *@param 购物车中选中的所有商品数组，元素是NSString，例--goods_1211_4321
 */
+ (NSDictionary *)returnSelectShopCarGoodParamWithGoodIdentsArr:(NSArray *)goodIdentsArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.select_cart_item" forKey:WMHttpMethod];
    
    for (NSInteger i = 0; i < goodIdentsArr.count; i++) {
        
        [param setObject:[goodIdentsArr objectAtIndex:i] forKey:[NSString stringWithFormat:@"obj_ident[%ld]",(long)i]];
    }
    
    return param;
}
/**选中购物车的商品结果
 */
+ (BOOL)returnSelectShopCarGoodResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**设置更新购物车数量
 *@param 购物车数量 quantity
 */
+ (void)updateShopCarNumberQuantity:(NSInteger)quantity needChange:(BOOL)needChange{
    
    WMUserInfo *info = [WMUserInfo sharedUserInfo];
    
    info.shopcartCount = needChange ? quantity : info.shopcartCount;
    
    [info saveUserInfoToUserDefaults];
    
    NSInteger badgeNum = [[WMUserInfo displayShopcarCount] integerValue];
    
    UIViewController *vc = [[AppDelegate tabBarController].viewControllers objectAtIndex:3];
    
    if([vc isKindOfClass:[UINavigationController class]])
    {
        vc = [[(UINavigationController*)vc viewControllers] firstObject];
    }
    
    if (badgeNum == 0) {
        
        vc.tabBarItem.badgeValue = nil;
    }
    else if (badgeNum < 99){
        
        vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)badgeNum];
    }
    else{
        
        vc.tabBarItem.badgeValue = @"99+";
    }
}

@end
