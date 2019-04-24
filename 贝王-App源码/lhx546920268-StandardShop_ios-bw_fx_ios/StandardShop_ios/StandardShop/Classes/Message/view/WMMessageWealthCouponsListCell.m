//
//  WMMessageWealthCouponsListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageWealthCouponsListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageWealthCouponsListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.subtitle_label.textColor = MainGrayColor;

    self.amount_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.status_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.status_label.hidden = YES;
    self.amount_label.numberOfLines = 0;

    UIView *contentView = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[contentView]-%f-|", WMMessageWealthCouponsListCellMargin, WMMessageWealthCouponsListCellMargin] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[contentView]-0-|"] options:0 metrics:nil views:views]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setInfo:(WMMessageCouponsInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.subtitle_label.text = _info.subtitle;
        self.amount_label.text = _info.couponsInfo.name;
    }
}

@end
