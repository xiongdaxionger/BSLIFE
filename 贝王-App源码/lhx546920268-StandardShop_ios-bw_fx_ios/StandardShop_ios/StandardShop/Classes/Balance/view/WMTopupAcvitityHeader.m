//
//  WMTopupAcvitityHeader.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupAcvitityHeader.h"

@implementation WMTopupAcvitityHeader

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, 50.0)];
    if(self)
    {
        CGFloat margin = 10.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 80.0, self.height)];
        _titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        _titleLabel.text = @"充值有礼";
        _titleLabel.width = [_titleLabel.text stringSizeWithFont:_titleLabel.font contraintWith:_width_].width;
        [self addSubview:_titleLabel];

        CGFloat height = 30.0;
        CGFloat width = 70.0;
        _topupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topupButton.frame = CGRectMake(self.width - width - margin, (self.height - height) / 2.0, width, height);
        _topupButton.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        _topupButton.backgroundColor = WMButtonBackgroundColor;
        [_topupButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
        _topupButton.layer.cornerRadius = 3.0;
        [_topupButton setTitle:@"立即充值" forState:UIControlStateNormal];
        [self addSubview:_topupButton];

        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.right + margin, 0, _topupButton.left - _titleLabel.right - margin * 2, self.height)];
        _textField.font = [UIFont fontWithName:MainFontName size:15.0];
        _textField.placeholder = @"请输入充值金额";
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.textColor = WMPriceColor;
        _textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(cut:)), NSStringFromSelector(@selector(paste:)), nil];
        [self addSubview:_textField];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
    }

    return self;
}

#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedNum:WMTopupInputLimitMax];
}

@end
