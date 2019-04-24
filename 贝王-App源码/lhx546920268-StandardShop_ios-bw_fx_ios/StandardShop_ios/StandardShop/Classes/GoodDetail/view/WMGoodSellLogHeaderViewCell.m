//
//  WMGoodSellLogHeaderViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodSellLogHeaderViewCell.h"

@implementation WMGoodSellLogHeaderViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.nickNameLabel.font = font;
    
    self.buyPriceLabel.font = font;
    
    self.buyQuantityLabel.font = font;
    
    self.buyTimeLabel.font = font;
    
    _nickNameLabel.text = @"买家昵称";
    
    _buyPriceLabel.text = @"购买价";
    
    _buyQuantityLabel.text = @"数量";
    
    _buyTimeLabel.text = @"购买时间";
}


- (void)configureWithModel:(BOOL)showPrice{
        
    CGFloat showCount = showPrice ? 4.0 : 3.0;
    
    CGFloat width = _width_ / showCount;
    
    _quantityWidthConstraint.constant = _buyTimeWidthConstraint.constant = _nickNameWidthConstraint.constant = width;
    
    _buyPriceWidthConstraint.constant = showPrice ? width : CGFLOAT_MIN;
    
    _buyPriceLabel.hidden = !showPrice;
}







@end
