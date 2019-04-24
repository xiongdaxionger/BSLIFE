//
//  WMOrderInfo.m
//  StandardShop
//
//  Created by mac on 16/7/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderInfo.h"
#import "WMMyOrderOperation.h"
#import "WMPriceOperation.h"

@implementation WMOrderGoodInfo

/**批量初始化
 */
+ (NSArray *)returnOrderGoodInfosArrWithDictsArr:(NSArray *)dictsArr type:(OrderGoodType)type canComment:(BOOL)canComment{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMOrderGoodInfo returnOrderGoodInfoWithDict:dict type:type canComment:canComment]];
    }
    
    return infosArr;
}

+ (instancetype)returnOrderGoodInfoWithDict:(NSDictionary *)dict type:(OrderGoodType)type canComment:(BOOL)canComment{
    
    WMOrderGoodInfo *info = [WMOrderGoodInfo new];
    
    info.type = type;
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.marketPrice = @"0.00";
    
    if (canComment) {
        
        info.canGoodComment = ![[dict numberForKey:@"is_comment"] integerValue];
    }
    else{
        
        info.canGoodComment = NO;
    }
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodName = [dict sea_stringForKey:@"name"];
    
    info.formatGoodName = [WMMyOrderOperation returnGoodAttrNameWithType:type goodName:info.goodName];
        
    info.image = [dict sea_stringForKey:@"thumbnail_pic"];
    
    info.specInfo = [NSString isEmpty:[dict sea_stringForKey:@"attr"]] ? @"" : [dict sea_stringForKey:@"attr"];
    
    info.price = [WMPriceOperation formatPrice:[dict sea_stringForKey:@"price"] font:[UIFont fontWithName:MainFontName size:16.0]];
    
    info.quantity = [dict sea_stringForKey:@"quantity"];
    
    return info;
}

@end


@implementation WMOrderInfo

/**批量初始化
 */
+ (NSArray *)returnOrderInfosArrWithDictsArr:(NSArray *)dictsArr canComment:(BOOL)canComment{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        [infosArr addObject:[WMOrderInfo returnOrderInfoWithDict:dict canComment:canComment]];
    }
    
    return infosArr;
}

+ (instancetype)returnOrderInfoWithDict:(NSDictionary *)dict canComment:(BOOL)canComment{
    
    WMOrderInfo *info = [WMOrderInfo new];
    
    info.orderID = [dict sea_stringForKey:@"order_id"];
    
    info.isStoreAutoOrder = [[dict sea_stringForKey:@"selfproxy_type"] isEqualToString:@"true"];
    
    info.selfMentionStatus = [dict sea_stringForKey:@"selfmention_status"];
    
    info.sinceCode = [dict sea_stringForKey:@"since_code"];
    
    info.orderCreateTime = [NSDate formatTimeInterval:[dict sea_stringForKey:@"createtime"] format:DateFormatYMdHm];
    
    info.isPrepareOrder = [[dict sea_stringForKey:@"promotion_type"] isEqualToString:@"prepare"];
        
    if (info.isPrepareOrder) {
        
        NSDictionary *prepare = [dict dictionaryForKey:@"prepare"];
        
        if (prepare) {
            
            info.prepareBeginTime = [prepare sea_stringForKey:@"begin_time_final"];
            
            info.prepareFinalTime = [prepare sea_stringForKey:@"end_time_final"];
            
            info.prepareSellPrice = [prepare sea_stringForKey:@"preparesell_price"];
            
            info.prepareFinalPrice = [prepare sea_stringForKey:@"final_price"];
        }
        else{
            
            info.prepareBeginTime = @"0.0";
            
            info.prepareFinalPrice = @"0.0";
            
            info.prepareFinalTime = @"0.0";
            
            info.prepareSellPrice = @"0.0";
        }
    }
    
    NSDictionary *payDict = [dict dictionaryForKey:@"payinfo"];
    
    info.payAppID = [payDict sea_stringForKey:@"pay_app_id"];
    
    info.payAppName = [payDict sea_stringForKey:@"pay_name"];
    
    info.orderStatus = [dict sea_stringForKey:@"status"];
    
    info.canOrderAffter = [[dict numberForKey:@"is_afterrec"] boolValue];
    
    NSArray *statusArr = [dict arrayForKey:@"status_txt"];
    
    NSDictionary *statusDict = [statusArr lastObject];
    
    NSMutableString *string = [NSMutableString new];
    
    for (NSDictionary *everyStatusDict in statusArr) {
        
        [string appendString:[everyStatusDict sea_stringForKey:@"name"]];
    }
    
    info.orderStatusTitle = string;
    
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
    
    info.orderTotalMoney = [NSString isEmpty:[dict sea_stringForKey:@"cur_amount"]] ? [dict sea_stringForKey:@"total_amount"] : [dict sea_stringForKey:@"cur_amount"];
    
    info.canCancelOrder = [[dict numberForKey:@"cancel_order"] boolValue];
    
    info.canDeleteOrder = [[dict numberForKey:@"delete_order"] boolValue];
    
    info.orderQuantity = [dict sea_stringForKey:@"itemnum"];
    
    info.mainButtonTitle = [dict sea_stringForKey:@"pay_btn"];
    
    info.actionType = [[dict numberForKey:@"pay_btn_code"] integerValue];
    
    if (info.actionType == MainButtonActionTypeComment) {
        
        info.status = OrderStatusComment;
    }
    
    NSArray *normalGoodItemsArr = [dict arrayForKey:@"goods_items"];
    
    info.orderGoodsArr = [NSMutableArray new];
    
    for (NSDictionary *goodItemDict in normalGoodItemsArr) {
        
        [info.orderGoodsArr addObject:[WMOrderGoodInfo returnOrderGoodInfoWithDict:goodItemDict type:info.isPrepareOrder ? -1 : OrderGoodTypeNormal canComment:canComment]];
        
        NSArray *goodGiftsArr = [goodItemDict arrayForKey:@"gift_items"];
        
        if (goodGiftsArr) {
            
            [info.orderGoodsArr addObjectsFromArray:[WMOrderGoodInfo returnOrderGoodInfosArrWithDictsArr:goodGiftsArr type:OrderGoodTypeNormalGift canComment:canComment]];
        }
        
        NSArray *goodAdjucntsArr = [goodItemDict arrayForKey:@"adjunct_items"];
        
        if (goodAdjucntsArr) {
            
            [info.orderGoodsArr addObjectsFromArray:[WMOrderGoodInfo returnOrderGoodInfosArrWithDictsArr:goodAdjucntsArr type:OrderGoodTypeNormalAdjunct canComment:canComment]];
        }
    }
    
    NSArray *orderGoodGiftsArr = [[dict dictionaryForKey:@"order"] arrayForKey:@"gift_items"];
    
    [info.orderGoodsArr addObjectsFromArray:[WMOrderGoodInfo returnOrderGoodInfosArrWithDictsArr:orderGoodGiftsArr type:OrderGoodTypeOrderGift canComment:canComment]];
    
    NSArray *orderGoodsPointArr = [[dict dictionaryForKey:@"gift"] arrayForKey:@"gift_items"];
    
    [info.orderGoodsArr addObjectsFromArray:[WMOrderGoodInfo returnOrderGoodInfosArrWithDictsArr:orderGoodsPointArr type:OrderGoodTypePoint canComment:canComment]];
    
    if (normalGoodItemsArr.count == 0 && orderGoodGiftsArr.count == 0 && orderGoodsPointArr.count != 0) {
        
        info.isInitPointOrder = YES;
    }
    else{
        
        info.isInitPointOrder = NO;
    }
    
    if (orderGoodsPointArr.count) {
        
        info.orderContainPointGood = YES;
        
    }
    else{
        
        info.orderContainPointGood = NO;
    }
    
    info.orderScoreUse = [dict sea_stringForKey:@"score_u"];
    
    if (info.isPrepareOrder) {
        
        NSMutableAttributedString *attrString;
        
        if (info.status == OrderStatusWaitPay) {
            
            attrString = [info createCommonAttrWith:[NSString stringWithFormat:@"共%@件 合计:",info.orderQuantity] andContent:[NSString stringWithFormat:@"%@",info.orderTotalMoney]];
        }
        else if (info.status == OrderStatusPartPay){
            
            attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件 已付定金%@ 待付尾款%@",info.orderQuantity,info.prepareSellPrice,info.prepareFinalPrice]];
            
            [attrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:[attrString.string rangeOfString:info.prepareSellPrice]];
            
            [attrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:[attrString.string rangeOfString:info.prepareFinalPrice]];
        }
        else{
            
            attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件 已付:%@ 无需补尾款",info.orderQuantity,info.orderTotalMoney]];
            
            [attrString addAttributes:@{NSForegroundColorAttributeName:WMRedColor} range:[attrString.string rangeOfString:info.orderTotalMoney]];
        }
        
        [attrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, attrString.string.length)];
        
        info.priceAttrString = attrString;
    }
    else{
        
        if (info.orderContainPointGood) {
            
            if (info.isInitPointOrder) {
                
                info.priceAttrString = [info createCommonAttrWith:[NSString stringWithFormat:@"共%@件 兑换消费积分:",info.orderQuantity] andContent:[NSString isEmpty:info.orderScoreUse] ? @"0" : info.orderScoreUse];
            }
            else{
                
                info.priceAttrString = [info createCommonAttrWith:[NSString stringWithFormat:@"共%@件 合计:",info.orderQuantity] andContent:info.orderTotalMoney];
            }
        }
        else{
            
            info.priceAttrString = [info createCommonAttrWith:[NSString stringWithFormat:@"共%@件 合计:",info.orderQuantity] andContent:info.orderTotalMoney];
        }
    }
    
    return info;
}

- (NSMutableAttributedString *)createCommonAttrWith:(NSString *)title andContent:(NSString *)content{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",title,content]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:WMPriceColor,
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:[attStr.string rangeOfString:content]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:[attStr.string rangeOfString:title]];
    return attStr;
}








@end
