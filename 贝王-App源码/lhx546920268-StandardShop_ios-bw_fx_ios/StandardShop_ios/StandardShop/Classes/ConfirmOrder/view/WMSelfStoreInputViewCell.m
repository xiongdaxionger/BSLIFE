//
//  WMSelfStoreInputViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/1/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMSelfStoreInputViewCell.h"

#import "WMConfirmOrderInfo.h"

@implementation WMSelfStoreInputViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.name_input_field.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.mobile_input_field.font = self.name_input_field.font;
    
    self.mobile_input_field.delegate = self;
    
    self.name_input_field.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.name_input_field]) {
        
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMApplyInviteContactInputLimitMax];
    }
    else{
        
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
}

- (void)configureCellWithModel:(id)model{
    
    self.orderInfo = (WMConfirmOrderInfo *)model;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.name_input_field]) {
        
        self.orderInfo.selfStoreContactName = textField.text;
    }
    else{
        
        self.orderInfo.selfStoreContactMobile = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

@end
