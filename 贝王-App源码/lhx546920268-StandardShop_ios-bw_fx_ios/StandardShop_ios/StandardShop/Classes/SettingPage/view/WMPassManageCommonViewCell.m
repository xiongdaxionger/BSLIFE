//
//  WMPassManageCommonViewCell.m
//  WestMailDutyFee
//
//  Created by qsit on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPassManageCommonViewCell.h"

@implementation WMPassManageCommonViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray"]];
    
    _commonLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configureCellWithModel:(id)model{
    
    NSString *titleStr = (NSString *)model;
    
    _commonLabel.text = titleStr;
}
@end
