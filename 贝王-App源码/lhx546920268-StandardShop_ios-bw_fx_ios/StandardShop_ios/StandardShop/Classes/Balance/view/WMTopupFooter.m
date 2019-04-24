//
//  WMTopupFooter.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupFooter.h"

@implementation WMTopupFooter

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, WMTopupFooterHeight)];
    if(self)
    {
        CGFloat margin = 15.0;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];

        _topupButton = [UIButton buttonWithType:UIButtonTypeCustom];

        CGFloat width = 100.0;
        CGFloat height = 32.0;
        _topupButton.frame = CGRectMake(self.width - width - margin, (self.height - height) / 2.0, width, height);
        [_topupButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_topupButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
        _topupButton.backgroundColor = WMButtonBackgroundColor;
        _topupButton.layer.cornerRadius = height / 2.0;
        _topupButton.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
        [self addSubview:_topupButton];
        
        NSString *title = @"实付：";
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, [title stringSizeWithFont:font contraintWith:self.width].width, self.height)];
        label.text = title;
        label.font = font;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];

        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.right, 0, _topupButton.left - label.right, self.height)];
        _amountLabel.textColor = WMPriceColor;
        _amountLabel.font = [UIFont fontWithName:MainNumberFontName size:17.0];
        [self addSubview:_amountLabel];
    }

    return self;
}

@end
