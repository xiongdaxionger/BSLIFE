//
//  FeedBackContactViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMFeedBackContactCell.h"
#import "UITableViewCell+addLineForCell.h"
#import "WMRefundMoneyDetailViewController.h"
#import "WMRefundGoodDetailViewController.h"

@interface WMFeedBackContactCell ()<UITextFieldDelegate>
/**退款申请
 */
@property (weak,nonatomic) WMRefundMoneyDetailViewController *refundMoney;
/**退换申请
 */
@property (weak,nonatomic) WMRefundGoodDetailViewController *refundGood;
@end
@implementation WMFeedBackContactCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _contactField.returnKeyType = UIReturnKeyDone;
    
    _contactField.delegate = self;
    
    _feedContactLabel.font = [UIFont fontWithName:MainFontName size:13];
    
    _contentLbelOne.font = [UIFont fontWithName:MainFontName size:MainFontSize36];
        
    [self addLineForTop];
}


- (void)configureCellWithModel:(id)model{
    
    if ([model isKindOfClass:[WMRefundMoneyDetailViewController class]]){
        
        _refundMoney = (WMRefundMoneyDetailViewController *)model;
        
        _feedContactLabel.text = @"退款理由";
        
        _contactField.placeholder = @"请填写退款理由(必填)";
        
        _contentLabelTwo.hidden = YES;
        
        _contentLbelOne.hidden = YES;
    }
    else if ([model isKindOfClass:[WMRefundGoodDetailViewController class]]){
        
        _refundGood = (WMRefundGoodDetailViewController *)model;
        
        _feedContactLabel.text = @"退换理由";
        
        _contactField.placeholder = @"请填写退换理由(必填)";
        
        _contentLabelTwo.hidden = YES;
        
        _contentLbelOne.hidden = YES;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_refundMoney){
        
        _refundMoney.reason = _contactField.text;
    }
    else if (_refundGood){
        
        _refundGood.reason = _contactField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMWithdrawAccountHolderInputLimitMax];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end
