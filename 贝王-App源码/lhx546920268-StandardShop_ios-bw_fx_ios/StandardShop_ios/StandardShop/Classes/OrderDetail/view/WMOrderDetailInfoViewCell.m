//
//  WMOrderDetailInfoViewCell.m
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderDetailInfoViewCell.h"

@implementation WMOrderDetailInfoViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.contentLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.contentLabel.textColor = [UIColor blackColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)configureCellWithModel:(id)model{
    
    NSDictionary *infoDict = (NSDictionary *)model;
    
    self.titleLabel.text = [infoDict sea_stringForKey:@"title"];
    
    if ([self.titleLabel.text isEqualToString:@"补款时间"]) {
        
        self.contentLabel.textColor = WMRedColor;
    }
    else{
        
        self.contentLabel.textColor = [UIColor blackColor];
    }
    
    self.contentLabel.text = [infoDict sea_stringForKey:@"content"];
}
@end
