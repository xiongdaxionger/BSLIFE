//
//  WMGoodCommentTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentTableViewCell.h"
#import "WMGoodCommentScoreView.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailSettingInfo.h"
#import "WMGoodDetailPointInfo.h"

@implementation WMGoodCommentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.titleLabel.font = font;
    
    self.goodRateLabel.font = font;
    
    self.goodRateLabel.textColor = WMMarketPriceColor;
    
    self.titleLabel.textColor = WMMarketPriceColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    if (!info.settingInfo.goodDetailShowCommentPoint) {
        
        self.goodRateLabel.hidden = YES;
        
        return;
    }
    
    if ([NSString isEmpty:info.pointInfo.goodBestPointRate]) {
        
        self.goodRateLabel.text = @"暂无好评";
    }
    else{
        
        self.goodRateLabel.text = [NSString stringWithFormat:@"好评率:%@",info.pointInfo.goodBestPointRate];
    }
}




@end
