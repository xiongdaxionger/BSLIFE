//
//  WMDistributionHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDistributionHeaderView.h"
#import "WMDistributionInfo.h"
#import "WMBillListManagerViewController.h"

@implementation WMDistributionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.balance_label.font = [UIFont fontWithName:MainNumberFontName size:35.0];
    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.bill_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];

    [self.bill_btn setButtonIconToRightWithInterval:5.0];
    self.backgroundColor = WMRedColor;
}

- (void)setInfo:(WMDistributionInfo*) info
{
    _info = info;

    self.balance_label.text = _info.cur_earnings;
}

///账单
- (IBAction)billAction:(id)sender
{
    WMBillListManagerViewController *bill = [[WMBillListManagerViewController alloc] init];
    UINavigationController *nav = [bill createdInNavigationController];

    SeaPresentTransitionDelegate *delegate = [[SeaPresentTransitionDelegate alloc] init];
    nav.sea_transitioningDelegate = delegate;
    [self.navigationController presentViewController:nav animated:YES completion:^(void){

        [delegate addInteractiveTransitionToViewController:bill];
    }];
}
@end
