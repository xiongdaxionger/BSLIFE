//
//  WMOrderCreateTimeViewCell.m
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderCreateTimeViewCell.h"

#import "WMOrderDetailInfo.h"
@implementation WMOrderCreateTimeViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderTimeLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _orderTimeLabel.textColor = MainTextColor;
    
    _orderPayTimeLabel.font = _orderTimeLabel.font;
    
    _orderPayTimeLabel.textColor = MainTextColor;
}


- (void)configureCellWithModel:(id)model{
    
    WMOrderDetailInfo *viewModel = (WMOrderDetailInfo *)model;
    
    _orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",viewModel.orderCreateTime];
    
    _orderPriceLabel.attributedText = viewModel.priceAttrString;
    
    _orderPayTimeLabel.text = [NSString isEmpty:viewModel.orderPayTime] ? @"" : [NSString stringWithFormat:@"支付时间：%@",viewModel.orderPayTime];
}










@end
