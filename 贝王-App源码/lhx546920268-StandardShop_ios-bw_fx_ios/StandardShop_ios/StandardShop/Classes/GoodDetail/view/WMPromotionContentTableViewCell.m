//
//  WMPromotionContentTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPromotionContentTableViewCell.h"

#import "WMGoodDetailPromotionInfo.h"

@implementation WMPromotionContentTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.promotionTitleLabel.font = font;
    
    self.promotionTitleLabel.textColor = [UIColor whiteColor];
    
    self.promotionTitleLabel.backgroundColor = WMRedColor;
    
    self.promotionTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.contentLabel.font = font;
    
    self.contentLabel.textColor = WMMarketPriceColor;
        
    self.contentLabel.wordSpace = CGFLOAT_MIN;
    
    self.contentLabel.selectableAttributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)[WMMarketPriceColor CGColor], (NSString*)kCTForegroundColorAttributeName, [NSNumber numberWithBool:NO], (NSString *)kCTUnderlineStyleAttributeName, nil];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WeakSelf(self);
    
    [self.contentLabel setSelectStringHandler:^(NSString *name) {
        
        weakSelf.selectCallBack(name);
    }];
}


- (void)configureCellWithModel:(id)model{
    
    WMPromotionContentInfo *contentInfo = (WMPromotionContentInfo *)model;
    
    self.contentLabel.text = contentInfo.contentName;
    
    if (contentInfo.rangeArr && contentInfo.rangeArr.count) {
        
        for (NSValue *value in contentInfo.rangeArr) {
            
            [self.contentLabel addSelectableRange:value.rangeValue];
        }
    }
    
    self.arrowButton.hidden = [NSString isEmpty:contentInfo.tagID];
    
    CGFloat tagWidth = [contentInfo.contentTag stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:100.0].width + 20.0;
    
    self.titleWidthConstraint.constant = tagWidth;
    
    self.promotionTitleLabel.text = contentInfo.contentTag;
}








@end
