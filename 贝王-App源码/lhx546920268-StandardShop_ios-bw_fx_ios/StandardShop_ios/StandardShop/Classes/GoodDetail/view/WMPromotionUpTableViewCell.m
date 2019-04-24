//
//  WMPromotionUpTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPromotionUpTableViewCell.h"

@implementation WMPromotionUpTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.titleLabel.font = font;
    
    self.contentLabel.font = font;
    
    self.contentLabel.textColor = WMMarketPriceColor;
    
    self.titleLabel.textColor = WMMarketPriceColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.lineView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.lineViewHeight.constant = _separatorLineWidth_;
}


- (void)configureCellWithModel:(id)model{
    
    self.contentLabel.text = @"可以享受以下促销";
}






@end
