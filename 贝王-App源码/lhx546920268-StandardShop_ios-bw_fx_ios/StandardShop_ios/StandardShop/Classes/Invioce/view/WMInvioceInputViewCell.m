//
//  WMInvioceInputViewCell.m
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInvioceInputViewCell.h"

#import "WMInvioceViewController.h"

@interface WMInvioceInputViewCell ()<UITextFieldDelegate>
@property (weak,nonatomic) WMInvioceViewController *invioceController;
@property (assign,nonatomic) BOOL is_content;
@end


@implementation WMInvioceInputViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.invioceInputField.delegate = self;
}


- (void)configureCellWithModel:(id)model{
    
    _is_content = [[model objectForKey:@"is_content"] boolValue];
    
    if (_is_content) {
        
        UIImageView *dropDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_category_down_icon"]];
        
        dropDown.frame = CGRectMake(_width_ - 32, (self.invioceInputField.height - 8) / 2,12, 8);
        
        dropDown.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.invioceInputField addSubview:dropDown];
    }
    else{
        
        [self.invioceInputField addTarget:self action:@selector(inputTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    NSString *content = [model objectForKey:@"content"];
    
    NSString *title = [model objectForKey:@"title"];
    
    NSString *placeHolder = [model objectForKey:@"placeholder"];
    
    self.invioceInfoLabel.text = title;
    
    self.invioceInputField.text = content;
    
    self.invioceInputField.placeholder = placeHolder;
    
    _invioceController = [model objectForKey:kControllerKey];
}

#pragma mark - 输入框协议

- (void)inputTextChange:(UITextField *)textField{
    
    _invioceController.invioceHeader = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!_is_content) {
        
        _invioceController.invioceHeader = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (!_is_content) {
        
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMWithdrawAccountHolderInputLimitMax];
    }
    else{
        
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_is_content) {
        
        [self.invioceController selectInvioceType];
        
        return NO;
    }
    
    return !_is_content;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}









@end
