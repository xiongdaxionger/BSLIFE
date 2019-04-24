//
//  WMRefundOrderDetailModel.m
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundOrderDetailModel.h"
#import "WMRefundGoodModel.h"

@implementation WMRefundOrderDetailModel

+ (instancetype)createViewModelWithRefundDetailDict:(NSDictionary *)dict{
    
    WMRefundOrderDetailModel *orderModel = [WMRefundOrderDetailModel new];
    
    orderModel.orderID = [dict sea_stringForKey:@"order_id"];
    
    orderModel.orderGoodsArr = [WMRefundGoodModel returnRefundRecordGoodModelsArrWithDictsArr:[dict arrayForKey:@"goods_items"]];
    
    NSArray *typeDict = [dict arrayForKey:@"refund_type"];
    
    NSMutableArray *typeArr = [NSMutableArray new];
    
    if (typeDict.count) {
        
        for (NSInteger i = 0; i < typeDict.count; i++) {
            
            NSMutableDictionary *type = [NSMutableDictionary new];
            
            NSDictionary *typeOldDict = [typeDict objectAtIndex:i];
            
            [type setObject:[typeOldDict sea_stringForKey:@"name"] forKey:@"typeName"];
            
            [type setObject:[typeOldDict sea_stringForKey:@"value"] forKey:@"typeID"];
            
            if (i == 0) {
                
                [type setObject:@(YES) forKey:@"isSelect"];
            }
            else{
                
                [type setObject:@(NO) forKey:@"isSelect"];
            }
            
            [typeArr addObject:type];
        }
    }
    
    orderModel.refundGoodType = typeArr;
    
    return orderModel;
}
@end
