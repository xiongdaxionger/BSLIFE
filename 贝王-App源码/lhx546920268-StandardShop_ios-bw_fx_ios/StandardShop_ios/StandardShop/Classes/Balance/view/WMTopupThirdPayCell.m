//
//  WMTopupPayCell.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMTopupThirdPayCell.h"

@implementation WMTopupThirdPayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.title_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.icon_imageView.layer.cornerRadius = 5.0;
    self.icon_imageView.layer.masksToBounds = YES;
    self.tick_imageView.image = [WMImageInitialization untickIcon];
    self.tick_imageView.highlightedImage = [WMImageInitialization tickingIcon];
}

@end

@implementation WMTopupSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        CGFloat margin = 10.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, _width_ - margin * 2, WMTopupSectionHeaderHeight)];
        _titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        _titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_titleLabel];
    }

    return self;
}

@end
