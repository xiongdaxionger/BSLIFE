//
//  WMGoodAdviceTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodAdviceTableViewCell.h"

#import "WMGoodDetailInfo.h"
@implementation WMGoodAdviceTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.contentButton.enabled = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model{
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    [self.contentButton setTitle:[NSString stringWithFormat:@"点击查看购买咨询（%@）",info.adviceCount] forState:UIControlStateNormal];
}

@end
