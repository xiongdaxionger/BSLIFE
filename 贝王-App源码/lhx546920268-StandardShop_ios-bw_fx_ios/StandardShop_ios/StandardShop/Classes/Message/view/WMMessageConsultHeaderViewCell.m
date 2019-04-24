//
//  WMMessageConsultHeaderViewCell.m
//  StandardShop
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageConsultHeaderViewCell.h"

@implementation WMMessageConsultHeaderViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.consultTypeLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.replyStatusLabel.font = [UIFont fontWithName:MainFontName size:11.0];
    self.replyStatusLabel.textColor = [UIColor grayColor];
}

- (void)configureWithTypeString:(NSString *)type timeString:(NSString *)time{
    
    self.consultTypeLabel.text = type;
    
    self.replyStatusLabel.text = time;
}


@end
