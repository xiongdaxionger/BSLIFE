//
//  WMFoundBaseCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundBaseCell.h"

@implementation WMFoundBaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.layer.borderColor = _separatorLineColor_.CGColor;
    self.contentView.layer.borderWidth = _separatorLineWidth_;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:WMFoundBaseCellMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:WMFoundBaseCellMargin]];
}

///IOS 8.1 会卡死
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    self.contentView.frame = CGRectMake(WMFoundBaseCellMargin, 0, self.contentView.width - WMFoundBaseCellMargin * 2, self.contentView.height);
//}
@end
