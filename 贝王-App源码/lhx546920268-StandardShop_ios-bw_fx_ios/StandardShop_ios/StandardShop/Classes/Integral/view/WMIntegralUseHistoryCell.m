//
//  MYsoureTableViewCell.m
//  WuMei
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMIntegralUseHistoryCell.h"
#import "WMIntegralInfo.h"

@implementation WMIntegralUseHistoryCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _time_label.font =[UIFont fontWithName:MainNumberFontName size:13.0];
    _content_label.font = [UIFont fontWithName:MainFontName size:14.0];
    
    _time_label.textColor = [UIColor grayColor];
    _content_label.textColor = [UIColor grayColor];
    _line.backgroundColor = _separatorLineColor_;
    _lineHeightConstraint.constant = _separatorLineWidth_;
    
    _integral_btn.backgroundColor = WMRedColor;
    [_integral_btn setTintColor:WMButtonTitleColor];
    [_integral_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    _integral_btn.layer.masksToBounds = YES;
    _integral_btn.layer.cornerRadius = 9.0;
}

- (void)setInfo:(WMIntegralHistoryInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        _content_label.text = _info.reason;
        _time_label.text = _info.time;
        
        if ([_info.integral longLongValue] > 0)
        {
            [_integral_btn setTitle:[NSString stringWithFormat:@" +%@分", _info.integral] forState:UIControlStateNormal];
        }
        else
        {
             [_integral_btn setTitle:[NSString stringWithFormat:@" %@分", _info.integral] forState:UIControlStateNormal];
        }

        if(_info.integralWidth == 0)
        {
            _info.integralWidth = [[_integral_btn titleForState:UIControlStateNormal] stringSizeWithFont:_integral_btn.titleLabel.font contraintWith:_width_].width + 30;
        }
        
        _integral_btn_widthConstraint.constant = _info.integralWidth;
        
    }
}


@end
