//
//  WMGoodBrandTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodBrandTableViewCell.h"

#import "WMGoodDetailInfo.h"
#import "WMBrandInfo.h"
#import "UIView+XQuickStyle.h"

@implementation WMGoodBrandTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.brandName.font = [UIFont fontWithName:MainFontName size:14.0];
    
    [self layoutIfNeeded];
    
    [self.brandLogo makeBorderWidth:1.0 Color:_separatorLineColor_ CornerRadius:self.brandLogo.height / 2.0];
    
    self.brandLogo.clipsToBounds = YES;
    
    self.brandLogo.sea_originContentMode = UIViewContentModeScaleAspectFit;
}


- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    [self.brandLogo sea_setImageWithURL:info.goodBrandInfo.imageURL];
    
    self.brandName.text = info.goodBrandInfo.name;
}

@end
