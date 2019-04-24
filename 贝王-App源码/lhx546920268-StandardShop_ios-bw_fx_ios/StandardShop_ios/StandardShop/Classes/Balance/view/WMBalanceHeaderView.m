//
//  WMBalanceHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceHeaderView.h"
#import "WMBillListManagerViewController.h"
#import "WMBalanceInfo.h"

@implementation WMBalanceHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.balance_label.font = [UIFont fontWithName:MainNumberFontName size:35.0];
    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.bill_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];
    self.commission_label.font = [UIFont fontWithName:MainFontName size:17.0];

    [self.bill_btn setButtonIconToRightWithInterval:5.0];
    self.backgroundColor = WMRedColor;
}

- (void)setInfo:(WMBalanceInfo*) info
{
    _info = info;

    self.title_label.text = [NSString stringWithFormat:@"贝壳（%@）", info.moneySymbol];
    self.balance_label.text = _info.balance;

    self.commission_label.text = [NSString stringWithFormat:@"当前佣金：%@", _info.commission];
    self.commission_label.hidden = !_info.showCommission;
}

///账单
- (IBAction)billAction:(id)sender
{
    WMBillListManagerViewController *bill = [[WMBillListManagerViewController alloc] init];
    UINavigationController *nav = [bill createdInNavigationController];
    nav.transitioningDelegate = self.presentTransitionDelegate;
    [self.navigationController presentViewController:nav animated:YES completion:^(void){

        [self.presentTransitionDelegate addInteractiveTransitionToViewController:bill];
    }];
}

@end
