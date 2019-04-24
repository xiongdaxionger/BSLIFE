//
//  WMLogInPassWordInputViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMLogInPassWordInputViewCell.h"

@interface WMLogInPassWordInputViewCell ()<UITextFieldDelegate>
/**类型
 */
@property (assign,nonatomic) InputType type;
@end

@implementation WMLogInPassWordInputViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.inputTextField.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.inputTextField.delegate = self;
    
    [self.inputTextField addTarget:self action:@selector(textContentChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)configureWithContent:(NSString *)content type:(InputType)type{
    
    self.inputTextField.text = content;
    
    self.type = type;
    
    switch (type) {
        case InputTypeSecondPayPass:
        {
            self.inputTextField.placeholder = @"请再次确认支付密码";
            
            self.inputTextField.secureTextEntry = YES;
            
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case InputTypeFirstPayPass:
        {
            self.inputTextField.placeholder = @"请输入支付密码";
            
            self.inputTextField.secureTextEntry = YES;
            
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case InputTypeLogInPassWord:
        {
            self.inputTextField.placeholder = @"请输入登陆密码";
            
            self.inputTextField.secureTextEntry = YES;
            
            self.inputTextField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case InputTypePhone:
        {
            self.inputTextField.placeholder = @"请输入手机号码";
            
            self.inputTextField.secureTextEntry = NO;
            
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (self.type) {
        case InputTypePhone:
        {
            return NO;
        }
            break;
        case InputTypeFirstPayPass:
        case InputTypeSecondPayPass:
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMTradePasswdCount];
        }
            break;
        case InputTypeLogInPassWord:
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
        }
            break;
        default:
        {
            return NO;
        }
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(inputPassWordFinishWithPassWord:type:)]) {
        
        [self.delegate inputPassWordFinishWithPassWord:textField.text type:self.type];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textContentChange:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(inputPassWordFinishWithPassWord:type:)]) {
        
        [self.delegate inputPassWordFinishWithPassWord:textField.text type:self.type];
    }
}










@end
