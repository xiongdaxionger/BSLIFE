//
//  WMMessageCodeViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageCodeViewCell.h"

@interface WMMessageCodeViewCell ()<UITextFieldDelegate>

@end

@implementation WMMessageCodeViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textField.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.textField.delegate = self;
    
    [self.textField addTarget:self action:@selector(textContentChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.countDownButton addTarget:self action:@selector(countDownButtonClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(messageCodeContentChange:)]) {
        
        [self.delegate messageCodeContentChange:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textContentChange:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(messageCodeContentChange:)]) {
        
        [self.delegate messageCodeContentChange:textField.text];
    }
}

- (void)countDownButtonClick{
    
    self.getMessageCode();
}

- (void)dealloc{
    
    [self.countDownButton stopTimer];
}


@end
