//
//  WMTopupActivityTableFooter.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupActivityTableFooter.h"

@implementation WMTopupActivityTableFooter

///通过充值规则初始化
- (instancetype)initWithRule:(NSString*) rule
{
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    CGFloat margin = 10.0;

    CGFloat height = [rule stringSizeWithFont:font contraintWith:_width_ - margin * 2].height;

    self = [super initWithFrame:CGRectMake(0, 0, _width_, height + margin * 2 + 20.0)];
    if(self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.width - margin * 2, 20.0)];
        label.text = @"*充值需知";
        label.textColor = WMRedColor;
        label.font = font;
        [self addSubview:label];

        label = [[UILabel alloc] initWithFrame:CGRectMake(margin, label.bottom, self.width - margin * 2, height)];
        label.font = font;
        label.textColor = [UIColor grayColor];
        label.text = rule;
        label.numberOfLines = 0;
        [self addSubview:label];
    }

    return self;
}

@end
