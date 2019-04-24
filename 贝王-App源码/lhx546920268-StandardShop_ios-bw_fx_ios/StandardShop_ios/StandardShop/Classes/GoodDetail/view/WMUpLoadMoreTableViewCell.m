//
//  WMUpLoadMoreTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMUpLoadMoreTableViewCell.h"

@implementation WMUpLoadMoreTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.upLoadButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)configureCellWithModel:(id)model{
    
    
}

@end
