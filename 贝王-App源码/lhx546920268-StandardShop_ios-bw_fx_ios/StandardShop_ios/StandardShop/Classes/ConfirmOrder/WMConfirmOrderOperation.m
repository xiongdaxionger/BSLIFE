//
//  WMConfirmOrderOperation.m
//  WanShoes
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMConfirmOrderOperation.h"

#import "WMPayMethodModel.h"
#import "WMShippingMethodInfo.h"
#import "WMShopCarGoodInfo.h"
#import "WMShopCarInfo.h"
#import "WMCouponsInfo.h"
#import "WMConfirmOrderInfo.h"
#import "WMAddressInfo.h"
#import "WMPayMessageInfo.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"
#import "WMStoreListInfo.h"

#import "WMConfirmOrderCustomerTableViewCell.h"
#import "WMStoreNoneSelectViewCell.h"
#import "WMStoreSelectedViewCell.h"
#import "WMSelfStoreInputViewCell.h"
#import "WMSelectMemberViewCell.h"
#import "ConfirmOrderAddeViewCell.h"
#import "ConfirmOrderNoAddrViewCell.h"
#import "ConfirmOrderGoodViewCell.h"
#import "WMShopCarGoodPromotionViewCell.h"
#import "ConfirmOrderMoneyInfoViewCell.h"
#import "WMOrderRemarkViewCell.h"
#import "ConfirmOrderCommonHeaderViewCell.h"
#import "XTableCellConfigEx.h"

@implementation WMConfirmOrderOperation

#pragma mark - new
/**返回确认订单的配置数组
 */
+ (NSArray *)returnConfigureArrForOrderDetailWithTable:(UITableView *)tableView{
    
    NSMutableArray *configsArr = [NSMutableArray new];
    
    XTableCellConfigEx *needCustomerConfig = [XTableCellConfigEx cellConfigWithClassName:[WMConfirmOrderCustomerTableViewCell class] heightOfCell:WMConfirmOrderCustomerTableViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[needCustomerConfig]];
    
    XTableCellConfigEx *selectMemberConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSelectMemberViewCell class] heightOfCell:WMSelectMemberViewCellHegiht + 10.0 tableView:tableView isNib:YES];
    
    XTableCellConfigEx *addrConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderAddeViewCell class] heightOfCell:kConfirmOrderAddrViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *noAddrConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderNoAddrViewCell class] heightOfCell:kConfirmOrderNoAddrViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *noStoreConfig = [XTableCellConfigEx cellConfigWithClassName:[WMStoreNoneSelectViewCell class] heightOfCell:WMStoreNoneSelectViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *storeSelectConfig = [XTableCellConfigEx cellConfigWithClassName:[WMStoreSelectedViewCell class] heightOfCell:1.0 tableView:tableView isNib:YES];
    
    XTableCellConfigEx *storeInputConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSelfStoreInputViewCell class] heightOfCell:WMSelfStoreInputViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[selectMemberConfig,addrConfig,noAddrConfig,noStoreConfig,storeSelectConfig,storeInputConfig]];
    
    XTableCellConfigEx *goodConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderGoodViewCell class] heightOfCell:kConfirmOrderGoodViewCellHeight tableView:tableView isNib:YES];
    
    XTableCellConfigEx *goodPromotionConfig = [XTableCellConfigEx cellConfigWithClassName:[WMShopCarGoodPromotionViewCell class] heightOfCell:WMShopCarGoodPromotionViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[goodConfig,goodPromotionConfig]];
    
    XTableCellConfigEx *commonHeaderConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderCommonHeaderViewCell class] heightOfCell:ConfirmOrderCommonHeaderViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[commonHeaderConfig]]; //配送方式
    
    XTableCellConfigEx *orderRemarkConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderRemarkViewCell class] heightOfCell:WMOrderRemarkViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[orderRemarkConfig]];
    
    XTableCellConfigEx *orderMinusConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderMinusMoneyViewCell class] heightOfCell:kConfirmOrderMinusMoneyViewCellHeight tableView:tableView isNib:YES];
        
    [configsArr addObject:@[commonHeaderConfig]]; //发票信息
    
    [configsArr addObject:@[commonHeaderConfig]]; //优惠券
    
    [configsArr addObject:@[orderMinusConfig]]; //积分抵扣

    XTableCellConfigEx *orderMoneyInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderMoneyInfoViewCell class] heightOfCell:kConfirmOrderMoneyPayInfoViewCellHeight tableView:tableView isNib:YES];
    
    [configsArr addObject:@[orderMoneyInfoConfig]];
    
    return configsArr;
}

/**订单确认 参数
 *@param 是否立即购买-isFastBuy NSString/(true立即购买、false普通结算)
 *@param 选中的商品数组 NSArray，元素是商品的表示ID(goods_1216_3806)
 */
+ (NSDictionary *)returnConfirmOrderParamWithIsFastBuy:(NSString *)isFastBuy selectGoodsArr:(NSArray *)goodIdentsArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.checkout" forKey:WMHttpMethod];
    
    if (![NSString isEmpty:isFastBuy]) {
        
        [param setObject:isFastBuy forKey:@"isfastbuy"];
    }
    
    for (NSString *objeIdent in goodIdentsArr) {
        
        NSInteger i = [goodIdentsArr indexOfObject:objeIdent];
        
        [param setObject:objeIdent forKey:[NSString stringWithFormat:@"obj_ident[%ld]",(long)i]];
    }
    
    return param;
}
/**订单确认 结果
 */
+ (WMConfirmOrderInfo *)returnConfirmOrderResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *codeString = [dict sea_stringForKey:@"code"];
    
    if ([codeString isEqualToString:WMHttpSuccess]) {
        
        WMConfirmOrderInfo *info = [WMConfirmOrderInfo returnConfirmInfoWithDict:[dict dictionaryForKey:WMHttpData]];
        
        return info;
    }
    else if ([codeString isEqualToString:@"cart_empty"]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[dict sea_stringForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**返回确认订单各组数目
 */
+ (NSInteger)returnConfirmOrderRowsOfSection:(NSInteger)section confirmOrderInfo:(WMConfirmOrderInfo *)orderInfo{
    
    if (section == ConfirmOrderSectionCustomer) {
        
        return orderInfo.isPrepareOrder || ![[WMUserInfo sharedUserInfo] enableUseFenXiao] ? 0 : 1;
    }
    else if (section == ConfirmOrderSectionAddress){
    
        if (orderInfo.needSelectMember) {
            
            return orderInfo.needStoreAuto ? 3 : 2;
        }
        else {
            
            return orderInfo.needStoreAuto ? 2 : 1;
        }
    }
    else if (section >= ConfirmOrderSectionGood && section <= orderInfo.orderGoodInfo.shopCarGoodsArr.count + 1) {
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [orderInfo.orderGoodInfo.shopCarGoodsArr objectAtIndex:section - 2];
        
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
    else{
        
        NSInteger newSection = section - orderInfo.orderGoodInfo.shopCarGoodsArr.count + 1;
        
        switch (newSection) {
            case ConfirmOrderSectionShippingMethod:
            {
                return orderInfo.canShippingTime ? 2 : 1;
            }
                break;
            case ConfirmOrderSectionRemark:
            case ConfirmOrderSectionPrice:
            {
                return 1;
            }
                break;
            case ConfirmOrderSectionCoupon:
            {
                if (orderInfo.isPointOrder) {
                    
                    return 0;
                }
                return orderInfo.isPrepareOrder ? 0 : 1;
            }
                break;
            case ConfirmOrderSectionInvioce:
            {
                return orderInfo.orderTaxSettingInfo == nil ? 0 : 1;
            }
                break;
            case ConfirmOrderSectionPoint:
            {
                if (orderInfo.orderPointSettingDict) {
                    
                    NSInteger canUseCount = [[orderInfo.orderPointSettingDict sea_stringForKey:@"max_discount_value_point"] integerValue];
                    
                    return canUseCount == 0 ? 0 : 1;
                }
                else{
                    
                    return 0;
                }
            }
                break;
            default:
            {
                return CGFLOAT_MIN;
            }
                break;
        }
    }
}

/**返回配置类
 */
+ (XTableCellConfigEx *)returnCellConfigWithIndexPath:(NSIndexPath*)indexPath confirmOrderInfo:(WMConfirmOrderInfo *)info cellConfigArr:(NSArray *)cellArr{
    
    NSArray *configsArr;
    
    if (indexPath.section == ConfirmOrderSectionAddress) {
        
        configsArr = [cellArr objectAtIndex:indexPath.section];
        
        //    [configsArr addObject:@[selectMemberConfig,addrConfig,noAddrConfig,noStoreConfig,storeSelectConfig,storeInputConfig]];
        
        if (info.needSelectMember) {
            
            if (info.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    return [configsArr firstObject];
                }
                else if (indexPath.row == 1) {
                    
                    return info.selectStoreInfo == nil ? [configsArr objectAtIndex:3] : [configsArr objectAtIndex:4];
                }
                else {
                    
                    return [configsArr lastObject];
                }
            }
            else {
                
                if (indexPath.row == 0) {
                    
                    return [configsArr firstObject];
                }
                else{
                    
                    return info.orderDefaultAddr == nil ? [configsArr objectAtIndex:2] : [configsArr objectAtIndex:1];
                }
            }
        }
        else{
            
            if (info.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    return info.selectStoreInfo == nil ? [configsArr objectAtIndex:3] : [configsArr objectAtIndex:4];
                }
                else {
                    
                    return [configsArr lastObject];
                }
            }
            else {
                
                return info.orderDefaultAddr == nil ? [configsArr lastObject] : [configsArr objectAtIndex:1];
            }
        }
    }
    else if (indexPath.section == ConfirmOrderSectionCustomer){
    
        configsArr = [cellArr objectAtIndex:indexPath.section];
        
        return [configsArr firstObject];
    }
    else if (indexPath.section >= ConfirmOrderSectionGood && indexPath.section <= info.orderGoodInfo.shopCarGoodsArr.count + 1) {
        
        configsArr = [cellArr objectAtIndex:ConfirmOrderSectionGood];
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [info.orderGoodInfo.shopCarGoodsArr objectAtIndex:indexPath.section - 2];
        
        switch (goodGroupInfo.type) {
            case ShopCarGoodGroupTypeOrderGiftGroup:
            case ShopCarGoodGroupTypeExchangeGroup:
            {
                return [configsArr firstObject];
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr firstObject];
                
                if (indexPath.row == goodInfo.goodGiftAdjunctsArr.count + 1) {
                    
                    return [configsArr objectAtIndex:1];
                }
                else{
                    
                    return [configsArr firstObject];
                }
            }
                break;
            default:
                return nil;
                break;
        }
    }
    else{
        
        NSInteger newSection = indexPath.section - info.orderGoodInfo.shopCarGoodsArr.count + 1;
        
        configsArr = [cellArr objectAtIndex:newSection];
        
        switch (newSection) {
            case ConfirmOrderSectionShippingMethod:
            case ConfirmOrderSectionRemark:
            case ConfirmOrderSectionCoupon:
            case ConfirmOrderSectionInvioce:
            case ConfirmOrderSectionPoint:
            case ConfirmOrderSectionPrice:
            {
                return [configsArr firstObject];
            }
                break;
            default:
            {
                return nil;
            }
                break;
        }
    }
}

/**返回订单的模型
 */
+ (id)returnOrderModelWith:(NSIndexPath *)indexPath confirmOrderInfo:(WMConfirmOrderInfo *)info controller:(ConfirmOrderPageController *)controller{
    
    if (indexPath.section == ConfirmOrderSectionAddress) {
    
        if (info.needSelectMember) {
            
            if (info.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    return info.selectMemberName == nil ? @"请选择下单会员" : info.selectMemberName;
                }
                else if (indexPath.row == 1) {
                    
                    return info.selectStoreInfo == nil ? nil : info.selectStoreInfo;
                }
                else {
                    
                    return info;
                }
            }
            else {
                
                if (indexPath.row == 0) {
                    
                    return info.selectMemberName == nil ? @"请选择下单会员" : info.selectMemberName;
                }
                else{
                    
                    return info.orderDefaultAddr == nil ? @"请选择收货信息" : @{@"info":info.orderDefaultAddr,@"hidden":@(NO)};
                }
            }
        }
        else{
        
            if (info.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    return info.selectStoreInfo == nil ? nil : info.selectStoreInfo;
                }
                else {
                    
                    return info;
                }
            }
            else {
                
                return info.orderDefaultAddr == nil ? @"请选择收货信息" : @{@"info":info.orderDefaultAddr,@"hidden":@(NO)};
            }
        }
    }
    else if (indexPath.section == ConfirmOrderSectionCustomer){
        
        return @"开启代客下单";
    }
    else if (indexPath.section >= ConfirmOrderSectionGood && indexPath.section <= info.orderGoodInfo.shopCarGoodsArr.count + 1){
        
        WMShopCarGoodGroupInfo *goodGroupInfo = [info.orderGoodInfo.shopCarGoodsArr objectAtIndex:indexPath.section - 2];
        
        switch (goodGroupInfo.type) {
            case ShopCarGoodGroupTypeExchangeGroup:
            case ShopCarGoodGroupTypeOrderGiftGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr objectAtIndex:indexPath.row];
                
                return @{@"model":goodInfo,@"type":@(goodInfo.type)};
            }
                break;
            case ShopCarGoodGroupTypeNormalGroup:
            {
                WMShopCarGoodInfo *goodInfo = [goodGroupInfo.goodInfosArr firstObject];
                
                if (indexPath.row == 0) {
                    
                    return @{@"model":goodInfo,@"type":@(goodInfo.type)};
                }
                else if (indexPath.row == goodInfo.goodGiftAdjunctsArr.count + 1) {
                    
                    return goodInfo.goodPromotionAttrString;
                }
                else {
                    
                    id otherGoodInfo = [goodInfo.goodGiftAdjunctsArr objectAtIndex:indexPath.row - 1];
                    
                    if ([otherGoodInfo isKindOfClass:[WMShopCarAdjunctGoodInfo class]]) {
                        
                        return @{@"model":otherGoodInfo,@"type":@(ShopCarGoodTypeAdjunctGood)};
                    }
                    else if ([otherGoodInfo isKindOfClass:[WMShopCarOrderGiftGoodInfo class]]){
                        
                        return @{@"model":otherGoodInfo,@"type":@(ShopCarGoodTypeGiftGood)};
                    }
                    else{
                        
                        return nil;
                    }
                }
            }
                break;
            default:
                return nil;
                break;
        }
    }
    else{
        
         NSInteger newSection = indexPath.section - info.orderGoodInfo.shopCarGoodsArr.count + 1;
        
        switch (newSection) {
            case ConfirmOrderSectionShippingMethod:
            {
                if (indexPath.row) {
                    
                    return @{@"content":[NSString isEmpty:info.methodTime] ? @"请选择配送时间" : info.methodTime,@"isContent":@(YES),@"tittle":@"配送时间"};
                }
                else{
                    
                    return info.orderDefaultShipping == nil ? @{@"content":@"请选择配送方式",@"isContent":@(YES),@"tittle":@"配送方式"} : info.orderDefaultShipping;
                }
            }
                break;
            case ConfirmOrderSectionRemark:
            {
                return controller;
            }
                break;
            case ConfirmOrderSectionCoupon:
            {
                return info.orderSelectCouponInfo == nil ? @{@"content":@"使用",@"isContent":@(YES),@"tittle":@"优惠券"} : info.orderSelectCouponInfo;
            }
                break;
            case ConfirmOrderSectionInvioce:
            {
                NSString *content;
                
                if (info.orderIsOpenInvioce) {
                    
                    content = [NSString stringWithFormat:@"%@ %@ %@",[info.orderInvioceTypeDict sea_stringForKey:@"tax_type"],info.orderInvioceHeader,info.orderInvioceContent];
                }
                else{
                    
                    content = @"不开发票";
                }
                
                return @{@"content":content,@"isContent":@(YES),@"tittle":@"发票信息"};
            }
                break;
            case ConfirmOrderSectionPoint:
            {
                return @{@"model":info,@"controller":controller};
            }
                break;
            case ConfirmOrderSectionPrice:
            {
                return info;
            }
                break;
            default:
            {
                return nil;
            }
                break;
        }
    }
}

/**更新订单总价 参数
 @param viewModel 订单模型
 @param isFastBuy 是否快速购买
 */
+ (NSDictionary*)orderUpdateTotalMoneyParamWithModel:(WMConfirmOrderInfo *)info isFastBuy:(NSString *)isFastBuy{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if (info.orderDefaultAddr) {
        
        [param setObject:info.orderDefaultAddr.addressJsonValue forKey:@"address"];
    }
    
    if (info.orderDefaultShipping) {
        
        [param setObject:info.orderDefaultShipping.methodJsonValue forKey:@"shipping"];
        
        [param setObject:info.orderDefaultShipping.isExpressSelect ? @"1" : @"0" forKey:@"is_protect"];
    }
    
    if (![NSString isEmpty:info.orderCurrentCurrency]) {
        
        [param setObject:info.orderCurrentCurrency forKey:@"payment[currency]"];
    }
    
    if (info.orderPayModel) {
        
        [param setObject:info.orderPayModel.payJsonString forKey:@"payment[pay_app_id]"];
    }
    
    if (info.orderIsOpenInvioce) {
        
        [param setObject:[info.orderInvioceTypeDict sea_stringForKey:@"tax_value"] forKey:@"payment[tax_type]"];
        
        [param setObject:info.orderInvioceHeader forKey:@"payment[tax_company]"];
        
        [param setObject:info.orderInvioceContent forKey:@"payment[tax_content]"];
        
        [param setObject:@"true" forKey:@"payment[is_tax]"];
    }
    else{
        
        [param setObject:@"false" forKey:@"payment[is_tax]"];
    }
    
    if (info.isUsePoint) {
        
        [param setObject:info.orderPointSettingDict == nil ? @"0" : [info.orderPointSettingDict sea_stringForKey:@"max_discount_value_point"]  forKey:@"point[score]"];
    }
    
    if ([isFastBuy isEqualToString:@"true"]) {
        
        [param setObject:isFastBuy forKey:@"isfastbuy"];
    }
    
    [param setObject:@"b2c.cart.total" forKey:WMHttpMethod];
    
    return param;
}
/**获取订单价格 结果
 */
+ (NSDictionary *)returnOrderTotalMoneyWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:@"code"];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return [[dict dictionaryForKey:WMHttpData] dictionaryForKey:@"order_detail"];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**选择配送方式 参数
 *@param shipping 配送方式的JSON值
 */
+ (NSDictionary *)returnSelectShippingMethodWithShippingJsonValue:(NSString *)shippingJson{
    
    return @{WMHttpMethod:@"b2c.cart.delivery_confirm",@"shipping":shippingJson};
}
/**选择配送方式 结果
 */
+ (NSDictionary *)returnSelectShippingMethodResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *codeString = [dict sea_stringForKey:@"code"];
    
    if ([codeString isEqualToString:WMHttpSuccess]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        WMPayMethodModel *defaultPayMethod = [WMPayMethodModel returnModelWith:[dataDict dictionaryForKey:@"payment"]];
        
        return @{@"currency":[dataDict sea_stringForKey:@"current_currency"],@"pay":defaultPayMethod};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**使用积分抵扣 参数
 *@param 订单的积分配置(可用的最大积分数量/积分的比例) pointSettingDict
 */
+ (NSDictionary *)returnUsePointParamWithPointSettingDict:(NSDictionary *)pointSettingDict{
    
    return @{@"point[rate]":[pointSettingDict sea_stringForKey:@"discount_rate"],@"point[score]":[pointSettingDict sea_stringForKey:@"max_discount_value_point"],WMHttpMethod:@"b2c.cart.count_digist"};
}
/**积分使用的结果
 */
+ (BOOL)returnUsePointResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取支付方式 参数
 */
+ (NSDictionary *)getOrderPayInfoWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.paycenter.index",@"order_id":orderID};
}
/**选择支付方式 参数
 *@param 货币类型 currency
 *@param 订单ID orderID
 *@param 支付方式 appID
 */
+ (NSDictionary *)returnSelectPayMethodWithCurrency:(NSString *)currency orderID:(NSString *)orderID payAppID:(NSString *)appID{
    
    return @{WMHttpMethod:@"b2c.order.payment_change",@"payment[currency]":currency,@"order_id":orderID,@"payment[pay_app_id]":appID};
}
/**获取支付方式 结果
 *积分兑换的商品在不需要支付任何费用情况下为已支付,返回YES
 */
+ (id)returnPayMessageInfoWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:@"code"];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return [WMPayMessageInfo returnPayMessageInfoWithDict:[dict dictionaryForKey:WMHttpData]];
    }
    else if ([rspStr isEqualToString:@"is_payed"]){
        
        return @(YES);
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**创建订单 参数
 *@param 创建订单的模型 WMConfirmOrderModel
 *@param 订单备注 memo
 */
+ (NSDictionary *)orderCreateParamWithModel:(WMConfirmOrderInfo *)info fastBuyType:(NSString *)type{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    if ([type isEqualToString:@"true"]) {
        
        [param setObject:type forKey:@"isfastbuy"];
    }
    
    [param setObject:info.needStoreAuto ? @"true" : @"false" forKey:@"is_sotre_auto"];
    
    if (info.needStoreAuto) {
        
        [param setObject:info.selfStoreContactName forKey:@"selfproxy_username"];
        
        [param setObject:info.selfStoreContactMobile forKey:@"selfproxy_mobile"];
        
        [param setObject:info.selectStoreInfo.branchID forKey:@"selfproxy_id"];
        
        [param setObject:info.selectStoreInfo.name forKey:@"selfproxy_name"];
    }
    else {
        
        NSDictionary *jsonDict = @{@"addr_id":info.orderDefaultAddr.addressID,@"area":info.orderDefaultAddr.addressAreaID};
        
        NSString *jsonValue = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
        [param setObject:jsonValue forKey:@"address"];
    }
    
    [param setObject:info.orderDefaultShipping.methodJsonValue forKey:@"shipping"];
    
    [param setObject:info.orderPayModel.payJsonString forKey:@"payment[pay_app_id]"];
    
    [param setObject:info.orderMD5Code forKey:@"md5_cart_info"];
    
    [param setObject:info.orderCurrentCurrency forKey:@"payment[currency]"];
    
    if (![NSString isEmpty:info.orderRemarkInfo]) {
        
        [param setObject:info.orderRemarkInfo forKey:@"memo"];
    }
    
    [param setObject:info.orderDefaultShipping.isExpressSelect ? @"1" : @"0" forKey:@"is_protect"];
    
    if (info.isUsePoint) {
        
        [param setObject:[info.orderPointSettingDict sea_stringForKey:@"max_discount_value_point"] forKey:@"point[score]"];
    }
    
    if (info.orderIsOpenInvioce) {
        
        [param setObject:@"true" forKey:@"payment[is_tax]"];

        [param setObject:[info.orderInvioceTypeDict sea_stringForKey:@"tax_value"] forKey:@"payment[tax_type]"];
        
        [param setObject:info.orderInvioceContent forKey:@"payment[tax_content]"];
        
        [param setObject:info.orderInvioceHeader forKey:@"payment[tax_company]"];
    }
    else{
        
        [param setObject:@"false" forKey:@"payment[is_tax]"];
    }
    
    for (NSInteger i = 0 ; i < info.orderGoodsIdentArr.count; i++) {
        
        NSString *objIdent = [info.orderGoodsIdentArr objectAtIndex:i];
        
        [param setObject:objIdent forKey:[NSString stringWithFormat:@"obj_ident[%ld]",(long)i]];
    }
    
    [param setObject:info.needSelectMember ? info.selectMemberID : [[WMUserInfo sharedUserInfo] userId] forKey:WMUserInfoId];
    
    if (info.canShippingTime) {
        
        NSString *type = [info.timeDict sea_stringForKey:@"timeValue"];
        
        if ([type isEqualToString:@"special"]) {
            
            [param setObject:@"special" forKey:@"shipping_time[day]"];
            
            NSString *time = [info.timeDict sea_stringForKey:@"time"];
            
            NSString *day = [time substringWithRange:NSMakeRange(0, 10)];
            
            NSString *timeZone = [info.timeDict sea_stringForKey:@"timeZone"];
            
            if ([timeZone rangeOfString:@"上午"].location != NSNotFound) {
                
                timeZone = @"08:00-12:00";
            }
            else if ([timeZone rangeOfString:@"下午"].location != NSNotFound){
                
                timeZone = @"12:00-18:00";
            }
            else if([timeZone rangeOfString:@"晚上"].location != NSNotFound){
                
                timeZone = @"18:00-22:00";
            }
            
            [param setObject:[NSString stringWithFormat:@"%@ %@",day,timeZone] forKey:@"shipping_time[special]"];

//            _orderInfo.orderDefaultShipping.methodTime = [NSString stringWithFormat:@"%@%@",[conditions sea_stringForKey:@"time"],[conditions sea_stringForKey:@"timeZone"]];
        }
        else{
            
            [param setObject:[info.timeDict sea_stringForKey:@"timeValue"] forKey:@"shipping_time[day]"];

            [param setObject:[info.timeDict sea_stringForKey:@"timeZone"] forKey:@"shipping_time[time]"];
        }
    }
    
    [param setObject:@"b2c.order.create" forKey:WMHttpMethod];
    
    [param setObject:@"ios" forKey:@"source"];
    
    return param;
}

/**创建订单 结果
 */
+ (NSDictionary *)returnOrderCreateResultWithData:(NSData *)data{
    
    NSDictionary *orderCreateDict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [orderCreateDict sea_stringForKey:@"code"];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return [orderCreateDict dictionaryForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:orderCreateDict alertErrorMsg:YES];
    }
    
    return nil;
}

/**检测支付密码 参数
 *@param passwd 需要验证的支付密码
 */
+ (NSDictionary*)verifyTardePasswdParamWithPasswd:(NSString*) passwd{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.paycenter.pay_password", WMHttpMethod, passwd, @"pay_password", nil];
}

/**检测支付密码 结果
 *@param errMsg 错误信息
 @return 是否验证成功
 */
+ (BOOL)verifyTardePasswdResultFromData:(NSData*)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:@"code"];
    
    if([result isEqualToString:WMHttpSuccess])
    {
        return YES;
    }
    else
    {
        
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**调用支付 参数
 *@param 订单号 orderID
 *@param 订单金额 totalMoney
 *@param 支付方式 payAppID
 *@param 是否开启组合支付 isCombinationPay
 *@param 组合支付的剩余金额 combinationPayMoeny
 *@param 组合支付的支付方式 combinationPayMethod
 *@param 支付密码 payPassWord--预存款需要
 */
+ (NSDictionary *)returnCallDoPaymentParamOrderID:(NSString *)orderID totalMoney:(NSString *)totalMoney payAppID:(NSString *)payAppID isCombinationPay:(BOOL)isCombinationPay combinationPayMoney:(NSString *)combinationPayMoney combinationPayMethod:(NSString *)combinationPayMethod payPassWord:(NSString *)payPassWord{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.paycenter.dopayment" forKey:WMHttpMethod];
    
    [param setObject:orderID forKey:@"order_id"];

    [param setObject:totalMoney forKey:@"cur_money"];

    [param setObject:payAppID forKey:@"pay_app_id"];
    
    if (isCombinationPay) {
        
        [param setObject:@"true" forKey:@"combination_pay"];
        
        [param setObject:combinationPayMoney forKey:@"other_online_cur_money"];
        
        [param setObject:combinationPayMethod forKey:@"other_online_pay_app_id"];
    }
    
    if ([payAppID isEqualToString:WMDepositID]) {
        
        [param setObject:payPassWord forKey:@"pay_password"];
    }
    
    return param;
}
/**调用支付 结果
 */
+ (NSDictionary *)returnCallDoPaymentResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [dict dictionaryForKey:WMHttpData];
    }
    else{
        
        return dict;
    }
    
    return nil;
}

/**检测订单的支付状态 参数
 *@param 订单号 orderID
 */
+ (NSDictionary *)returnCheckOrderPayStatusWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.paycenter.check_payments",@"order_id":orderID};
}
/**检测订单的支付状态 结果
 */
+ (BOOL)returnCheckOrderPayStatusWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**组合支付更改支付方式 参数
 *@param 更改的支付方式ID payAppID
 *@param 组合支付的剩余金额 currencyMoney
 *@param 组合支付的已支付金额 depositMoeny
 */
+ (NSDictionary *)returnCombinationPayChangePayMethodParamWithPayAppID:(NSString *)payAppID currencyMoney:(NSString *)currencyMoney depositMoney:(NSString *)depositMoney{
    
    return @{WMHttpMethod:@"b2c.paycenter.get_payment_money",@"payment[pay_app_id]":payAppID,@"payment[cur_money]":currencyMoney,@"payment[deposit_pay_money]":depositMoney};
}
/**组合支付更改支付 结果
 */
+ (NSDictionary *)returnCombinationPayResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [dict dictionaryForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**价格富文本
 */
+ (NSAttributedString *)returnPriceAttributedStringIsTitle:(BOOL)isTitle priceDictsArr:(NSArray *)priceDictsArr{
    
    NSMutableString *contentString = [NSMutableString new];
    
    NSInteger allShowPriceCount = 0;
    
    NSInteger count = 0;
    
    NSString *money;
    
    for (NSInteger i = 0; i < priceDictsArr.count; i++) {
        
        NSDictionary *typeDict = [priceDictsArr objectAtIndex:i];
        
        NSDictionary *contentDict = [typeDict dictionaryForKey:@(i)];
        
        if (i == OrderPriceTypeInitTotal) {
            
            money = [[contentDict sea_stringForKey:@"price"] substringToIndex:1];
        }
        
        NSString *price = [contentDict sea_stringForKey:@"price"];
        
        if ([price rangeOfString:money].location != NSNotFound) {
            
            price = [price substringWithRange:NSMakeRange(1, price.length - 1)];
        }
        
        if (i == OrderPriceTypePromotion || i == OrderPriceTypePointDiscount || i == OrderPriceTypeGoodPromotion) {
            
            if ([price rangeOfString:money].location != NSNotFound) {
                
                allShowPriceCount ++;
                
                continue;
            }
        }
        else{
            
            if (price.doubleValue != 0.0) {
                
                allShowPriceCount ++;
                
                continue;
            }
        }
    }
    
    for (NSInteger i = 0; i < priceDictsArr.count; i++) {
        
        NSDictionary *typeDict = [priceDictsArr objectAtIndex:i];
        
        NSDictionary *contentDict = [typeDict dictionaryForKey:@(i)];
        
        NSString *price = [contentDict sea_stringForKey:@"price"];
        
        if ([price rangeOfString:money].location != NSNotFound) {
            
            price = [price substringWithRange:NSMakeRange(1, price.length - 1)];
        }
        
        if (i == OrderPriceTypePromotion || i == OrderPriceTypePointDiscount || i == OrderPriceTypeGoodPromotion) {
            
            if ([price rangeOfString:money].location != NSNotFound) {
                
                count ++;
            }
            else{
                
                continue;
            }
        }
        else{
        
            if (price.doubleValue != 0.0) {
                
                count ++;
            }
            else{
                
                continue;
            }
        }
    
        price = [contentDict sea_stringForKey:@"price"];
        
        if (count == allShowPriceCount) {
            
            [contentString appendString:[NSString stringWithFormat:@"%@",isTitle ? [contentDict sea_stringForKey:@"title"] : price]];
        }
        else{
            
            [contentString appendString:[NSString stringWithFormat:@"%@\n",isTitle ? [contentDict sea_stringForKey:@"title"] : price]];
        }
    }
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragarphStyle.alignment = isTitle ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    [paragarphStyle setLineSpacing:12];
    
    if ([contentString stringSizeWithFont:font contraintWith:(_width_ - 24.0) / 2.0].height > font.lineHeight) {
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [contentString length])];
    }
    
    [attrString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:isTitle ? [UIColor blackColor] : WMPriceColor} range:NSMakeRange(0, [contentString length])];
    
    return attrString;

}







@end
