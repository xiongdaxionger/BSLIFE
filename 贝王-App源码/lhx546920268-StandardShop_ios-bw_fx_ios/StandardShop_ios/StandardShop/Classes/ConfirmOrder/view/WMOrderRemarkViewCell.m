//
//  WMOrderRemarkViewCell.m
//  SuYan
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderRemarkViewCell.h"

#import "ConfirmOrderPageController.h"
#import "WMConfirmOrderInfo.h"
#import "UITextField+Utilities.h"

@interface WMOrderRemarkViewCell ()
/**确认订单
 */
@property (weak,nonatomic) ConfirmOrderPageController *confirmOrder;
@end

@implementation WMOrderRemarkViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.remarkInput.delegate = self;
    
    self.remarkInput.inputLimitMax = WMApplyInviteContactInputLimitMax;
    
    [self.remarkInput addTextDidChangeNotification];
    
    self.remarkInput.font = [UIFont fontWithName:MainFontName size:14.0];
}

- (void)configureCellWithModel:(id)model{
    
    _confirmOrder = (ConfirmOrderPageController *)model;
}

#pragma mark - 输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMApplyInviteContactInputLimitMax];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _confirmOrder.orderInfo.orderRemarkInfo = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

@end
