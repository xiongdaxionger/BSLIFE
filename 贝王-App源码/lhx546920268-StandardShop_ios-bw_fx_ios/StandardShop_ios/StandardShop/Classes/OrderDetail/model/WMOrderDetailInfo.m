//
//  WMOrdertailInfo.m
//  StandardShop
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderDetailInfo.h"
#import "WMAddressInfo.h"
#import "WMConfirmOrderInfo.h"
#import "WMConfirmOrderOperation.h"
#import "WMOrderDetailOpeartion.h"
#import "WMMyOrderOperation.h"
#import "WMPriceOperation.h"

#import "ConfirmOrderMoneyInfoViewCell.h"
#import "ConfirmOrderAddeViewCell.h"
@implementation WMOrderDetailGoodInfo

/**批量初始化
 */
+ (NSArray *)returnOrderDetailGoodInfosArrWithDictsArr:(NSArray *)dictsArr type:(OrderGoodType)type{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMOrderDetailGoodInfo returnOrderDetailGoodInfoWithDict:dict type:type]];
    }
    
    return infosArr;
}
/**初始化
 */
+ (instancetype)returnOrderDetailGoodInfoWithDict:(NSDictionary *)dict type:(OrderGoodType)type{
    
    WMOrderDetailGoodInfo *info = [WMOrderDetailGoodInfo new];
    
    info.name = [dict sea_stringForKey:@"name"];
    
    info.formatGoodName = [WMMyOrderOperation returnGoodAttrNameWithType:type goodName:info.name];
    
    info.quantity = [dict sea_stringForKey:@"quantity"];
    
    info.image = [dict sea_stringForKey:@"thumbnail_pic"];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.price = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    
    info.marketPrice = @"0.0";
    
    info.canGoodComment = ![[dict numberForKey:@"is_comment"] integerValue];
    
    info.goodPromotion = [dict arrayForKey:@"goods_pmt"];
    
    if (info.goodPromotion && info.goodPromotion.count) {
        
        info.goodPromotionAttrString = [WMOrderDetailOpeartion returnPromotionAttrStringWithPromotionsArr:info.goodPromotion];
    }
    
    info.specInfo = [NSString isEmpty:[dict sea_stringForKey:@"attr"]] ? @"" : [dict sea_stringForKey:@"attr"];
    
    info.adjunctGoodsArr = [NSArray new];
    
    info.giftGoodsArr = [NSArray new];
    
    info.type = type;
    
    return info;
}

@end

@implementation WMOrderDetailGroupGoodInfo



@end


@implementation WMOrderDetailInfo
/**初始化
 */
+ (instancetype)returnOrderInfoWithDict:(NSDictionary *)dict{
    
    WMOrderDetailInfo *info = [WMOrderDetailInfo new];
    
    info.orderID = [dict sea_stringForKey:@"order_id"];
    
    info.isStoreAutoOrder = [[dict sea_stringForKey:@"selfproxy_type"] isEqualToString:@"true"];
    
    info.selfMentionStatus = [dict sea_stringForKey:@"selfmention_status"];
    
    info.sinceCode = [dict sea_stringForKey:@"since_code"];
    
    info.quantity = [dict sea_stringForKey:@"itemnum"];
    
    info.memberName = [NSString stringWithFormat:@"买家:%@",[dict sea_stringForKey:@"name"]];
    
    info.orderStatusString = [[dict dictionaryForKey:@"caption"] sea_stringForKey:@"msg"];
    
    info.orderCreateTime = [NSDate formatTimeInterval:[dict sea_stringForKey:@"createtime"] format:DateFormatYMdHm];
    
    info.orderPayTime = [NSString isEmpty:[dict sea_stringForKey:@"pay_time"]] ? nil : [NSDate formatTimeInterval:[dict sea_stringForKey:@"pay_time"] format:DateFormatYMdHm];
    
    info.totalAmount = [dict sea_stringForKey:@"total_amount_format"];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单总额：%@",info.totalAmount]];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:14.0],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 4)];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0],NSForegroundColorAttributeName:WMPriceColor} range:NSMakeRange(5, info.totalAmount.length)];
    
    info.priceAttrString = attrString;
    
    NSDictionary *payInfoDict = [dict dictionaryForKey:@"payinfo"];
    
    info.payAppID = [payInfoDict sea_stringForKey:@"pay_app_id"];
    
    info.payAppName = [payInfoDict sea_stringForKey:@"app_name"];
    
    NSDictionary *shippingDict = [dict dictionaryForKey:@"shipping"];
    
    info.shippingName = [shippingDict sea_stringForKey:@"shipping_name"];
    
    info.isTax = [[dict sea_stringForKey:@"is_tax"] isEqualToString:@"true"];
    
    info.taxType = [dict sea_stringForKey:@"tax_type"];
    
    info.taxTitle = [dict sea_stringForKey:@"tax_title"];
    
    info.taxContent = [dict sea_stringForKey:@"tax_content"];
    
    info.orderPromotion = [dict arrayForKey:@"order_pmt"];
    
    if (info.orderPromotion.count && info.orderPromotion) {
        
        info.orderPromotionAttrString = [WMOrderDetailOpeartion returnPromotionAttrStringWithPromotionsArr:info.orderPromotion];
    }
    
    info.orderMemo = [dict sea_stringForKey:@"memo"];
    
    info.orderStatus = [dict sea_stringForKey:@"status"];
    
    NSDictionary *statusDict = [[dict arrayForKey:@"status_txt"] lastObject];
    
    info.orderStatusTitle = [statusDict sea_stringForKey:@"name"];
    
    if ([info.orderStatus isEqualToString:@"finish"]) {
        
        info.status = OrderStatusFinish;
    }
    else if ([info.orderStatus isEqualToString:@"dead"]){
        
        info.status = OrderStatusDead;
    }
    else{
        
        NSString *statusCode = [statusDict sea_stringForKey:@"code"];
        
        if ([statusCode rangeOfString:@"pay"].location != NSNotFound) {
            
            NSString *code = [statusCode substringWithRange:NSMakeRange(4, 1)];
            
            switch (code.integerValue) {
                case 0:
                {
                    info.status = OrderStatusWaitPay;
                }
                    break;
                case 1:
                {
                    info.status = OrderStatusPay;
                }
                    break;
                case 2:
                {
                    info.status = OrderStatusPayThird;
                }
                    break;
                case 3:
                {
                    info.status = OrderStatusPartPay;
                }
                    break;
                case 4:
                {
                    info.status =  OrderStatusPartMoneyRefund;
                }
                    break;
                case 5:
                {
                    info.status = OrderStatusAllMoneyRefund;
                }
                    break;
                default:
                    break;
            }
        }
        else if([statusCode rangeOfString:@"ship"].location != NSNotFound){
            
            NSString *code = [statusCode substringWithRange:NSMakeRange(5, 1)];
            
            switch (code.integerValue) {
                case 0:
                {
                    info.status = OrderStatusWaitSend;
                }
                    break;
                case 1:
                {
                    info.status = OrderStatusWaitReceive;
                }
                    break;
                case 2:
                {
                    info.status = OrderStatusPartSend;
                }
                    break;
                case 3:
                {
                    info.status = OrderStatusPartGoodRefund;
                }
                    break;
                case 4:
                {
                    info.status = OrderStatusAllGoodRefund;
                }
                    break;
                case 5:
                {
                    info.status = OrderStatusShipFinish;
                }
                    break;
                default:
                    break;
            }
        }
        else{
            
            NSString *name = [statusDict sea_stringForKey:@"name"];
            
            if ([name rangeOfString:@"退款"].location != NSNotFound) {
                
                info.status = OrderStatusPartMoneyRefund;
            }
            else{
                
                info.status = OrderStatusPartGoodRefund;
            }
        }
    }
    
    info.isPrepare = [[dict sea_stringForKey:@"promotion_type"] isEqualToString:@"prepare"];
    
    NSDictionary *prepareDict = [dict dictionaryForKey:@"prepare"];
    
    info.prepareBeginTime = [prepareDict sea_stringForKey:@"begin_time_final"];
    
    info.prepareEndTime = [prepareDict sea_stringForKey:@"end_time_final"];

    info.canCancelOrder = [[dict numberForKey:@"cancel_order"] boolValue];
    
    info.canDeleteOrder = [[dict numberForKey:@"delete_order"] boolValue];
    
    info.mainButtonTitle = [dict sea_stringForKey:@"pay_btn"];
    
    info.actionType = [[dict numberForKey:@"pay_btn_code"] integerValue];
    
    if (info.actionType == MainButtonActionTypeComment) {
        
        info.status = OrderStatusComment;
    }
    
    info.addressInfo = [WMAddressInfo returnOrderDetailAddressInfoWithDict:[dict dictionaryForKey:@"consignee"]];
    
    info.shippingTime = [[dict dictionaryForKey:@"consignee"] sea_stringForKey:@"r_time"];
    
    info.orderGoodsArr = [NSMutableArray new];
    
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [WMOrderDetailGroupGoodInfo new];
    
    normalGroupGoodInfo.type = OrderGoodTypeNormal;
    
    normalGroupGoodInfo.goodsArr = [NSMutableArray new];
    
    for (NSDictionary *normalGoodDict in [dict arrayForKey:@"goods_items"]) {
        
        WMOrderDetailGoodInfo *goodInfo = [WMOrderDetailGoodInfo returnOrderDetailGoodInfoWithDict:normalGoodDict type:info.isPrepare ? -1 : OrderGoodTypeNormal];
        
        NSArray *adjunctGoodsArr = [normalGoodDict arrayForKey:@"adjunct_items"];
        
        if (adjunctGoodsArr && adjunctGoodsArr.count) {
            
            goodInfo.adjunctGoodsArr = [WMOrderDetailGoodInfo returnOrderDetailGoodInfosArrWithDictsArr:adjunctGoodsArr type:OrderGoodTypeNormalAdjunct];
        }
        
        NSArray *giftGoodsArr = [normalGoodDict arrayForKey:@"gift_items"];
        
        if (giftGoodsArr && giftGoodsArr.count) {
            
            goodInfo.giftGoodsArr = [WMOrderDetailGoodInfo returnOrderDetailGoodInfosArrWithDictsArr:giftGoodsArr type:OrderGoodTypeNormalGift];
        }
        
        [normalGroupGoodInfo.goodsArr addObject:goodInfo];
    }
    
    [info.orderGoodsArr addObject:normalGroupGoodInfo];
    
    WMOrderDetailGroupGoodInfo *orderGiftGroupGoodInfo = [WMOrderDetailGroupGoodInfo new];
    
    orderGiftGroupGoodInfo.type = OrderGoodTypeOrderGift;
    
    orderGiftGroupGoodInfo.goodsArr = [NSMutableArray new];
    
    [orderGiftGroupGoodInfo.goodsArr addObjectsFromArray:[WMOrderDetailGoodInfo returnOrderDetailGoodInfosArrWithDictsArr:[[dict dictionaryForKey:@"order"] arrayForKey:@"gift_items"] type:OrderGoodTypeOrderGift]];
    
    [info.orderGoodsArr addObject:orderGiftGroupGoodInfo];
    
    WMOrderDetailGroupGoodInfo *pointGroupGoodInfo = [WMOrderDetailGroupGoodInfo new];
    
    pointGroupGoodInfo.type = OrderGoodTypePoint;
    
    pointGroupGoodInfo.goodsArr = [NSMutableArray new];
    
    [pointGroupGoodInfo.goodsArr addObjectsFromArray:[WMOrderDetailGoodInfo returnOrderDetailGoodInfosArrWithDictsArr:[[dict dictionaryForKey:@"gift"] arrayForKey:@"gift_items"] type:OrderGoodTypePoint]];
    
    [info.orderGoodsArr addObject:pointGroupGoodInfo];
    
    info.orderPriceDictsArr = [NSMutableArray new];
    
    [info updatePriceInfoWithPriceDict:dict];
    
    info.orderPriceAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:NO priceDictsArr:info.orderPriceDictsArr];
    
    info.orderTitleAttrString = [WMConfirmOrderOperation returnPriceAttributedStringIsTitle:YES priceDictsArr:info.orderPriceDictsArr];
    
    NSArray *logistic = [dict arrayForKey:@"logistic"];
    
    if (logistic.count) {
        
        NSDictionary *logisticDict = [logistic lastObject];
        
        info.deliveryID = [logisticDict sea_stringForKey:@"delivery_id"];
        
        info.deliveryType = [logisticDict sea_stringForKey:@"behavior"];
    }
    
    if (normalGroupGoodInfo.goodsArr.count == 0 && orderGiftGroupGoodInfo.goodsArr.count == 0 && pointGroupGoodInfo.goodsArr.count != 0) {
        
        info.isInitPointOrder = YES;
    }
    else{
        
        info.isInitPointOrder = NO;
    }
    
    return info;
}

- (void)updatePriceInfoWithPriceDict:(NSDictionary *)orderDetailPriceDict{
    
    [self.orderPriceDictsArr removeAllObjects];
    
    [self returnPriceDictWithTitle:@"商品金额" price:[NSString stringWithFormat:@"%@%@",[self.totalAmount substringToIndex:1],[orderDetailPriceDict sea_stringForKey:@"price_total"]] type:OrderPriceTypeInitTotal];
    
    [self returnPriceDictWithTitle:@"商品金额" price:[orderDetailPriceDict sea_stringForKey:@"cost_item"] type:OrderPriceTypeGoodTotal];
    
    [self returnPriceDictWithTitle:@"商品优惠" price:[orderDetailPriceDict sea_stringForKey:@"pmt_goods"] type:OrderPriceTypeGoodPromotion];
    
    [self returnPriceDictWithTitle:@"订单优惠" price:[orderDetailPriceDict sea_stringForKey:@"pmt_order"] type:OrderPriceTypePromotion];
    
    [self returnPriceDictWithTitle:@"积分抵扣金额" price:[orderDetailPriceDict sea_stringForKey:@"point_dis_price"] type:OrderPriceTypePointDiscount];
    
    NSDictionary *shippingDict = [orderDetailPriceDict dictionaryForKey:@"shipping"];
    
    [self returnPriceDictWithTitle:@"运费" price:[shippingDict sea_stringForKey:@"cost_shipping"] type:OrderPriceTypeFreight];
    
    [self returnPriceDictWithTitle:@"物流保价费" price:[shippingDict sea_stringForKey:@"cost_protect"] type:OrderPriceTypeExpressProtect];
    
    [self returnPriceDictWithTitle:@"手续费" price:[orderDetailPriceDict sea_stringForKey:@"cost_payment"] type:OrderPriceTypeCustomerPayment];
    
    [self returnPriceDictWithTitle:@"发票税金" price:[orderDetailPriceDict sea_stringForKey:@"cost_tax"] type:OrderPriceTypeTax];
    
    [self returnPriceDictWithTitle:@"订单总金额" price:[orderDetailPriceDict sea_stringForKey:@"total_amount_format"] type:OrderPriceTypeOrderTotal];
    
    [self returnPriceDictWithTitle:@"订单消费积分" price:[orderDetailPriceDict sea_stringForKey:@"score_u"] type:OrderPriceTypeConsumeScore];
    
    [self returnPriceDictWithTitle:@"订单获得积分" price:[orderDetailPriceDict sea_stringForKey:@"score_g"] type:OrderPriceTypeGainScore];
    
    [self returnPriceDictWithTitle:@"预售商品订金" price:[orderDetailPriceDict sea_stringForKey:@"prepare_total_amount"] type:OrderPriceTypePrepare];
    
    [self returnPriceDictWithTitle:@"已支付金额" price:[orderDetailPriceDict sea_stringForKey:@"payed"] type:OrderPriceTypePayed];
    
    [self returnPriceDictWithTitle:@"货币汇率" price:[orderDetailPriceDict sea_stringForKey:@"cur_rate"] type:OrderPriceTypeRate];
    
    [self returnPriceDictWithTitle:@"货币结算金额" price:[orderDetailPriceDict sea_stringForKey:@"cur_amount"] type:OrderPriceTypeCurAmount];
}

- (void)returnPriceDictWithTitle:(NSString *)title price:(NSString *)price type:(OrderPriceType)type{
    
    [self.orderPriceDictsArr addObject:@{@(type):@{@"title":title,@"price":[NSString isEmpty:price] ? @"0.0" : price}}];
}

- (CGFloat)returnPriceInfoHeight{
        
    return [self.orderPriceAttrString boundsWithConstraintWidth:((_width_ - kConfirmOrderMoneyPayInfoExtraWidth) / 2.0)].height + kConfirmOrderMoneyPayInfoExtraWidth;
}

/**地址文本高度
 */
- (CGFloat)returnAddrHeight{
    
    CGFloat width = _width_ - kConfirmOrderAddrExtraWidth;
    
    CGSize addrSize = [self.addressInfo.addressDetail stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:width];
    
    return addrSize.height + kConfirmOrderAddrExtraHeight;
}









@end
