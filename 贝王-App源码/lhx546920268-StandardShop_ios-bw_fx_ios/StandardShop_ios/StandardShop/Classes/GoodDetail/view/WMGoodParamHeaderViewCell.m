//
//  WMGoodParamHeaderViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodParamHeaderViewCell.h"

@implementation WMGoodParamHeaderViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.paramGroupNameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
    
    lineView.backgroundColor = _separatorLineColor_;
    
    [self.contentView addSubview:lineView];
}

- (void)configureWithModel:(NSString *)groupName{
    
    self.paramGroupNameLabel.text = groupName;
}

@end
