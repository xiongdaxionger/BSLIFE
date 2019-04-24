//
//  WMBalanceListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceListCell.h"
#import "WMBalanceInfo.h"

@implementation WMBalanceListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.amount_label.font = [UIFont fontWithName:MainNumberFontName size:25.0];
    self.amount_label.textColor = WMPriceColor;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
}

- (void)setInfo:(WMBalanceListInfo *)info
{
    _info = info;

    self.title_label.text = _info.title;
    self.amount_label.text = _info.amount;
}

///点击问号
- (IBAction)questionAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:_info.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
    [alertView show];
}

@end
