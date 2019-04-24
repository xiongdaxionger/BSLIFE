//
//  WMConfirmOrderInfo.m
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMConfirmOrderInfo.h"
#import "WMAddressInfo.h"
#import "WMTaxSettingInfo.h"
#import "WMShippingMethodInfo.h"
#import "WMPayMethodModel.h"
#import "WMShopCarInfo.h"
#import "WMConfirmOrderOperation.h"
#import "WMShippingTimeInfo.h"
#import "WMCouponsInfo.h"

#import "ConfirmOrderNoAddrViewCell.h"
#import "ConfirmOrderAddeViewCell.h"
#import "ConfirmOrderMoneyInfoViewCell.h"

@implementation WMConfirmOrderInfo
/**初始化
 */
+ (instancetype)returnConfirmInfoWithDict:(NSDictionary *)dict{
    
    WMConfirmOrderInfo *confirmOrderInfo = [WMConfirmOrderInfo new];
    
    NSArray *couponsArr = [[[dict dictionaryForKey:@"aCart"] dictionaryForKey:@"object"] arrayForKey:@"coupon"];
    
    if (couponsArr.count) {
        
        confirmOrderInfo.orderSelectCouponInfo = [WMCouponsInfo returnCouponsInfoWithDict:[couponsArr firstObject]];
    }
    else{
        
        confirmOrderInfo.orderSelectCouponInfo = nil;
    }
    
    confirmOrderInfo.orderGoodInfo = [WMShopCarInfo returnShopCarInfoWithDict:dict];
    
    confirmOrderInfo.orderMD5Code = [dict sea_stringForKey:@"md5_cart_info"];
    
    confirmOrderInfo.isStoreAuto = [[dict numberForKey:@"is_sotre_auto"] boolValue];
    
    confirmOrderInfo.userAddrInfo = [dict dictionaryForKey:@"def_addr"] == nil ? nil : [WMAddressInfo returnAddressInfoWithDict:[dict dictionaryForKey:@"def_addr"]];
    
    NSDictionary *shippingTime = [dict dictionaryForKey:@"shipping_time"];
    
    if (shippingTime) {
        
        confirmOrderInfo.canShippingTime = YES;
        
        confirmOrderInfo.shippingTimeInfosArr = [WMShippingTimeInfo returnShippingTimeInfosArrWithDict:shippingTime];
        
        WMShippingTimeInfo *timeInfo = [confirmOrderInfo.shippingTimeInfosArr firstObject];
        
        NSDictionary *timeDict = [timeInfo.shippingTimeZones firstObject];
        
        confirmOrderInfo.methodTime = [NSString stringWithFormat:@"%@%@",timeInfo.shippingTimeName,[timeDict sea_stringForKey:@"name"]];
        
        confirmOrderInfo.timeDict = @{@"timeValue":timeInfo.shippingTimeValue,@"timeZone":[timeDict sea_stringForKey:@"value"]};
    }
    else{
        
        confirmOrderInfo.canShippingTime = NO;
    }
    
    NSArray *payMentsArr = [dict arrayForKey:@"payments"] == nil ? nil : [WMPayMethodModel returnPayInfoArrWith:[dict arrayForKey:@"payments"]];
    
    if (payMentsArr) {
        
        WMPayMethodModel *payMethod = [payMentsArr firstObject];
        
        confirmOrderInfo.orderPayModel = payMethod;
    }
    
    confirmOrderInfo.orderShippingMethodsArr = [dict arrayForKey:@"shippings"] == nil ?  nil : [WMShippingMethodInfo returnShippingMethodInfoWithDictsArr:[dict arrayForKey:@"shippings"]];
    
    confirmOrderInfo.noneSelfStoreShipping = nil;
    
    confirmOrderInfo.selfStoreShipping = nil;
        
    confirmOrderInfo.orderCurrentCurrency = [dict sea_stringForKey:@"current_currency"];
    
    confirmOrderInfo.orderTaxSettingInfo = [dict dictionaryForKey:@"tax_setting"] == nil ? nil : [WMTaxSettingInfo returnTaxSettingInfoWithDict:[dict dictionaryForKey:@"tax_setting"]];
    
    confirmOrderInfo.orderIsOpenInvioce = NO;
    
    if (confirmOrderInfo.orderTaxSettingInfo) {
        
        confirmOrderInfo.orderInvioceTypeDict = [confirmOrderInfo.orderTaxSettingInfo.taxTypesArr firstObject];
    }
    
    confirmOrderInfo.orderPointSettingDict = [dict dictionaryForKey:@"point_dis"];
    
    NSDictionary *orderDetailPriceDict = [dict dictionaryForKey:@"order_detail"];
    
    confirmOrderInfo.orderGoodTotal = [orderDetailPriceDict sea_stringForKey:@"cost_item"];
    
    confirmOrderInfo.orderPriceDictsArr = [NSMutableArray new];
    
    [confirmOrderInfo updatePriceInfoWithPriceDict:orderDetailPriceDict];
    
    confirmOrderInfo.orderPriceAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:NO priceDictsArr:confirmOrderInfo.orderPriceDictsArr];
    
    confirmOrderInfo.orderTitleAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:YES priceDictsArr:confirmOrderInfo.orderPriceDictsArr];
    
    confirmOrderInfo.orderGoodsIdentArr = [dict arrayForKey:@"obj_ident"];
    
    confirmOrderInfo.isPrepareOrder = ![NSString isEmpty:[dict sea_stringForKey:@"promotion_type"]];
    
    if (confirmOrderInfo.isPrepareOrder) {
        
        confirmOrderInfo.orderTotal = [[dict dictionaryForKey:@"prepare"] sea_stringForKey:@"preparesell_price"];
    }
    else{
        
        confirmOrderInfo.orderTotal = [orderDetailPriceDict sea_stringForKey:@"total_amount"];
    }
        
    return confirmOrderInfo;
}

- (void)returnPriceDictWithTitle:(NSString *)title price:(NSString *)price type:(OrderPriceType)type{
    
    [self.orderPriceDictsArr addObject:@{@(type):@{@"title":title,@"price":[NSString isEmpty:price] ? @"0.0" : price}}];
}

- (void)updatePriceInfoWithPriceDict:(NSDictionary *)orderDetailPriceDict{
    
    [self.orderPriceDictsArr removeAllObjects];
    
    [self returnPriceDictWithTitle:@"商品金额" price:[orderDetailPriceDict sea_stringForKey:@"price_total"] type:OrderPriceTypeInitTotal];
    
    [self returnPriceDictWithTitle:@"商品促销后总金额" price:nil type:OrderPriceTypeGoodTotal];
    
    [self returnPriceDictWithTitle:@"商品优惠" price:[orderDetailPriceDict sea_stringForKey:@"discount_amount_prefilter"] type:OrderPriceTypeGoodPromotion];
    
    [self returnPriceDictWithTitle:@"订单优惠" price:[orderDetailPriceDict sea_stringForKey:@"pmt_order"] type:OrderPriceTypePromotion];
    
    [self returnPriceDictWithTitle:@"积分抵扣金额" price:[orderDetailPriceDict sea_stringForKey:@"point_dis_price"] type:OrderPriceTypePointDiscount];
    
    [self returnPriceDictWithTitle:@"运费" price:[orderDetailPriceDict sea_stringForKey:@"cost_freight"] type:OrderPriceTypeFreight];
    
    [self returnPriceDictWithTitle:@"物流保价费" price:[orderDetailPriceDict sea_stringForKey:@"cost_protect"] type:OrderPriceTypeExpressProtect];
    
    [self returnPriceDictWithTitle:@"手续费" price:[orderDetailPriceDict sea_stringForKey:@"cost_payment"] type:OrderPriceTypeCustomerPayment];
    
    [self returnPriceDictWithTitle:@"发票税金" price:[orderDetailPriceDict sea_stringForKey:@"cost_tax"] type:OrderPriceTypeTax];

    [self returnPriceDictWithTitle:@"订单总金额" price:[orderDetailPriceDict sea_stringForKey:@"total_amount"] type:OrderPriceTypeOrderTotal];
    
    [self returnPriceDictWithTitle:@"订单消费积分" price:[orderDetailPriceDict sea_stringForKey:@"totalConsumeScore"] type:OrderPriceTypeConsumeScore];
    
    [self returnPriceDictWithTitle:@"订单获得积分" price:[orderDetailPriceDict sea_stringForKey:@"totalGainScore"] type:OrderPriceTypeGainScore];
    
    [self returnPriceDictWithTitle:@"预售商品订金" price:[orderDetailPriceDict sea_stringForKey:@"prepare_total_amount"] type:OrderPriceTypePrepare];
}

- (WMAddressInfo *)orderDefaultAddr{
    
    return self.needSelectMember ? self.customerAddrInfo : self.userAddrInfo;
}

- (void)setOrderDefaultAddr:(WMAddressInfo *)orderDefaultAddr{

    if (self.needSelectMember) {
        
        self.customerAddrInfo = orderDefaultAddr;
    }
    else{
        
        self.userAddrInfo = orderDefaultAddr;
    }
}

- (WMShippingMethodInfo *)orderDefaultShipping {
    
    return self.needStoreAuto ? self.selfStoreShipping : self.noneSelfStoreShipping;
}

- (void)setOrderDefaultShipping:(WMShippingMethodInfo *)orderDefaultShipping {
    
    if (self.needStoreAuto) {
        
        self.selfStoreShipping = orderDefaultShipping;
    }
    else {
        
        self.noneSelfStoreShipping = orderDefaultShipping;
    }
}
/**地址文本高度
 */
- (CGFloat)returnAddrHeight{
        
    if (self.orderDefaultAddr) {
        
        CGFloat width = _width_ - kConfirmOrderAddrExtraWidth;
        
        CGSize addrSize = [self.orderDefaultAddr.addressDetail stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:width];
        
        return addrSize.height + kConfirmOrderAddrExtraHeight;
    }
    else{
        return kConfirmOrderNoAddrViewCellHeight;
    }
}

/**返回价格信息高度
 */
- (CGFloat)returnPriceInfoHeight{
    
    return [self.orderPriceAttrString boundsWithConstraintWidth:((_width_ - kConfirmOrderMoneyPayInfoExtraWidth) / 2.0)].height + kConfirmOrderMoneyPayInfoExtraWidth;
}

/**更新价格
 */
- (void)changeOrderPriceWithDict:(NSDictionary *)priceDict{
    
    self.orderGoodTotal = [priceDict sea_stringForKey:@"cost_item"];
    
    if (self.isPrepareOrder) {
        
        self.orderTotal = [priceDict sea_stringForKey:@"prepare_total_amount"];
    }
    else{
        
        self.orderTotal = [priceDict sea_stringForKey:@"total_amount"];
    }
    
    [self updatePriceInfoWithPriceDict:priceDict];
    
    self.orderPriceAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:NO priceDictsArr:self.orderPriceDictsArr];
    
    self.orderTitleAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:YES priceDictsArr:self.orderPriceDictsArr];
}

/**更新单个价格
 */
- (void)changeSinglePriceWithIndex:(OrderPriceType)type newPrice:(NSString *)price{
    
    NSDictionary *typeDict = [self.orderPriceDictsArr objectAtIndex:type];
    
    NSDictionary *contentDict = [typeDict dictionaryForKey:@(type)];
    
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:contentDict];
    
    [newDict setObject:price forKey:@"price"];
    
    [self.orderPriceDictsArr replaceObjectAtIndex:type withObject:newDict];
    
    self.orderPriceAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:NO priceDictsArr:self.orderPriceDictsArr];
    
    self.orderTitleAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:YES priceDictsArr:self.orderPriceDictsArr];
}





@end
