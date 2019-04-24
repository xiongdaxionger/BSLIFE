//
//  WMOrderIDViewCell.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderIDViewCell.h"
#import "WMOrderInfo.h"

@implementation WMOrderIDViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _orderIDLabel.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _orderStatusLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _orderStatusLabel.textColor = WMPriceColor;
    
    _orderIDLabel.userInteractionEnabled = NO;
    
    _orderIDLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _orderStatusLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)configureCellWithModel:(id)model{
    
    _orderIDWidth.constant = 180.0;

    if ([model isKindOfClass:[WMOrderInfo class]]) {
        
        _orderStatusLabel.hidden = NO;
        
        WMOrderInfo *viewModel = (WMOrderInfo *)model;
        
        _orderStatusLabel.text = viewModel.orderStatusTitle;
        
        if (viewModel.isPrepareOrder) {
            
            [_orderIDLabel setTitle:[NSString stringWithFormat:@"订单号:%@",viewModel.orderID] forState:UIControlStateNormal];
            
        }
        else{
            
            [_orderIDLabel setTitle:[NSString stringWithFormat:@"订单号:%@",viewModel.orderID] forState:UIControlStateNormal];

            [_orderIDLabel setImage:nil forState:UIControlStateNormal];
        }
    }
    else{
        
        _orderStatusLabel.hidden = YES;
        
        NSString *orderID = (NSString *)model;
        
        [_orderIDLabel setTitle:[NSString stringWithFormat:@"订单号:%@",orderID] forState:UIControlStateNormal];
    }
    
}

@end
