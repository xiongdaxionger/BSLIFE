//
//  WMTopupTableHeader.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMTopupTableHeader.h"
#import "WMTopupInfo.h"

@implementation WMTopupTableHeader

- (id)init
{
    WMTopupTableHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"WMTopupTableHeader" owner:nil options:nil] firstObject];
    header.width = _width_;
    header.height = 45.0;
    
    return header;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.account_title_label.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.account_textField.font = [UIFont fontWithName:MainNumberFontName size:15.0];
    self.account_textField.delegate = self;
    self.account_textField.textColor = WMPriceColor;
    
    self.account_textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(cut:)), NSStringFromSelector(@selector(paste:)), nil];

    self.account_textField.placeholder = @"请输入充值金额";
}

#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedNum:WMTopupInputLimitMax];
}

@end
