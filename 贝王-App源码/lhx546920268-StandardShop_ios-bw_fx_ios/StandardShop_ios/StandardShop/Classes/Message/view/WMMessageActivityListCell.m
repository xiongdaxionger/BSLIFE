//
//  WMMessageActivityListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageActivityListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.intro_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.intro_label.textColor = MainGrayColor;
    self.line.sea_heightLayoutConstraint.constant = _separatorLineWidth_;
    self.line.backgroundColor = _separatorLineColor_;
    self.detail_label.font = [UIFont fontWithName:MainFontName size:15.0];

    UIView *contentView = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[contentView]-%f-|", WMMessageActivityListCellMargin, WMMessageActivityListCellMargin] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[contentView]-0-|"] options:0 metrics:nil views:views]];

    self.end_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.end_label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.end_label.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setInfo:(WMMessageActivityInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = info.title;
        self.intro_label.text = info.subtitle;
        [self.b_imageView sea_setImageWithURL:info.imageURL];
    }
}

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageActivityInfo*) info
{
    CGFloat width = _width_ - WMMessageActivityListCellMargin * 4;
    if(info.subtitleHeight == 0)
    {
        CGSize size = [info.subtitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:width];
        info.subtitleHeight = size.height + 1.0;
    }

    return 10.0 + 21.0 + 10.0 + width * 4 / 9.0 + (info.subtitleHeight > 0 ? (10.0 + info.subtitleHeight) : 0) + 10.0 + _separatorLineWidth_ + 40.0;
}

@end
