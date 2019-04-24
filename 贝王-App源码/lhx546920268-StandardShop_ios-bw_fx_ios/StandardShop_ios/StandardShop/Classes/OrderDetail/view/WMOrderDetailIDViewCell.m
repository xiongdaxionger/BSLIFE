//
//  WMOrderDetailIDViewCell.m
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderDetailIDViewCell.h"

#import "WMOrderDetailInfo.h"

@implementation WMOrderDetailIDViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _orderIdLabel.font = [UIFont fontWithName:MainFontName size:14.0];
}


- (void)configureCellWithModel:(id)model{
    
    NSString *title = (NSString *)model;
    
    _orderIdLabel.text = title;
}
@end
