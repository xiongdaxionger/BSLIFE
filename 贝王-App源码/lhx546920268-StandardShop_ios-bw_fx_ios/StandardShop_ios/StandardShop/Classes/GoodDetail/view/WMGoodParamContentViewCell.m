//
//  WMGoodParamContentViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodParamContentViewCell.h"

#import "WMGoodDetailParamInfo.h"

@implementation WMGoodParamContentViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.paramContentLabel.font = font;
    
    self.paramContentNameLabel.font = font;
    
    self.lineView.backgroundColor = MainDefaultBackColor;
    
    self.lineViewWidth.constant = _separatorLineWidth_;
}


- (void)configureWithModel:(WMGoodDetailParamValueInfo *)info{
    
    self.paramContentNameLabel.text = info.paramName;
    
    self.paramContentLabel.text = info.paramContent;
}

@end
