//
//  WMGoodShowInfoTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodShowInfoTableViewCell.h"

@implementation WMGoodShowInfoTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)configureCellWithModel:(id)model{
    
    self.titleLabel.text = @"商品属性";
}

@end
