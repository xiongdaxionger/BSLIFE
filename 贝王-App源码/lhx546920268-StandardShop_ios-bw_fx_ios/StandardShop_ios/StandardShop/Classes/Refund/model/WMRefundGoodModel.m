//
//  WMRefundGoodModel.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundGoodModel.h"
#import "WMPriceOperation.h"

@implementation WMRefundGoodModel

+ (NSArray *)returnRefundGoodModelArrWithDataArr:(NSArray *)dictArr{
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        WMRefundGoodModel *goodModel = [WMRefundGoodModel new];
        
        goodModel.bnCode = [dict sea_stringForKey:@"bn"];
        
        goodModel.name = [dict sea_stringForKey:@"name"];
        
        goodModel.num = [dict sea_stringForKey:@"quantity"];
        
        goodModel.refundFinalCount = goodModel.num;
        
        goodModel.image = [NSString isEmpty:[dict sea_stringForKey:@"thumbnail_pic"]] ? [dict sea_stringForKey:@"image_default_id"] : [dict sea_stringForKey:@"thumbnail_pic"];
        
        goodModel.salePrice = [dict sea_stringForKey:@"price"];

        goodModel.price = [WMPriceOperation formatPrice:goodModel.salePrice font:[UIFont fontWithName:MainFontName size:16.0]];
        
        goodModel.productID = [dict sea_stringForKey:@"product_id"];
        
        goodModel.formatPrice = [dict sea_stringForKey:@"price_format"];
        
        goodModel.specInfo = [NSString isEmpty:[dict sea_stringForKey:@"attr"]] ? @"" : [dict sea_stringForKey:@"attr"];
        
        [array addObject:goodModel];
    }
    
    return array;
}

+ (NSArray *)returnRefundRecordGoodModelsArrWithDictsArr:(NSArray *)dictArr{
    
    NSMutableArray *array = [NSMutableArray new];

    for (NSDictionary *dict in dictArr) {
        
        WMRefundGoodModel *goodModel = [WMRefundGoodModel new];
        
        goodModel.bnCode = [dict sea_stringForKey:@"bn"];
        
        goodModel.productID = [dict sea_stringForKey:@"product_id"];
        
        goodModel.image = [NSString isEmpty:[dict sea_stringForKey:@"thumbnail_pic"]] ? [dict sea_stringForKey:@"image_default_id"] : [dict sea_stringForKey:@"thumbnail_pic"];
        
        goodModel.num = [NSString isEmpty:[dict sea_stringForKey:@"num"]] ? [dict sea_stringForKey:@"quantity"] : [dict sea_stringForKey:@"num"];
        
        goodModel.salePrice = [dict sea_stringForKey:@"price"];
        
        goodModel.price = [WMPriceOperation formatPrice:goodModel.salePrice font:[UIFont fontWithName:MainFontName size:16.0]];
        
        goodModel.formatPrice = [dict sea_stringForKey:@"price_format"];
        
        goodModel.name = [dict sea_stringForKey:@"name"];
        
        goodModel.specInfo = [dict sea_stringForKey:@"attr"];
        
        goodModel.refundFinalCount = goodModel.num;
        
        [array addObject:goodModel];
    }
    
    return array;
}

@end
