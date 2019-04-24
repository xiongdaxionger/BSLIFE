//
//  WMCouponsListCell.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCouponsListCell.h"
#import "WMCouponsInfo.h"


@implementation WMCouponsListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.title_label.font = [UIFont fontWithName:MainFontName size:17.0];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
    self.subtitle_label.font = font;
    self.nameLabel.font = font;
    self.timeLabel.font = font;
    
    self.use_bg_view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.use_bg_view.layer.borderWidth = 1.0;
    self.use_bg_view.layer.cornerRadius = 5.0;
    
    self.use_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.status_label.font = [UIFont fontWithName:MainFontName size:16.0];
    
    self.status_label.textColor = [UIColor whiteColor];
    
    [self.contentView bringSubviewToFront:self.status_label];
    
    self.status_label.adjustsFontSizeToFitWidth = YES;
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:WMCouponsListCellMargin]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:WMCouponsListCellMargin]];
    
    self.back_view.layer.cornerRadius = 5.0;
    self.back_view.layer.masksToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.title_label.adjustsFontSizeToFitWidth = YES;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    ///IOS 8.1 会卡死
//    //    CGRect frame = self.contentView.frame;
//    //    frame.origin.x = WMCouponsListCellMargin;
//    //    frame.size.width = _width_ - WMCouponsListCellMargin * 2;
//    //    frame.size.height = WMCouponsListCellHeight - WMCouponsListCellMargin;
//    //    self.contentView.frame = frame;
//    
//    ///必须在此地写，否则圆角不生效
//    self.contentView.layer.cornerRadius = 5.0;
//    self.contentView.layer.masksToBounds = YES;
//}

///选择优惠券
- (IBAction)useCouponsAction:(id)sender
{
    
    if([self.delegate respondsToSelector:@selector(couponsListCellCellDidSelect:)])
    {
        [self.delegate couponsListCellCellDidSelect:self];
    }
}

- (void)setInfo:(WMCouponsInfo *)info
{
    _info = info;
    
    if(_info.status == WMCouponsStatusNormal)
    {
        self.top_bg_view.backgroundColor = WMRedColor;
        self.nameLabel.textColor = WMRedColor;
        self.use_btn.enabled = YES;
        
        if (_info.isUseing) {
            
            [self.use_btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        else{
            
            [self.use_btn setTitle:@"使用" forState:UIControlStateNormal];
        }
    }
    else
    {
        self.top_bg_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"coupons_gray_bg"]];
        self.nameLabel.textColor = [UIColor colorFromHexadecimal:@"C9C9C9"];
        self.use_btn.enabled = NO;
    }
    
    self.use_bg_view.backgroundColor = self.nameLabel.textColor;
    self.timeLabel.textColor = self.nameLabel.textColor;
    
    self.status_bg_view.backgroundColor = self.timeLabel.textColor;
    
    self.timeLabel.text = _info.validTime;
    self.nameLabel.text = _info.name;
    self.title_label.text = _info.title;
    self.subtitle_label.text = _info.subtitle;
    self.status_label.text = _info.statusString;
    
}


@end
