//
//  WMDistributionEarningsCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDistributionEarningsCell.h"

@implementation WMDistributionEarningsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIFont *titleFont = [UIFont fontWithName:MainFontName size:15.0];
        UIFont *contentFont = [UIFont fontWithName:MainNumberFontName size:14.0];
        CGFloat interval = 5.0;
        CGFloat margin = 5.0;
        CGFloat y = (self.height - titleFont.lineHeight - interval - contentFont.lineHeight) / 2.0;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, self.width - margin * 2, titleFont.lineHeight)];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];


        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, _titleLabel.bottom + interval, self.width - margin * 2, contentFont.lineHeight)];
        _contentLabel.font = contentFont;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_contentLabel];

        self.contentView.backgroundColor = WMRedColor;
    }

    return self;
}

@end
