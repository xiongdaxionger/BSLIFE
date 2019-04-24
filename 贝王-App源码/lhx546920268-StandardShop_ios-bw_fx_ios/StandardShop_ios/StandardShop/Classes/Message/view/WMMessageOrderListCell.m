//
//  WMMessageOrderListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageOrderListCell.h"
#import "WMMessageInfo.h"

@implementation WMMessageOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    self.intro_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.intro_label.textColor = MainGrayColor;
    self.logistics_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.logistics_label.textColor = WMRedColor;

    UIView *contentView = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);

    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[contentView]-%f-|", WMMessageOrderListCellMargin, WMMessageOrderListCellMargin] options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[contentView]-0-|"] options:0 metrics:nil views:views]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setInfo:(WMMessageOrderInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.title;
        self.intro_label.text = _info.subtitle;
        self.logistics_label.text = _info.logistics;
        [self.good_imageView sea_setImageWithURL:_info.imageURL];
    }
}

@end
