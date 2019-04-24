//
//  WMMessageWealthEarningsListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageWealthEarningsListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageWealthEarningsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.subtitle_label.textColor = MainGrayColor;

    UIView *contentView = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[contentView]-%f-|", WMMessageWealthEarningsListCellMargin, WMMessageWealthEarningsListCellMargin] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[contentView]-0-|"] options:0 metrics:nil views:views]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setInfo:(WMMessageInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.subtitle_label.text = _info.subtitle;
    }
}

///行高
+ (CGFloat)rowHeightForInfo:(WMMessageInfo*) info
{
    if(info.subtitleHeight == 0)
    {
        info.subtitleHeight = [info.subtitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:_width_ - WMMessageWealthEarningsListCellMargin * 4].height + 1.0;
    }

    return WMMessageWealthEarningsListCellMargin + 21.0 + (info.subtitleHeight > 0 ? (10.0 + info.subtitleHeight) : 0) + WMMessageWealthEarningsListCellMargin;
}

@end
