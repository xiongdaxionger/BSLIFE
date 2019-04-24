//
//  WMDistributionFuncButtonCell.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMDistributionFuncButtonCell.h"
#import "WMDistributionFuncButtonInfo.h"

@implementation WMDistributionFuncButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat imageHeight = 35.0;
        UIFont *font = [UIFont fontWithName:MainFontName size:13.0];;
        CGFloat titleHeight = font.lineHeight;
        CGFloat margin = (frame.size.height - font.lineHeight - imageHeight) / 3.0;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, margin, frame.size.width, imageHeight)];
        _iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconImageView];
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconImageView.bottom + margin, frame.size.width, titleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = font;
        _titleLabel.textColor = MainGrayColor;
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setInfo:(WMDistributionFuncButtonInfo *)info
{
    if(_info != info)
    {
        _info = info;

        _titleLabel.text = _info.title;
        _iconImageView.image = _info.icon;
    }
}

@end


