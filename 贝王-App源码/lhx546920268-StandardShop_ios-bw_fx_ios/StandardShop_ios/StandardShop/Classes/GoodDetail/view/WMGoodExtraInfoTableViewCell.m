//
//  WMGoodExtraInfoTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodExtraInfoTableViewCell.h"

@implementation WMGoodExtraInfoTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.extraInfoContentLabel.font = font;
    
    self.extraInfoNameLabel.font = font;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithDict:(NSDictionary *)dict{
    
    self.extraInfoNameLabel.text = [dict sea_stringForKey:@"name"];
    
    self.extraInfoContentLabel.text = [dict sea_stringForKey:@"value"];
}

@end
