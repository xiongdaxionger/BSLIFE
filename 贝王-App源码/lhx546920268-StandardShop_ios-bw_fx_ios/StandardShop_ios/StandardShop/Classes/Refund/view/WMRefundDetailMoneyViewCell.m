//
//  WMRefundDetailMoneyViewCell.m
//  StandardShop
//
//  Created by Hank on 16/8/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundDetailMoneyViewCell.h"

#import "UITableViewCell+addLineForCell.h"

@implementation WMRefundDetailMoneyViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.titleLabel.font = font;
    
    self.subTitleLabel.font = [UIFont fontWithName:MainFontName size:11.0];
    
    self.contentLabel.font = font;
    
    [self addLineForBottomWithBottomFloat:self.subTitleLabel.bottom];
    
    self.subTitleLabel.textColor = WMMarketPriceColor;
    
    self.subTitleLabel.text = @"实际退款金额以与商家协商一致及实际到账为准";
}


- (void)configureCellWithModel:(id)model{
    
    NSDictionary *dict = (NSDictionary *)model;
    
    self.titleLabel.text = [dict sea_stringForKey:@"title"];
    
    self.contentLabel.text = [dict sea_stringForKey:@"content"];
}


@end
