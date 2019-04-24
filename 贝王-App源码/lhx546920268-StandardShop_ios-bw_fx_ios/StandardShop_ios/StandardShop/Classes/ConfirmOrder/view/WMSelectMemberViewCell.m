//
//  WMSelectMemberViewCell.m
//  StandardFenXiao
//
//  Created by mac on 15/12/6.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMSelectMemberViewCell.h"

@implementation WMSelectMemberViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.memberNameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.contentView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)configureCellWithModel:(id)model{
    
    NSString *title = (NSString *)model;
    
    self.memberNameLabel.text = title;
}
@end
