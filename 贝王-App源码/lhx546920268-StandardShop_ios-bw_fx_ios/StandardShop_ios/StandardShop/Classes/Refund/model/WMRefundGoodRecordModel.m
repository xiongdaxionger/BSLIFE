//
//  WMRefundGoodRecordModel.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundGoodRecordModel.h"

#import "WMRefundGoodModel.h"

@implementation WMRefundGoodRecordModel

+ (NSArray *)returnRefundGoodRecordModelArrWithDictArr:(NSArray *)dataArr{
    
    NSMutableArray *modelArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dataArr) {
        
        WMRefundGoodRecordModel *recordModel = [WMRefundGoodRecordModel new];
        
        recordModel.orderID = [dict sea_stringForKey:@"order_id"];
        
        recordModel.refundID = [dict sea_stringForKey:@"return_id"];
        
        recordModel.refundReason = [dict sea_stringForKey:@"title"];
        
        recordModel.refundDetail = [dict sea_stringForKey:@"content"];
        
        NSArray *comment = [dict arrayForKey:@"comment"];
        
        NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
                
        [paragarphStyle setLineSpacing:4];
        
        NSString *contentString;
        
        if (![NSString isEmpty:recordModel.refundDetail]) {
            
            contentString = [NSString stringWithFormat:@"%@\n%@",recordModel.refundReason,recordModel.refundDetail];
        }
        else{
            
            contentString = [NSString stringWithFormat:@"%@",recordModel.refundReason];
        }
        
        UIFont *font = [UIFont fontWithName:MainFontName size:13.0];
        
        NSMutableAttributedString *reasonString = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        if ([reasonString.string stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height > font.lineHeight) {
            
            [reasonString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [reasonString.string length])];
        }
        
        [reasonString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [reasonString.string length])];
        
        recordModel.reason = reasonString;
        
        NSMutableString *string = [NSMutableString new];
        
        if (comment.count && comment) {
            
            for (NSDictionary *dict in comment) {
                
                NSString *timeString = [NSDate formatTimeInterval:[dict sea_stringForKey:@"time"] format:DateFormatYMdHm];
                
                NSString *content = [dict sea_stringForKey:@"content"];
                
                NSInteger index = [comment indexOfObject:dict];
                
                if (index != comment.count - 1) {
                    
                    [string appendString:[NSString stringWithFormat:@"%@\n%@\n",timeString,content]];
                }
                else{
                    
                    [string appendString:[NSString stringWithFormat:@"%@\n%@",timeString,content]];
                }
            }
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [string length])];
            
            [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13],NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [string length])];
            
            recordModel.comment = attrString;
        }
        else{
            
            recordModel.comment = nil;
        }
        
        recordModel.goodsArr = [WMRefundGoodModel returnRefundRecordGoodModelsArrWithDictsArr:[dict arrayForKey:@"product_data"]];
        
        id deliveryData = [dict objectForKey:@"delivery_data"];
        
        if ([deliveryData isKindOfClass:[NSDictionary class]]) {
            
            recordModel.deliveryCompany = [deliveryData sea_stringForKey:@"crop_code"];
            
            recordModel.deliveryNumber = [deliveryData sea_stringForKey:@"crop_no"];
            
            NSMutableAttributedString *deliverString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"快递公司:%@\n快递单号:%@",recordModel.deliveryCompany,recordModel.deliveryNumber]];
            
            [deliverString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [deliverString.string length])];
            
            [deliverString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13],NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [deliverString.string length])];
            
            recordModel.delivery = deliverString;
        }
        else{
            
            recordModel.deliveryCompany = nil;
            
            recordModel.deliveryNumber = nil;
            
            recordModel.delivery = nil;
        }
        
        recordModel.status = [dict sea_stringForKey:@"status"];
        
        recordModel.canInputDelivery = [[dict numberForKey:@"delivery_status"] boolValue];
        
        [modelArr addObject:recordModel];
    }
    
    return modelArr;
}

- (void)changeCropInfoWithDict:(NSDictionary *)dict{
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragarphStyle setLineSpacing:4];
    
    self.deliveryCompany = [dict sea_stringForKey:@"crop_code"];
    
    self.deliveryNumber = [dict sea_stringForKey:@"crop_no"];
    
    NSMutableAttributedString *deliverString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"快递公司:%@\n快递单号:%@",[dict sea_stringForKey:@"crop_code"],[dict sea_stringForKey:@"crop_no"]]];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:13.0];
    
    if ([deliverString.string stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height > font.lineHeight) {
        
        [deliverString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [deliverString.string length])];
    }
    
    [deliverString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [deliverString.string length])];
    
    self.canInputDelivery = NO;
    
    self.delivery = deliverString;
}


@end
