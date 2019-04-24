//
//  WMAdviceHeaderViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceHeaderViewCell.h"

#import "WMAdviceQuestionInfo.h"

@implementation WMAdviceHeaderViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.adviceTimeLabel.font = [UIFont fontWithName:MainFontName size:11.0];
    
    [self.adviceTimeLabel sizeToFit];
    
    self.userNameLabel.font = font;
    
    self.adviceTimeLabel.textColor = MainGrayColor;
}


- (void)configureCellWithModel:(WMAdviceQuestionInfo *)model{
    
    self.adviceTimeLabel.text = model.adviceTime;
    
    self.userNameLabel.text = model.adviceUserName;
}









@end
