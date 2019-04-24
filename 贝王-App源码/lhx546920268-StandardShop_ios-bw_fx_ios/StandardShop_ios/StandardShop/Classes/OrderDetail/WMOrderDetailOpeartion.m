//
//  WMOrderDetailOpeartion.m
//  WanShoes
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderDetailOpeartion.h"

#import "WMOrderdetailInfo.h"
#import "WMUserOperation.h"
#import "WMShopCarPromotionRuleInfo.h"
#import "WMServerTimeOperation.h"
@implementation WMOrderDetailOpeartion

/**返回订单详情的每组的行数
 */
+ (NSInteger)returnSectionRowNumberWithIndexPath:(NSInteger)section orderModel:(WMOrderDetailInfo *)orderModel{
        
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [orderModel.orderGoodsArr firstObject];
    
    NSInteger normalGoodSection = 0;

    if (normalGroupGoodInfo.goodsArr.count) {
        
        if (section >= OrderDetailSectionNormalGood + normalGroupGoodInfo.goodsArr.count) {
            
            section = section - normalGroupGoodInfo.goodsArr.count + 1;
        }
        else if (section >= OrderDetailSectionNormalGood && section < normalGroupGoodInfo.goodsArr.count + OrderDetailSectionNormalGood){
            
            normalGoodSection = section - OrderDetailSectionNormalGood;
            
            section = OrderDetailSectionNormalGood;
        }
    }
    else{
        
        if (section >= OrderDetailSectionNormalGood) {
            
            section = section + 1;
        }
    }
    
    switch (section) {
        case OrderDetailSectionID:
        {
            return 2;
        }
            break;
        case OrderDetailSectionAddress:
        {
            return 1;
        }
            break;
        case OrderDetailSectionCustomer:
        {
            return orderModel.memberName == nil ? 0 : 1;
        }
            break;
        case OrderDetailSectionNormalGood:
        {
            WMOrderDetailGoodInfo *goodInfo = [normalGroupGoodInfo.goodsArr objectAtIndex:normalGoodSection];
            
            if (goodInfo.goodPromotion && goodInfo.goodPromotion.count) {
                
                return goodInfo.adjunctGoodsArr.count + goodInfo.giftGoodsArr.count + 2;
            }
            else{
                
                return goodInfo.adjunctGoodsArr.count + goodInfo.giftGoodsArr.count + 1;
            }
        }
            break;
        case OrderDetailSectionOrderGiftGood:
        {
            WMOrderDetailGroupGoodInfo *orderGiftGroupGoodInfo = [orderModel.orderGoodsArr objectAtIndex:1];
            
            return orderGiftGroupGoodInfo.goodsArr.count;
        }
            break;
        case OrderDetailSectionPointGood:
        {
            WMOrderDetailGroupGoodInfo *pointGroupGoodInfo = [orderModel.orderGoodsArr objectAtIndex:2];
            
            return pointGroupGoodInfo.goodsArr.count;
        }
            break;
        case OrderDetailSectionPromotion:
        {
            return orderModel.orderPromotion.count ? 1 : 0;
        }
            break;
        case OrderDetailSectionSinceCode:
        {
            return (orderModel.isStoreAutoOrder && orderModel.status != OrderStatusDead && orderModel.status != OrderStatusWaitPay && orderModel.status != OrderStatusPartMoneyRefund && orderModel.status != OrderStatusAllMoneyRefund && orderModel.status != OrderStatusAllGoodRefund && orderModel.status != OrderStatusPartGoodRefund) ? 1 : 0;
        }
            break;
        case OrderDetailSectionInfo:
        {
            if (orderModel.isPrepare) {
                
                if (orderModel.status == OrderStatusPartPay){
                    
                    return 5;
                }
                else{
                    
                    return 4;
                }
            }
            else{
                
                return [NSString isEmpty:orderModel.shippingTime] ? 4 : 5;
            }
        }
            break;
        case OrderDetailSectionPrice:
        {
            return 2;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

/**返回订单详情的组数
 */
+ (NSInteger)returnSectionNumberWithInfo:(WMOrderDetailInfo *)info{
    
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [info.orderGoodsArr firstObject];

    return 9 + normalGroupGoodInfo.goodsArr.count;
}

/**返回订单详情尾部视图高度
 */
+ (CGFloat)returnOrderDetailTableFooterHeightWithIndex:(NSInteger)section orderInfo:(WMOrderDetailInfo *)orderInfo{
    
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [orderInfo.orderGoodsArr firstObject];
    
   // NSInteger normalGoodSection = 0;
    
    if (normalGroupGoodInfo.goodsArr.count) {
        
        if (section >= OrderDetailSectionNormalGood + normalGroupGoodInfo.goodsArr.count) {
            
            section = section - normalGroupGoodInfo.goodsArr.count + 1;
        }
        else if (section >= OrderDetailSectionNormalGood && section < normalGroupGoodInfo.goodsArr.count + OrderDetailSectionNormalGood){
            
           // normalGoodSection = section - OrderDetailSectionNormalGood;
            
            section = OrderDetailSectionNormalGood;
        }
    }
    else{
        
        if (section >= OrderDetailSectionNormalGood) {
            
            section = section + 1;
        }
    }
    
    switch (section) {
        case OrderDetailSectionNormalGood:
        {
            return normalGroupGoodInfo.goodsArr.count ? 10.0 : CGFLOAT_MIN;
        }
            break;
        case OrderDetailSectionPointGood:
        {
            WMOrderDetailGroupGoodInfo *pointGroupInfo = [orderInfo.orderGoodsArr objectAtIndex:2];
            
            return pointGroupInfo.goodsArr.count ? 10.0 : CGFLOAT_MIN;
        }
            break;
        case OrderDetailSectionOrderGiftGood:
        {
            WMOrderDetailGroupGoodInfo *giftGroupInfo = [orderInfo.orderGoodsArr objectAtIndex:1];
            
            return giftGroupInfo.goodsArr.count ? 10.0 : CGFLOAT_MIN;
        }
            break;
        case OrderDetailSectionPromotion:
        {
            return orderInfo.orderPromotion.count ? 10.0 : CGFLOAT_MIN;
        }
            break;
        case OrderDetailSectionCustomer:
        {
            return orderInfo.memberName == nil ? CGFLOAT_MIN : 10.0;
        }
            break;
        default:
        {
            return 10.0;
        }
            break;
    }
}

/**返回订单详情配置类
 */
+ (XTableCellConfigEx *)returnConfigWithSection:(NSIndexPath *)indexPath configArr:(NSArray *)configArr orderInfo:(WMOrderDetailInfo *)info{
    
    //    _configureArr = @[idConfig,addrConfig,goodConfig,promotionConfig,infoConfig,priceConfig,orderTimeConfig,customerConfig,barCodeConfig,sinceCodeConfig];
    
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [info.orderGoodsArr firstObject];
    
    NSInteger normalGoodSection = 0;
    
    NSInteger section;
    
    if (normalGroupGoodInfo.goodsArr.count) {
        
        if (indexPath.section >= OrderDetailSectionNormalGood + normalGroupGoodInfo.goodsArr.count) {
            
            section = indexPath.section - normalGroupGoodInfo.goodsArr.count + 1;
        }
        else if (indexPath.section >= OrderDetailSectionNormalGood && indexPath.section < normalGroupGoodInfo.goodsArr.count + OrderDetailSectionNormalGood){
            
            normalGoodSection = indexPath.section - OrderDetailSectionNormalGood;
            
            section = OrderDetailSectionNormalGood;
        }
        else{
            
            section = indexPath.section;
        }
    }
    else{
        
        if (indexPath.section >= OrderDetailSectionNormalGood) {
            
            section = indexPath.section + 1;
        }
        else{
            
            section = indexPath.section;
        }
    }
    
    switch (section) {
        case OrderDetailSectionID:
        {
            return indexPath.row == 0 ? (info.status == OrderStatusWaitSend ? [configArr objectAtIndex:8] : [configArr firstObject]) : [configArr firstObject];
        }
            break;
        case OrderDetailSectionAddress:
        {
            return [configArr objectAtIndex:1];
        }
            break;
        case OrderDetailSectionNormalGood:
        {
            WMOrderDetailGoodInfo *goodInfo = [normalGroupGoodInfo.goodsArr objectAtIndex:normalGoodSection];
            
            if (indexPath.row == goodInfo.adjunctGoodsArr.count + goodInfo.giftGoodsArr.count + 1) {
                
                return [configArr objectAtIndex:3];
            }
            else{
                
                return [configArr objectAtIndex:2];
            }
        }
            break;
        case OrderDetailSectionOrderGiftGood:
        case OrderDetailSectionPointGood:
        {
            return [configArr objectAtIndex:2];
        }
            break;
        case OrderDetailSectionPromotion:
        {
            return [configArr objectAtIndex:3];
        }
            break;
        case OrderDetailSectionSinceCode:
        {
            return [configArr lastObject];
        }
            break;
        case OrderDetailSectionInfo:
        {
            
            return [configArr objectAtIndex:4];
        }
            break;
        case OrderDetailSectionPrice:
        {
            return indexPath.row == 0 ? [configArr objectAtIndex:5] : [configArr objectAtIndex:6];
        }
            break;
        case OrderDetailSectionCustomer:
        {
            return [configArr objectAtIndex:7];
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

/**返回订单详情模型
 */
+ (id)returnOrderModelWith:(NSIndexPath *)indexPath orderModel:(WMOrderDetailInfo *)orderModel{
    
    WMOrderDetailGroupGoodInfo *normalGroupGoodInfo = [orderModel.orderGoodsArr firstObject];
    
    NSInteger normalGoodSection = 0;
    
    NSInteger section;
    
    if (normalGroupGoodInfo.goodsArr.count) {
        
        if (indexPath.section >= OrderDetailSectionNormalGood + normalGroupGoodInfo.goodsArr.count) {
            
            section = indexPath.section - normalGroupGoodInfo.goodsArr.count + 1;
        }
        else if (indexPath.section >= OrderDetailSectionNormalGood && indexPath.section < normalGroupGoodInfo.goodsArr.count + OrderDetailSectionNormalGood){
            
            normalGoodSection = indexPath.section - OrderDetailSectionNormalGood;
            
            section = OrderDetailSectionNormalGood;
        }
        else{
            
            section = indexPath.section;
        }
    }
    else{
        
        if (indexPath.section >= OrderDetailSectionNormalGood) {
            
            section = indexPath.section + 1;
        }
        else{
            
            section = indexPath.section;
        }
    }
    
    switch (section) {
        case OrderDetailSectionID:
        {
            if (indexPath.row) {
                
                return orderModel.orderStatusString;
            }
            else{
                
                return orderModel.status == OrderStatusWaitSend ? orderModel.orderID : [NSString stringWithFormat:@"订单号：%@",orderModel.orderID];
            }
        }
            break;
        case OrderDetailSectionPrice:
        {
            return orderModel;
        }
            break;
        case OrderDetailSectionPointGood:
        {
            WMOrderDetailGroupGoodInfo *pointGroupInfo = [orderModel.orderGoodsArr objectAtIndex:2];
            
            return [pointGroupInfo.goodsArr objectAtIndex:indexPath.row];
        }
            break;
        case OrderDetailSectionOrderGiftGood:
        {
            WMOrderDetailGroupGoodInfo *giftGroupInfo = [orderModel.orderGoodsArr objectAtIndex:1];
            
            return [giftGroupInfo.goodsArr objectAtIndex:indexPath.row];
        }
            break;
        case OrderDetailSectionNormalGood:
        {
            WMOrderDetailGoodInfo *goodInfo = [normalGroupGoodInfo.goodsArr objectAtIndex:normalGoodSection];

            if (indexPath.row == goodInfo.adjunctGoodsArr.count + goodInfo.giftGoodsArr.count + 1) {
                
                return goodInfo.goodPromotionAttrString;
            }
            else{
                
                NSMutableArray *goodsArr = [NSMutableArray new];
                
                [goodsArr addObjectsFromArray:goodInfo.adjunctGoodsArr];
                
                [goodsArr addObjectsFromArray:goodInfo.giftGoodsArr];
                
                if (indexPath.row == 0) {
                    
                    return goodInfo;
                }
                else{
                    
                    return [goodsArr objectAtIndex:indexPath.row - 1];
                }
            }
        }
            break;
        case OrderDetailSectionAddress:
        {
            return @{@"info":orderModel.addressInfo,@"hidden":@(YES)};
        }
            break;
        case OrderDetailSectionPromotion:
        {
            return orderModel.orderPromotionAttrString;
        }
            break;
        case OrderDetailSectionCustomer:
        {
            return orderModel.memberName == nil ? @"" : orderModel.memberName;
        }
            break;
        case OrderDetailSectionSinceCode:
        {
            NSString *statusMsg = orderModel.isStoreAutoOrder ? orderModel.selfMentionStatus : nil;
            
            return @{@"code":[NSString isEmpty:orderModel.sinceCode] ? @"" : orderModel.sinceCode,@"quantity":orderModel.quantity,@"status":[NSString isEmpty:statusMsg] ? @"" : statusMsg};
        }
            break;
        case OrderDetailSectionInfo:
        {
            NSString *title;
            
            NSString *content;
            
            if (orderModel.isPrepare) {
                
                NSInteger count;
                
                if (orderModel.status == OrderStatusPartPay) {
                    
                    count = 0;
                }
                else{
                    
                    count = -1;
                }
                
                if (indexPath.row == count) {
                    
                    title = @"补款时间";
                    
                    if (orderModel.prepareBeginTime.integerValue >= [WMServerTimeOperation sharedInstance].time) {
                        
                        content = [NSString stringWithFormat:@"尾款补款期限于%@开启",[NSDate formatTimeInterval:orderModel.prepareBeginTime format:DateFormatYMdHm]];
                    }
                    else{
                        
                        if (orderModel.prepareEndTime.integerValue >= [WMServerTimeOperation sharedInstance].time) {
                            
                            content = [NSString stringWithFormat:@"请在%@前补完尾款",[NSDate formatTimeInterval:orderModel.prepareEndTime format:DateFormatYMdHm]];
                        }
                        else{
                            
                            content = [NSString stringWithFormat:@"尾款补款期限于%@结束",[NSDate formatTimeInterval:orderModel.prepareEndTime format:DateFormatYMdHm]];
                        }
                    }
                }
                else if (indexPath.row == count + 1) {
                    
                    title = @"支付方式";
                    
                    content = orderModel.payAppName;
                }
                else if (indexPath.row == count + 2){
                    
                    title = @"配送方式";
                    
                    content = orderModel.shippingName;
                }
                else if (indexPath.row == count + 3)
                {
                    title = @"发票信息";
                    
                    content = orderModel.isTax ? [NSString stringWithFormat:@"%@ %@ %@",orderModel.taxType,orderModel.taxTitle,orderModel.taxContent] : @"不开发票";
                }
                else{
                    
                    title = @"订单备注";
                    
                    content = orderModel.orderMemo;
                }
            }
            else{
                
                if ([NSString isEmpty:orderModel.shippingTime]) {
                    
                    if (indexPath.row == 0) {
                        
                        title = @"支付方式";
                        
                        content = orderModel.payAppName;
                    }
                    else if (indexPath.row == 1){
            
                        title = @"配送方式";
                        
                        content = orderModel.shippingName;
                    }
                    else if (indexPath.row == 2)
                    {
                        title = @"发票信息";
                        
                        content = orderModel.isTax ? [NSString stringWithFormat:@"%@ %@ %@",orderModel.taxType,orderModel.taxTitle,orderModel.taxContent] : @"不开发票";
                    }
                    else{
                        
                        title = @"订单备注";
                        
                        content = orderModel.orderMemo;
                    }
                }
                else{
                    
                    if (indexPath.row == 0) {
                        
                        title = @"支付方式";
                        
                        content = orderModel.payAppName;
                    }
                    else if (indexPath.row == 1){
                        
                        title = @"配送方式";
                        
                        content = orderModel.shippingName;
                    }
                    else if (indexPath.row == 2){
                        
                        title = @"配送时间";
                        
                        content = orderModel.shippingTime;
                    }
                    else if (indexPath.row == 3)
                    {
                        title = @"发票信息";
                        
                        content = orderModel.isTax ? [NSString stringWithFormat:@"%@ %@ %@",orderModel.taxType,orderModel.taxTitle,orderModel.taxContent] : @"不开发票";
                    }
                    else{
                        
                        title = @"订单备注";
                        
                        content = orderModel.orderMemo;
                    }
                }
            }
            
            if ([NSString isEmpty:content]) {
                
                content = @"暂无信息";
            }
            
            return @{@"title":title,@"content":content};
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}


/**返回享受优惠的属性字符串--订单/商品优惠
 */
+ (NSAttributedString *)returnPromotionAttrStringWithPromotionsArr:(NSArray *)promotionsArr{
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragarphStyle setLineSpacing:8];
    
    NSMutableAttributedString *attrString = [NSMutableAttributedString new];
    
    for (NSInteger i = 0;i < promotionsArr.count;i++) {
        
        id ruleInfo = [promotionsArr objectAtIndex:i];
        
        NSString *contentString;
        
        NSString *infoString;
        
        if ([ruleInfo isKindOfClass:[NSDictionary class]]) {
            
            infoString = [NSString stringWithFormat:@"[%@] %@",[ruleInfo sea_stringForKey:@"pmt_tag"],[ruleInfo sea_stringForKey:@"pmt_memo"]];
        }
        else{
            
            WMShopCarPromotionRuleInfo *promotionInfo = (WMShopCarPromotionRuleInfo *)ruleInfo;
            
            infoString = [NSString stringWithFormat:@"[%@] %@",promotionInfo.ruleTag,promotionInfo.ruleName];
        }
        
        if (i == promotionsArr.count - 1) {
            
            contentString = infoString;
        }
        else{
            
            contentString = [NSString stringWithFormat:@"%@\n",infoString];
        }
        
        NSMutableAttributedString *contentAttrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        [contentAttrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.4 alpha:1.0]} range:NSMakeRange(0, contentString.length)];
        
        if ([ruleInfo isKindOfClass:[NSDictionary class]]) {
            
            [contentAttrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:NSMakeRange(0, [ruleInfo sea_stringForKey:@"pmt_tag"].length + 2)];
        }
        else{
            
            WMShopCarPromotionRuleInfo *promotionInfo = (WMShopCarPromotionRuleInfo *)ruleInfo;

            [contentAttrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:NSMakeRange(0, promotionInfo.ruleTag.length + 2)];
        }
        
        [attrString appendAttributedString:contentAttrString];
    }
    
    UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
    
    if ([attrString.string stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height > font.lineHeight) {
        
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [attrString.string length])];
    }
    
    [attrString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, [attrString.string length])];
    
    return attrString;
}

/**订单号获取订单详情 参数
 *@param 订单号
 */
+ (NSDictionary *)returnOrderDetailWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.member.orderdetail",@"order_id":orderID};
}
/**订单号获取订单详情 结果
 */
+ (WMOrderDetailInfo *)returnOrderDetailInfoWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [WMOrderDetailInfo returnOrderInfoWithDict:[[dict dictionaryForKey:WMHttpData] dictionaryForKey:@"order"]];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

















@end
