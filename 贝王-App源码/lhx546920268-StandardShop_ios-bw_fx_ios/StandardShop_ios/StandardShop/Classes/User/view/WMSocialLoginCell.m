//
//  WMSocialLoginCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSocialLoginCell.h"

@implementation WMSocialLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.title_label.textColor = MainGrayColor;
}

@end
