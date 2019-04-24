//
//  WMDrawCouponsListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDrawCouponsListCell.h"
#import "WMCouponsInfo.h"


@implementation WMDrawCouponsListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.title_label.font = [UIFont fontWithName:MainFontName size:18.0];

    UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
    self.subtitle_label.font = font;
    self.nameLabel.font = font;
    self.timeLabel.font = font;

    self.draw_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.draw_btn.layer.borderWidth = 1.0;
    self.draw_btn.layer.cornerRadius = 5.0;

    self.draw_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];


//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:WMDrawCouponsListCellMargin]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:WMDrawCouponsListCellMargin]];

    self.top_bg_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupons_bg"]];
    self.nameLabel.textColor = WMRedColor;
    self.timeLabel.textColor = self.nameLabel.textColor;
    
    self.back_view.layer.cornerRadius = 5.0;
    self.back_view.layer.masksToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor clearColor];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    ///IOS 8.1 会卡死
//    //    CGRect frame = self.contentView.frame;
//    //    frame.origin.x = WMDrawCouponsListCellMargin;
//    //    frame.size.width = _width_ - WMDrawCouponsListCellMargin * 2;
//    //    frame.size.height = WMDrawCouponsListCellHeight - WMDrawCouponsListCellMargin;
//    //    self.contentView.frame = frame;
//
//    ///必须在此地写，否则圆角不生效
//    self.contentView.layer.cornerRadius = 5.0;
//    self.contentView.layer.masksToBounds = YES;
//}

///领取优惠券
- (IBAction)drawCouponsAction:(id)sender
{
    if (self.info.activityStatus != WMActivityStatusActive) {
        
        return;
    }

    if([self.delegate respondsToSelector:@selector(drawCouponsListCellDidDraw:)])
    {
        [self.delegate drawCouponsListCellDidDraw:self];
    }
}

- (void)setInfo:(WMCouponsInfo *)info
{
    _info = info;
    
    if (info.activityStatus == WMActivityStatusActive) {
        
        self.top_bg_view.backgroundColor = WMRedColor;
        self.nameLabel.textColor = WMRedColor;

    }
    else{
        
        self.top_bg_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupons_gray_bg"]];
        self.nameLabel.textColor = [UIColor colorFromHexadecimal:@"C9C9C9"];

    }
    
    self.draw_btn.backgroundColor = self.nameLabel.textColor;
    self.timeLabel.textColor = self.nameLabel.textColor;

    self.timeLabel.text = _info.validTime;
    self.nameLabel.text = _info.name;
    self.title_label.text = _info.title;
    self.subtitle_label.text = _info.subtitle;
    [self.draw_btn setTitle:[NSString stringWithFormat:@" %@ ",info.statusString] forState:UIControlStateNormal];
}


@end

