//
//  WMShakeResultCouponsDialog.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeResultCouponsDialog.h"

@implementation WMShakeResultCouponsDialog

- (void)awakeFromNib
{
    [super awakeFromNib];
    
   // self.title_label.textColor = WMRedColor;
    self.title_label.font = [UIFont fontWithName:MainFontName size:20.0];
//    self.amount_label.font = [UIFont fontWithName:MainFontName size:30.0];
//    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.time_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.time_label.adjustsFontSizeToFitWidth = YES;
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.amount_label.adjustsFontSizeToFitWidth = YES;
    self.see_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:17.0];
    self.see_btn.layer.cornerRadius = 3.0;
    self.see_btn.layer.masksToBounds = YES;
    self.see_btn.layer.borderWidth = 2.0;
    self.see_btn.layer.borderColor = self.layer.borderColor;
    self.close_btn.backgroundColor = [UIColor colorWithCGColor:self.layer.borderColor];
    [self.close_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

///关闭弹窗
- (IBAction)closeAction:(id)sender
{
    self.hidden = YES;
    !self.closeHandler ?: self.closeHandler();
}

///立即查看
- (IBAction)seeAction:(id)sender
{
    !self.seeImmediatelyHandler ?: self.seeImmediatelyHandler();
    [self closeAction:nil];
}

- (void)setInfo:(WMShakeResultInfo *)info
{
    [super setInfo:info];
    self.time_label.text = [NSString stringWithFormat:@"%@-%@", info.couponsInfo.beginTime, info.couponsInfo.endTime];
    self.subtitle_label.text = [NSString stringWithFormat:@"已放入%@的%@账户", info.couponsHolder, appName()];
    self.amount_label.text = info.couponsInfo.name;
}

@end
