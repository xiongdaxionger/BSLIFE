//
//  WMRefundMoneyRecordModel.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundMoneyRecordModel.h"

#import "WMRefundGoodModel.h"

@implementation WMRefundMoneyRecordModel

+ (NSArray *)returnRefundMoneyRecordModelArrWithDictArr:(NSArray *)dataArr{
    
    NSMutableArray *modelArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dataArr) {
        
        WMRefundMoneyRecordModel *model = [WMRefundMoneyRecordModel new];
        
        model.orderID = [dict sea_stringForKey:@"order_id"];
        
        model.recordID = [dict sea_stringForKey:@"return_id"];
        
        model.refundReason = [dict sea_stringForKey:@"title"];
        
        model.refundDetail = [dict sea_stringForKey:@"content"];
        
        model.goodsArr = [WMRefundGoodModel returnRefundRecordGoodModelsArrWithDictsArr:[dict arrayForKey:@"product_data"]];
        
        id comment = [dict arrayForKey:@"comment"];
        
        NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragarphStyle setLineSpacing:4];
        
        NSString *contentString;
        
        if (![NSString isEmpty:model.refundDetail]) {
            
            contentString = [NSString stringWithFormat:@"%@\n%@",model.refundReason,model.refundDetail];
        }
        else{
            
            contentString = [NSString stringWithFormat:@"%@",model.refundReason];
        }
        
        UIFont *font = [UIFont fontWithName:MainFontName size:13];
        
        NSMutableAttributedString *reasonString = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        if ([contentString stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height > font.lineHeight) {
            
            [reasonString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [reasonString.string length])];
        }
        
        [reasonString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [reasonString.string length])];
        
        model.reason = reasonString;
        
        NSMutableString *string = [NSMutableString new];
        
        if ([comment isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in comment) {
                
                NSString *timeString = [NSDate formatTimeInterval:[dict sea_stringForKey:@"time"] format:DateFormatYMdHm];
                
                NSString *content = [dict sea_stringForKey:@"content"];
                
                [string appendString:[NSString stringWithFormat:@"%@ %@\n",timeString,content]];
            }
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [string length])];
            
            [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13],NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [string length])];
            
            model.comment = attrString;
        }
        else{
            
            model.comment = nil;
        }
        
        model.status = [dict sea_stringForKey:@"status"];
        
        [modelArr addObject:model];
    }
    
    return modelArr;
}






@end
