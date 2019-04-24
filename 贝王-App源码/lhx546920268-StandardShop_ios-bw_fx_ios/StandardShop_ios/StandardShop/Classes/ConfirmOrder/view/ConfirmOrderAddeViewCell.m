//
//  ConfirmOrderAddeViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderAddeViewCell.h"

#import "WMAddressInfo.h"

@implementation ConfirmOrderAddeViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderAddrLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    _orderNameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _orderMobileLabel.titleLabel.font = [UIFont fontWithName:MainNumberFontName size:14];
    
    _orderNameLabel.titleLabel.font = [UIFont fontWithName:MainFontName size:15];
}

- (void)configureCellWithModel:(id)model{
    
    WMAddressInfo *addressInfo = [model objectForKey:@"info"];
    
    _arrowImage.hidden = [[model numberForKey:@"hidden"] boolValue];
    
    [_orderNameLabel setTitle:addressInfo.addressName forState:UIControlStateNormal];
    
    _orderAddrLabel.text = addressInfo.addressDetail;
    
    [_orderMobileLabel setTitle:addressInfo.addressMobile forState:UIControlStateNormal];
}
@end
