//
//  WMGoodPureTextTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodPureTextTableViewCell.h"

@implementation WMGoodPureTextTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.lineView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.lineViewHeight.constant = _separatorLineWidth_;
    
    self.lineView.hidden = YES;
}


- (void)configureCellWithModel:(id)model{
    
    NSAttributedString *attrString = (NSAttributedString *)model;
    
    self.textContentLabel.attributedText = attrString;
}






@end
