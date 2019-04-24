//
//  WMShopCarUnusePromotionViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopCarUnusePromotionViewCell.h"

#import "WMShopCarPromotionRuleInfo.h"

@implementation WMShopCarUnusePromotionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
    
    self.tagNameLabel.font = font;
    
    self.contentLabel.font = font;
    
    self.contentLabel.textColor = MainTextColor;
    
    self.tagNameLabel.layer.cornerRadius = 3.0;
    
    self.tagNameLabel.layer.masksToBounds = YES;
    
    self.tagNameLabel.backgroundColor = WMRedColor;
    
    self.tagNameLabel.textColor = [UIColor whiteColor];
}


- (void)configureCellWithModel:(id)model{
    
    WMShopCarPromotionRuleInfo *ruleInfo = (WMShopCarPromotionRuleInfo *)model;
    
    CGFloat tagWidth = [ruleInfo.ruleTag stringSizeWithFont:[UIFont fontWithName:MainFontName size:12.0] contraintWith:100.0].width + 14.0;
    
    self.tagNameWidthConstraint.constant = tagWidth;
    
    self.arrowButton.hidden = !ruleInfo.canAction;
    
    self.tagNameLabel.text = ruleInfo.ruleTag;
    
    self.contentLabel.text = ruleInfo.ruleName;
}







@end
