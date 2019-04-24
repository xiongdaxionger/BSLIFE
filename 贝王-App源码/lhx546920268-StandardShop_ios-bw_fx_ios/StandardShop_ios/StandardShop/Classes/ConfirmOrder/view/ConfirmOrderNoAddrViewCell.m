//
//  ConfirmOrderNoAddrViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderNoAddrViewCell.h"

@implementation ConfirmOrderNoAddrViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderNoAddrLabel.font = [UIFont fontWithName:MainFontName size:15];
}


- (void)configureCellWithModel:(id)model{
    
    NSString *titleInfo = (NSString *)model;
    
    _orderNoAddrLabel.text = titleInfo;
}


@end
