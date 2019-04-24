//
//  WMPromotionDropTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPromotionDropTableViewCell.h"
#import "JCTagListView.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailPromotionInfo.h"


@implementation WMPromotionDropTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.dropDowmButton.userInteractionEnabled = NO;
    
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.titleLabel.textColor = WMMarketPriceColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    self.promotionTagListView.sizeHeight = 20.0;
    
    self.promotionTagListView.tagCornerRadius = 0.0;
    
    self.promotionTagListView.tagTextColor = [UIColor whiteColor];
    
    self.promotionTagListView.tagStrokeColor = [UIColor clearColor];
    
    self.promotionTagListView.tagBackgroundColor = WMRedColor;
    
    self.promotionTagListView.userInteractionEnabled = NO;
    
    self.promotionTagListView.type = StyleTypeText;
    
    [self.promotionTagListView setup];
    
    [self.promotionTagListView setTags:info.promotionInfo.promotionTagTitlesArr];
}










@end
