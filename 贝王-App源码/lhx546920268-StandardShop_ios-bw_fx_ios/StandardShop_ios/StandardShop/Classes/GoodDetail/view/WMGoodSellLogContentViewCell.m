//
//  WMGoodSellLogContentViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodSellLogContentViewCell.h"

#import "WMGoodDetailSellLogInfo.h"

@implementation WMGoodSellLogContentViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.nickNameLabel.font = font;
    
    self.buyPriceLabel.font = font;
    
    self.buyQuantityLabel.font = font;
    
    self.buyTimeLabel.font = font;
}


- (void)configureWithModel:(WMGoodDetailSellLogInfo *)info{
    
    CGFloat showCount = _showPrice ? 4.0 : 3.0;
    
    CGFloat width = _width_ / showCount;
    
    _quantityWidthConstraint.constant = _buyTimeWidthConstraint.constant = _nickNameWidthConstraint.constant = width;
    
    _buyPriceWidthConstraint.constant = _showPrice ? width : CGFLOAT_MIN;
    
    _buyPriceLabel.hidden = !_showPrice;
    
    self.buyTimeLabel.text = info.buyTime;
    
    self.buyPriceLabel.text = formatStringPrice(info.sellLogPrice);
    
    self.buyQuantityLabel.text = info.buyCount;
    
    self.nickNameLabel.text = info.memberName;
}









@end
