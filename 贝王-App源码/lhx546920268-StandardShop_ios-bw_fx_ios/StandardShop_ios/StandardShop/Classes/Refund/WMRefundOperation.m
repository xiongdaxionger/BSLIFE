//
//  WMRefundOperation.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundOperation.h"

#import "WMUserOperation.h"
#import "WMRefundMoneyRecordModel.h"
#import "WMRefundGoodRecordModel.h"
#import "WMRefundOrderDetailModel.h"
#import "WMRefundGoodModel.h"
#import "XTableCellConfigEx.h"

#import "WMRefundInfoViewCell.h"
#import "WMRefundButtonViewCell.h"

@implementation WMRefundOperation

#pragma mark - new

/**保存退款单快递信息 参数
 */
+ (NSDictionary *)returnSaveDeliveryInfoWithCompanyName:(NSString *)companyName deliveryNumber:(NSString *)number orderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"aftersales.aftersales.save_return_delivery",@"crop_code":companyName,@"crop_no":number,@"return_id":orderID};
}
/**保存退款单快递信息 结果
 */
+ (NSDictionary *)returnSaveDeliveryInfoResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [dict dictionaryForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**返回退换货记录每组的行数
 */
+ (NSInteger)returnRefundGoodRecordSectionNumber:(WMRefundGoodRecordModel *)goodRecordModel{
    
    if (goodRecordModel.comment) {
        
        if (goodRecordModel.canInputDelivery) {
            
            return 4 + goodRecordModel.goodsArr.count;
        }
        else{
            
            return [NSString isEmpty:goodRecordModel.deliveryCompany] ? 4 + goodRecordModel.goodsArr.count : 5 + goodRecordModel.goodsArr.count;
        }
    }
    else{
        
        if (goodRecordModel.canInputDelivery) {
            
            return 3 + goodRecordModel.goodsArr.count;
        }
        else{
            
            return [NSString isEmpty:goodRecordModel.deliveryCompany] ? 3 + goodRecordModel.goodsArr.count : 4 + goodRecordModel.goodsArr.count;
        }
    }
}

/**返回退换货记录的配置类
 */
+ (XTableCellConfigEx *)returnRefundGoodRecordConfigWith:(WMRefundGoodRecordModel *)goodRecordModel indexPath:(NSInteger)index configArr:(NSArray *)configArr{
    
    //_configureArr = @[orderID,orderGood,refundButton,commonInfo];

    if (index == 0) {
        
        return [configArr firstObject];
    }
    else if (index >= 1 && index <= goodRecordModel.goodsArr.count){
        
        return [configArr objectAtIndex:1];
    }
    
    if (goodRecordModel.comment) {
        
        if (goodRecordModel.canInputDelivery) {
            
            if (index >= goodRecordModel.goodsArr.count + 1 && index <= goodRecordModel.goodsArr.count + 2) {
                
                return [configArr lastObject];
            }
            else{
                
                return [configArr objectAtIndex:2];
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index >= goodRecordModel.goodsArr.count + 1 && index <= goodRecordModel.goodsArr.count + 3) {
                    
                    return [configArr lastObject];
                }
                else{
                    
                    return [configArr objectAtIndex:2];
                }
            }
            else{
                
                if (index >= goodRecordModel.goodsArr.count + 1 && index <= goodRecordModel.goodsArr.count + 2) {
                    
                    return [configArr lastObject];
                }
                else{
                    
                    return [configArr objectAtIndex:2];
                }
            }
        }
    }
    else{
        
        if (goodRecordModel.canInputDelivery) {
            
            if (index == goodRecordModel.goodsArr.count + 1) {
                
                return [configArr lastObject];
            }
            else{
                
                return [configArr objectAtIndex:2];
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index >= goodRecordModel.goodsArr.count + 1 && index <= goodRecordModel.goodsArr.count + 2) {
                    
                    return [configArr lastObject];
                }
                else{
                    
                    return [configArr objectAtIndex:2];
                }
            }
            else{
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return [configArr lastObject];
                }
                else{
                    
                    return [configArr objectAtIndex:2];
                }
            }
        }
    }
    
    return nil;
}
/**返回退换记录每行高度
 */
+ (CGFloat)returnRefundGoodRecordCellHeightWithIndex:(NSInteger)index goodRecordModel:(WMRefundGoodRecordModel *)goodRecordModel{
    
    CGFloat commmentHeight = MAX(WMRefundInfoViewCellHeight, [goodRecordModel.comment boundsWithConstraintWidth:_width_ - 16].height + WMRefundInfoViewCellHeight - 21);
    
    CGFloat resaonHeight = MAX(WMRefundInfoViewCellHeight, [goodRecordModel.reason boundsWithConstraintWidth:_width_ - 16].height + WMRefundInfoViewCellHeight - 21);
    
    CGFloat deliveryHeight = MAX(WMRefundInfoViewCellHeight, [goodRecordModel.delivery boundsWithConstraintWidth:_width_ - 16].height + WMRefundInfoViewCellHeight - 21);
    
    if (goodRecordModel.comment) {
        
        if (goodRecordModel.canInputDelivery) {
                
            if (index == goodRecordModel.goodsArr.count + 1) {
                
                return commmentHeight;
            }
            else if (index == goodRecordModel.goodsArr.count + 2){
                
                return resaonHeight;
            }
            else{
                
                return WMRefundButtonViewCellHeight;
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return commmentHeight;
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return resaonHeight;
                }
                else if (index == goodRecordModel.goodsArr.count + 3){
                    
                    return deliveryHeight;
                }
                else{
                    
                    return WMRefundButtonViewCellHeight;
                }
            }
            else{
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return commmentHeight;
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return resaonHeight;
                }
                else{
                    
                    return WMRefundButtonViewCellHeight;
                }
            }
        }
    }
    else{
        
        if (goodRecordModel.canInputDelivery) {
            
            if (index == goodRecordModel.goodsArr.count + 1) {
                
                return resaonHeight;
            }
            else{
                
                return WMRefundButtonViewCellHeight;
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return resaonHeight;
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return deliveryHeight;
                }
                else{
                    
                    return WMRefundButtonViewCellHeight;
                }
            }
            else{
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return resaonHeight;
                }
                else{
                    
                    return WMRefundButtonViewCellHeight;
                }
            }
        }
    }
    
    return 0;
}
/**返回退换记录的模型
 */
+ (id)returnRefundGoodRecordModelWithIndex:(NSInteger)index goodRecordModel:(WMRefundGoodRecordModel *)goodRecordModel controller:(SeaTableViewController *)controller{
    
    if (index == 0) {
        
        return goodRecordModel.orderID;
    }
    else if (index >= 1 && index <= goodRecordModel.goodsArr.count){
        
        return [goodRecordModel.goodsArr objectAtIndex:index - 1];
    }
    
    if (goodRecordModel.comment) {
        
        if (goodRecordModel.canInputDelivery) {
                
            if (index == goodRecordModel.goodsArr.count + 1) {
                
                return @{@"title":@"店主反馈",@"content":goodRecordModel.comment};
            }
            else if (index == goodRecordModel.goodsArr.count + 2){
                
                return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
            }
            else{
                
                return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return @{@"title":@"店主反馈",@"content":goodRecordModel.comment};
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
                }
                else if (index == goodRecordModel.goodsArr.count + 3){
                    
                    return @{@"title":@"快递信息",@"content":goodRecordModel.delivery};
                }
                else{
                    
                    return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
                }
            }
            else{
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return @{@"title":@"店主反馈",@"content":goodRecordModel.comment};
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
                }
                else{
                    
                    return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
                }
            }
        }
    }
    else{
        
        if (goodRecordModel.canInputDelivery) {
            
            if (index == goodRecordModel.goodsArr.count + 1) {
                
                return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
            }
            else{
                
                return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
            }
        }
        else{
            
            if (goodRecordModel.deliveryCompany) {
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
                }
                else if (index == goodRecordModel.goodsArr.count + 2){
                    
                    return @{@"title":@"快递信息",@"content":goodRecordModel.delivery};
                }
                else{
                    
                    return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
                }
            }
            else{
                
                if (index == goodRecordModel.goodsArr.count + 1) {
                    
                    return @{@"title":@"退换理由",@"content":goodRecordModel.reason};
                }
                else{
                    
                    return @{@"model":goodRecordModel,@"controller":controller,@"isRecord":@(YES)};
                }
            }
        }
    }
    
    return nil;
}

/**返回退款记录每组的行数
 */
+ (NSInteger)returnRefundMoneyRecordSectionNumber:(WMRefundMoneyRecordModel *)moneyRecordModel{
    
    if (moneyRecordModel.comment) {
        
        return moneyRecordModel.goodsArr.count + 4;
    }
    else{
        
        return moneyRecordModel.goodsArr.count + 3;
    }
}
/**返回退款记录的配置类
 */
+ (XTableCellConfigEx *)returnRefundMoneyRecordConfigWith:(WMRefundMoneyRecordModel *)moneyRecordModel indexPath:(NSInteger)index configArr:(NSArray *)configArr{
    
    //    _configureArr = @[orderID,orderGood,refundInfo,refundButton];
    
    if (index == 0) {
        
        return [configArr firstObject];
    }
    else if (index >= 1 && index <= moneyRecordModel.goodsArr.count){
        
        return [configArr objectAtIndex:1];
    }
    
    if (moneyRecordModel.comment) {
        
        if (index >= moneyRecordModel.goodsArr.count + 1 && index <= moneyRecordModel.goodsArr.count + 2) {
            
            return [configArr objectAtIndex:2];
        }
        else{
            
            return [configArr lastObject];
        }
    }
    else{
        
        if (index == moneyRecordModel.goodsArr.count + 1) {
            
            return [configArr objectAtIndex:2];
        }
        else{
            
            return [configArr lastObject];
        }
    }
}
/**返回退款记录的模型
 */
+ (id)returnRefundMoneyRecordModelWithIndex:(NSInteger)index moneyRecordModel:(WMRefundMoneyRecordModel *)moneyRecordModel{
    
    if (index == 0) {
        
        return moneyRecordModel.orderID;
    }
    else if (index >= 1 && index <= moneyRecordModel.goodsArr.count){
        
        return [moneyRecordModel.goodsArr objectAtIndex:index - 1];
    }
    
    if (moneyRecordModel.comment) {
        
        if (index == moneyRecordModel.goodsArr.count + 1) {
            
            return @{@"title":@"店主反馈",@"content":moneyRecordModel.comment};
        }
        else if (index == moneyRecordModel.goodsArr.count + 2){
            
            return @{@"title":@"退款理由",@"content":moneyRecordModel.reason};
        }
        else{
            
            return moneyRecordModel.status;
        }
    }
    else{
        
        if (index == moneyRecordModel.goodsArr.count + 1) {
            
            return @{@"title":@"退款理由",@"content":moneyRecordModel.reason};
        }
        else{
            
            return moneyRecordModel.status;
        }
    }
}
/**返回退款记录每行高度
 */
+ (CGFloat)returnRefundMoneyRecordCellHeightWithIndex:(NSInteger)index moneyRecordModel:(WMRefundMoneyRecordModel *)moneyRecordModel{
    
    CGFloat commmentHeight = MAX(WMRefundInfoViewCellHeight, [moneyRecordModel.comment boundsWithConstraintWidth:_width_ - 16].height + WMRefundInfoViewCellHeight - 21);
    
    CGFloat resaonHeight = MAX(WMRefundInfoViewCellHeight, [moneyRecordModel.reason boundsWithConstraintWidth:_width_ - 16].height + WMRefundInfoViewCellHeight - 21);
    
    if (moneyRecordModel.comment) {
        
        if (index == moneyRecordModel.goodsArr.count + 1) {
            
            return commmentHeight;
        }
        else if (index == moneyRecordModel.goodsArr.count + 2){
            
            return resaonHeight;
        }
        else{
            
            return WMRefundButtonViewCellHeight;
        }
    }
    else{
        
        if (index == moneyRecordModel.goodsArr.count + 1) {
            
            return resaonHeight;
        }
        else{
            
            return WMRefundButtonViewCellHeight;
        }
    }
}

/**申请订单退款 参数
 */
+ (NSDictionary *)returnRefundMoneyOrderDetailWithOrderID:(NSString *)orderID{
    
    return @{WMHttpMethod:@"mobileapi.aftersales.paymentcancel",@"order_id":orderID};
}

/**获取退款/退换订单列表 参数
 *@param 类型 type--退换货(reship)/退款(refund)
 */
+ (NSDictionary *)returnRefundOrderParamWithPage:(NSInteger)page type:(NSString *)type{
    
    return @{WMHttpMethod:@"aftersales.aftersales.afterlist",@"type":type,WMHttpPageIndex:@(page)};
}

/**申请订单退换 参数
 */
+ (NSDictionary *)returnRefundOrderDetailWithOrderID:(NSString *)orderID type:(NSString *)type{
    
    return @{WMHttpMethod:@"aftersales.aftersales.add",@"order_id":orderID,@"type":type};
}
/**申请订单退款/退换 结果
 */
+ (WMRefundOrderDetailModel *)returnRefundOrderDetailModelWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [WMRefundOrderDetailModel createViewModelWithRefundDetailDict:[dict dictionaryForKey:WMHttpData]];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}


/**提交退换/退款 参数
 *@param 退换/退款理由
 *@param 退换/退款详细原因
 *@param 退换订单
 *@param 订单ID
 *@param 类型 type--退换货(reship)/退款(refund)
 *@param 退货图片--元素是NSString
 */
+ (NSDictionary *)returnCommitRefundOrderWith:(NSString *)reason detailReason:(NSString *)detailReason orderModel:(WMRefundOrderDetailModel *)orderModel type:(NSString *)type imagesArr:(NSArray *)imagesArr{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"aftersales.aftersales.return_save" forKey:WMHttpMethod];
    
    [param setObject:orderModel.orderID forKey:@"order_id"];
    
    [param setObject:reason forKey:@"title"];
    
    if (imagesArr && imagesArr.count) {
        
        for (NSInteger i = 0; i < imagesArr.count; i++) {
            
            NSString *image = [imagesArr objectAtIndex:i];
            [param setObject:image forKey:[NSString stringWithFormat:@"file[%ld]", (long)i]];
        }
    }
    
//    [param setObject:type forKey:@"type"];
    
    if (detailReason) {
        
        [param setObject:detailReason forKey:@"content"];
    }
    
    for (WMRefundGoodModel *goodModel in orderModel.orderGoodsArr) {

        if (goodModel.isSelect) {

            [param setObject:goodModel.bnCode forKey:[NSString stringWithFormat:@"product_bn[%@]",goodModel.productID]];
            
            [param setObject:goodModel.refundFinalCount forKey:[NSString stringWithFormat:@"product_nums[%@]",goodModel.productID]];
            
            [param setObject:goodModel.name forKey:[NSString stringWithFormat:@"product_name[%@]",goodModel.productID]];
            
            [param setObject:goodModel.salePrice forKey:[NSString stringWithFormat:@"product_price[%@]",goodModel.productID]];
        }
    }
    
    for (NSDictionary *dict in orderModel.refundGoodType) {
        
        NSNumber *isSelect = [dict numberForKey:@"isSelect"];
        
        if (isSelect.boolValue) {
            
            [param setObject:[dict sea_stringForKey:@"typeID"] forKey:@"type"];
            
            break;
        }
    }
    
    [param setObject:@"on" forKey:@"agree"];
    
    return param;
}

/**提交退款/退换 结果
 */
+ (BOOL)returnCommitRefundOrderResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**返回退换货记录 参数
 *@param 类型 type--退换货(reship)/退款(refund)
 */
+ (NSDictionary *)returnRefundRecordParamWithPageNumber:(NSInteger)page type:(NSString *)type{
    
    return @{WMHttpMethod:@"aftersales.aftersales.afterrec",WMHttpPageIndex:@(page),@"type":type};
}
/**返回退款记录 结果
 *return 数组元素--WMRefundMoneyRecordModel
 *return 记录总数
 */
+ (NSDictionary *)returnRefundMoneyRecordsArrWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        long long count = [WMUserOperation totalSizeFromDictionary:dataDict];
        
        NSArray *orderInfosArr = [WMRefundMoneyRecordModel returnRefundMoneyRecordModelArrWithDictArr:[dataDict arrayForKey:@"return_list"]];
        
        return @{@"info":orderInfosArr,@"count":@(count)};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**返回退货记录 结果
 *return 数组元素--WMRefundGoodRecordModel
 *return 快递数组--NSString
 *return 记录总数
 */
+ (NSDictionary *)returnRefundGoodRecordsArrWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        long long count = [WMUserOperation totalSizeFromDictionary:dataDict];
        
        NSArray *orderInfosArr = [WMRefundGoodRecordModel returnRefundGoodRecordModelArrWithDictArr:[dataDict arrayForKey:@"return_list"]];
        
        return @{@"info":orderInfosArr,@"count":@(count),@"delivery":[dataDict arrayForKey:@"dlycorp"]};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**售后须知文章 参数
 */
+ (NSDictionary *)returnRefundReadMessageParam{
    
    return @{WMHttpMethod:@"aftersales.aftersales.read"};
}
/**售后须知文章 结果
 *@return 售后须知的html
 */
+ (NSString *)returnRefundReadMessageResult:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [[dict dictionaryForKey:WMHttpData] sea_stringForKey:@"comment"];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}


@end
