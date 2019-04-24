//
//  WMOrderOperation.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMMyOrderOperation.h"
#import "WMUserInfo.h"
#import "XTableCellConfigEx.h"
#import "WMUserOperation.h"

#import "WMOrderInfo.h"
#import "WMServerTimeOperation.h"
@implementation WMMyOrderOperation


#pragma mark - new
/**获取我的订单信息 参数
 *@param 订单类型 orderType,-1时为预售订单
 */
+ (NSDictionary *)returnMyOrderParamWithOrderType:(OrderType)type pageIndex:(NSInteger)pageIndex memberID:(NSString *)memberID isCommision:(BOOL)isCommision{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.member.orders" forKey:WMHttpMethod];
    
    [param setObject:@(pageIndex) forKey:WMHttpPageIndex];
    
    [param setObject:memberID forKey:WMUserInfoId];
    
    [param setObject:isCommision ? @"true" : @"false" forKey:@"is_fx"];
    
    switch (type) {
        case OrderTypeAll:
        {
            [param setObject:@"all" forKey:@"order_status"];
        }
            break;
        case OrderTypeWaitComment:
        {
            [param setObject:@"nodiscuss" forKey:@"order_status"];
        }
            break;
        case OrderTypeWaitPay:
        {
            [param setObject:@"nopayed" forKey:@"order_status"];
        }
            break;
        case OrderTypeWaitReceive:
        {
            [param setObject:@"noreceived" forKey:@"order_status"];
        }
            break;
        case OrderTypeWaitShip:
        {
            [param setObject:@"noship" forKey:@"order_status"];
        }
            break;
        default:
        {
            [param setObject:@"prepare" forKey:@"order_status"];
        }
            break;
    }
    
    return param;
}
/**获取我的订单信息 结果
 *@param 订单数组--元素是WMOrderInfo
 *@param 订单总数
 */
+ (NSDictionary *)returnMyOrderInfoResultWithData:(NSData *)data canComment:(BOOL)canComment{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        long long count = [WMUserOperation totalSizeFromDictionary:dataDict];
        
        NSArray *orderInfosArr = [WMOrderInfo returnOrderInfosArrWithDictsArr:[dataDict arrayForKey:@"orders"] canComment:canComment];
        
        return @{@"info":orderInfosArr,@"count":@(count)};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**返回订单类型
 *@param 下标 NSInteger
 *return 订单类型 NSString
 */
+ (NSString *)returnOrderTypeWithIndex:(NSInteger)index{
    
    if (index == 0) {
        
        return @"";
    }
    else if (index == 1){
        
        return WMWaitPayTitle;
    }
    else if (index == 2){
        
        return WMWaitSendTitle;
    }
    else if (index == 3){
        
        return WMWaitReceiveTitle;
    }
    else if (index == 4){
        
        return WMWaitCommentTitle;
    }
    else{
        return nil;
    }
}

/**返回表格视图的配置类
 *@param 订单模型 WMOrderInfo
 *@param 配置数组 元素XTableCellConfigEx
 *return 配置类 XTableCellConfigEx
 */
+ (XTableCellConfigEx *)returnConfigureWithModel:(WMOrderInfo *)model configArr:(NSArray *)configArr indexPath:(NSIndexPath *)indexPath{
    
    //    _configureArr = @[orderIDConfig,orderGoodConfig,orderPriceConfig,orderWaitPayConfig,orderWaitReceiveConfig,orderBuyAgain,orderDead,prepareTime];

    if (indexPath.row == 0) {
        
        return [configArr firstObject];
    }
    else if (indexPath.row >= 1 && indexPath.row <= model.orderGoodsArr.count){
        
        return [configArr objectAtIndex:1];
    }
    else if (indexPath.row == model.orderGoodsArr.count + 1){
        
        return [configArr objectAtIndex:2];
    }
    else{
        
        if ([model.orderStatus isEqualToString:@"finish"]) {
            
            return [configArr objectAtIndex:5];
        }
        else if ([model.orderStatus isEqualToString:@"dead"]){
            
            return [configArr objectAtIndex:6];
        }
        else{
            
            if (model.isPrepareOrder) {
                
                if (model.status == OrderStatusWaitPay) {
                    
                    return [configArr objectAtIndex:3];
                }
                else if (model.status == OrderStatusPartPay){
                    
                    if (indexPath.row == model.orderGoodsArr.count + 2) {
                        
                        return [configArr lastObject];
                    }
                    else{
                        
                        return [configArr objectAtIndex:3];
                    }
                }
                else{
                    
                    return nil;
                }
            }
            else{
                
                if (model.status == OrderStatusWaitPay || model.status == OrderStatusPartPay) {
                    
                    return [configArr objectAtIndex:3];
                }
                else if (model.status == OrderStatusWaitSend){
                    
                    return [configArr objectAtIndex:5];
                }
                else if (model.status == OrderStatusWaitReceive || model.status == OrderStatusPartSend){
                    
                    return [configArr objectAtIndex:4];
                }
                else{
                    
                    return nil;
                }
            }
        }
    }
}

/**返回订单的每组的数目
 */
+ (NSInteger)returnOrderSectionRowNumberWith:(WMOrderInfo *)model{
        
    if (model.isPrepareOrder) {
        
        if (model.status == OrderStatusWaitPay) {
            
            return model.orderGoodsArr.count + 3;
        }
        else if (model.status == OrderStatusPartPay){

            if (model.prepareBeginTime.integerValue >= [WMServerTimeOperation sharedInstance].time) {
                
                return model.orderGoodsArr.count + 3;
            }
            
            return model.orderGoodsArr.count + 4;
        }
//        else if ([model.orderStatus isEqualToString:@"finish"] || [model.orderStatus isEqualToString:@"dead"]) {
//            
//            return model.orderGoodsArr.count + 2;
//        }
        else{
            
            return model.orderGoodsArr.count + 2;
        }
    }
    else{
        
        if (model.status == OrderStatusWaitPay || model.status == OrderStatusWaitReceive || model.status == OrderStatusPartPay || model.status == OrderStatusPartSend) {
            
            return model.orderGoodsArr.count + 3;
        }
        else if (model.status == OrderStatusWaitSend){
            
            return model.isInitPointOrder ? model.orderGoodsArr.count + 2 : model.orderGoodsArr.count + 3;
        }
        else  if ([model.orderStatus isEqualToString:@"finish"] || [model.orderStatus isEqualToString:@"dead"]) {
            
            return model.orderGoodsArr.count + 3;
        }
        else{
            
            return model.orderGoodsArr.count + 2;
        }
    }
}

/**确认订单 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnConfirmOrderParamWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.member.receive",@"order_id":orderID};
}

/**删除订单 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnDeleteOrderParamWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.order.dodelete",@"order_id":orderID};
}

/**取消订单 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnCancelOrderParamWithOrderID:(NSString *)orderID reasonType:(NSDictionary *)type{
  
    
    return @{WMHttpMethod:@"b2c.member.docancel",@"order_cancel_reason[order_id]":orderID,@"order_cancel_reason[reason_type]":[type sea_stringForKey:@"value"]};
}

/**再次购买 参数
 *@param 订单ID NSString
 */
+ (NSDictionary *)returnBuyAgainParamWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"b2c.member.reAddCart",@"order_id":orderID};
}

/**确认订单和取消订单、删除订单等订单操作 结果
 *retrun Bool
 */
+ (BOOL)orderActionWithData:(NSData *)data{

    NSDictionary *dataDict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dataDict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dataDict alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取取消订单的原因 参数
 */
+ (NSDictionary *)returnCancelOrderReasonParam{
    
    return @{WMHttpMethod:@"b2c.member.order_cancel_reason"};
}
/**获取取消订单的原因 结果
 *@return 原因数组--元素NSDictionary
 */
+ (NSArray *)returnCancelOrderReasonArrsWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [dict arrayForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**返回商品名称属性字符串
 */
+ (NSAttributedString *)returnGoodAttrNameWithType:(OrderGoodType)type goodName:(NSString *)goodName{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    switch (type) {
        case OrderGoodTypeNormal:
        case OrderGoodTypePoint:
        {
            
        }
            break;
        case OrderGoodTypeNormalAdjunct:
        {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            
            textAttachment.image = [UIImage imageNamed:@"adjunct_good_tag"];
            
            [attrString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            
            [attrString addAttributes:@{NSBaselineOffsetAttributeName:@(-3)} range:NSMakeRange(0, 1)];
        }
            break;
        case OrderGoodTypeNormalGift:
        case OrderGoodTypeOrderGift:
        {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            
            textAttachment.image = [UIImage imageNamed:@"gift_tag"];
            
            [attrString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            
            [attrString addAttributes:@{NSBaselineOffsetAttributeName:@(-3)} range:NSMakeRange(0, 1)];
        }
            break;
        default:
        {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            
            textAttachment.image = [UIImage imageNamed:@"prepare_tag"];
            
            [attrString appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            
            [attrString addAttributes:@{NSBaselineOffsetAttributeName:@(-3)} range:NSMakeRange(0, 1)];
        }
            break;
    }
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",goodName]]];
    
    return attrString;
}



@end
