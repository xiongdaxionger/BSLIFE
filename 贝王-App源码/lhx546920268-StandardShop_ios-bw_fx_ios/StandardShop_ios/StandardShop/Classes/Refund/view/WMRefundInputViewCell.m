//
//  WMRefundInputViewCell.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundInputViewCell.h"

#import "WMRefundGoodRecordViewController.h"

#import "UITableViewCell+addLineForCell.h"

@interface WMRefundInputViewCell ()<UITextFieldDelegate>
@property (weak,nonatomic) WMRefundGoodRecordViewController *goodRecordController;
@end

@implementation WMRefundInputViewCell

- (void)awakeFromNib {
    
    self.saveButton.backgroundColor = WMButtonBackgroundColor;
    
    [self.saveButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    self.companyField.delegate = self;
    
    self.expressNumField.delegate = self;
    
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.titleLabel.textColor = WMRedColor;
    
    [self.saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithModel:(id)model{
    
    _goodRecordController = [model objectForKey:@"controller"];
    
    [self.companyField setText:[model sea_stringForKey:@"select"]];
}

- (void)saveButtonClick{
    
    [_goodRecordController saveDeliveryWithCompany:_companyField.text deliveryNumber:_expressNumField.text cell:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.companyField) {
        
        return NO;
    }
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMBlankCardNumInputLimitMax];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.companyField) {
        
        [_goodRecordController selectDeliveryTypeCell:self];
    }
}

@end
