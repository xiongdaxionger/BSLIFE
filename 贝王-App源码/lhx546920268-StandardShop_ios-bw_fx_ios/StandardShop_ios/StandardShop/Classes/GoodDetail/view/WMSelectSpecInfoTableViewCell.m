//
//  WMSelectSpecInfoTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSelectSpecInfoTableViewCell.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailSpecInfo.h"

@implementation WMSelectSpecInfoTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.specInfoLabel.font = font;
    
    self.titleLabel.font = font;
    
    self.titleLabel.textColor = WMMarketPriceColor;
}


- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    self.specInfoLabel.attributedText = info.specInfoAttrString;
}





@end
