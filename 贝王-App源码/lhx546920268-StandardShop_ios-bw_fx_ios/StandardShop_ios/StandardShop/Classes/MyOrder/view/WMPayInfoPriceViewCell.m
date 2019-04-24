//
//  WMPayInfoPriceViewCell.m
//  WestMailDutyFee
//
//  Created by qsit on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPayInfoPriceViewCell.h"

@implementation WMPayInfoPriceViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)configureCellWithModel:(id)model{
    
    if ([model isKindOfClass:[NSString class]]) {
        
        NSString *price = (NSString *)model;
        
        _priceLabel.attributedText = [self createAttrWithHeaderStr:@"订单金额:" contentStr:price];
    }
    else{
        
        NSNumber *index = [model objectForKey:@"is_orderID"];
        
        NSString *content = [model objectForKey:@"content"];
        
        BOOL isCombinationPay = [[model numberForKey:@"isCombination"] boolValue];
        
        if (index.integerValue) {
            
            _priceLabel.attributedText = [self createAttrWithHeaderStr:isCombinationPay ? @"您可以选择其他支付方式支付剩余金额" : @"订单金额:" contentStr:content];
        }
        else{
            
            _priceLabel.attributedText = [self createAttrWithHeaderStr:isCombinationPay ? @"已用余额支付": @"订单编号:" contentStr:content];
        }
    }
}
- (NSMutableAttributedString *)createAttrWithHeaderStr:(NSString *)headerStr contentStr:(NSString *)contentStr{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",headerStr,contentStr]];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0]} range:[attr.string rangeOfString:headerStr]];
    
    [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:15.0],NSForegroundColorAttributeName:WMPriceColor} range:[attr.string rangeOfString:contentStr]];
    
    return attr;
    
}
@end
