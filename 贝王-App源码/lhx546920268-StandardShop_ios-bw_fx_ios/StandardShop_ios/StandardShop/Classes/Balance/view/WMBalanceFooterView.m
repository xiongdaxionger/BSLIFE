//
//  WMBalanceFooterView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceFooterView.h"
#import "WMBalanceInfo.h"

@implementation WMBalanceFooterView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.withdraw_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    self.withdraw_btn.backgroundColor = WMButtonBackgroundColor;
    self.withdraw_btn.layer.cornerRadius = 3.0;
    self.withdraw_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];

    self.topup_btn.titleLabel.font = self.withdraw_btn.titleLabel.font;
    self.topup_btn.layer.cornerRadius = self.withdraw_btn.layer.cornerRadius;
}

- (void)setInfo:(WMBalanceInfo *)info
{
    if(_info != info)
    {
        _info = info;
        CGFloat margin = 20.0;
        CGFloat width = 0;
        if(_info.enableWithdraw)
        {
            width = (_width_ - margin * 3) / 2;
            self.withdraw_btn_widthLayoutConstraint.constant = width;
            self.topup_btn_widthLayoutConstraint.constant = width;
            self.withdraw_btn.hidden = NO;
        }
        else
        {
            width = _width_ - margin * 2;
            self.withdraw_btn.hidden = YES;
            self.topup_btn_widthLayoutConstraint.constant = width;
        }
    }
}

///提现
- (IBAction)withdrawAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(balanceFooterViewDidWithdraw:)])
    {
        [self.delegate balanceFooterViewDidWithdraw:self];
    }
}

///充值
- (IBAction)topupAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(balanceFooterViewDidTopup:)])
    {
        [self.delegate balanceFooterViewDidTopup:self];
    }
}

@end
