//
//  WMAdviceContentViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceContentViewCell.h"

#import "WMAdviceContentInfo.h"
#import "WMAdviceQuestionInfo.h"
#import "WMAdviceSettingInfo.h"

@implementation WMAdviceContentViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.adviceReplyButton.enabled = NO;
    
    self.adviceTypeLabel.font = font;
    
    self.adviceTypeLabel.layer.cornerRadius = 3.0;
    
    self.adviceTypeLabel.layer.masksToBounds = YES;
    
    self.adviceContentLabel.font = font;
    
    self.adviceContentLabel.numberOfLines = 0;
}


- (void)configureCellWithModel:(id)model{
    
    WMAdviceSettingInfo *settingInfo = [model objectForKey:@"setting"];
    
    WMAdviceQuestionInfo *questionInfo = [model objectForKey:@"content"];
    
    self.adviceTypeLabel.backgroundColor = WMPriceColor;
    
    self.adviceTypeLabel.textColor = [UIColor whiteColor];
    
    self.adviceContentLabel.textColor = [UIColor blackColor];
    
    self.adviceContentLabel.text = questionInfo.adviceContent;
    
    self.adviceTypeLabel.text = @"Q";
        
    if (settingInfo.canReplyAdvice) {
        
        self.adviceReplyButton.hidden = NO;
        
        self.replyButtonWidth.constant = 22.0;
    }
    else{
        
        self.adviceReplyButton.hidden = YES;
        
        self.replyButtonWidth.constant = CGFLOAT_MIN;
    }
    
/*
        self.adviceContentLabel.textColor = MainGrayColor;
        
        self.adviceTypeLabel.textColor = [UIColor blackColor];
        
        self.adviceTypeLabel.backgroundColor = [UIColor clearColor];
        
        WMAdviceContentInfo *contentInfo = (WMAdviceContentInfo *)model;
        
        self.nameLabelWidth.constant = contentInfo.nameWidth;
        
        self.adviceContentLabel.text = contentInfo.adviceContent;
        
        self.adviceTypeLabel.text = contentInfo.adviceUserName;
        
        self.adviceReplyButton.hidden = YES;
        
        self.replyButtonWidth.constant = CGFLOAT_MIN;
 */
}








@end
