//
//  WMSecondKillListCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSecondKillListCell.h"
#import "WMGoodInfo.h"

@implementation WMSecondKillListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.name_label.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.good_imageView.layer.borderWidth = _separatorLineWidth_;
    self.good_imageView.layer.borderColor = _separatorLineColor_.CGColor;
    self.price_label.font = [UIFont fontWithName:MainNumberFontName size:20.0];
    self.price_label.textColor = WMPriceColor;
    self.market_price_label.font = [UIFont fontWithName:MainFontName size:12.0];
    
    self.shop_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    self.shop_btn.layer.cornerRadius = 8.0;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    ///内容约束
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:WMSecondKillListCellMargin]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
}

- (void)setInfo:(WMGoodInfo *)info
{
    _info = info;
    
    self.name_label.text = _info.goodName;
    [self.good_imageView sea_setImageWithURL:_info.imageURL];
    
    if(self.isEnd)
    {
        ///已结束
        self.shop_btn.selected = NO;
        self.soldout_imageView.hidden = YES;
        [self.shop_btn setTitle:@"立即抢购" forState:UIControlStateDisabled];
        self.shop_btn.enabled = NO;
        self.shop_btn.backgroundColor = [UIColor lightGrayColor];
    }
    else if(self.isBegan)
    {
        self.shop_btn.selected = NO;
        self.soldout_imageView.hidden = !_info.secondKillIsSoldout;
        [self.shop_btn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self.shop_btn setTitle:@"已抢完" forState:UIControlStateDisabled];
        self.shop_btn.enabled = !_info.secondKillIsSoldout;
        self.shop_btn.backgroundColor = !_info.secondKillIsSoldout ? WMRedColor : [UIColor lightGrayColor];
    }
    else if(self.enableSubscrible)
    {
        ///未开始
        self.soldout_imageView.hidden = YES;
        [self.shop_btn setTitle:@"提醒我" forState:UIControlStateNormal];
        [self.shop_btn setTitle:@"取消提醒" forState:UIControlStateSelected];
        self.shop_btn.enabled = YES;
        self.shop_btn.selected = _info.isSubscribed;
        self.shop_btn.backgroundColor = WMRedColor;
    }
    else
    {
        self.soldout_imageView.hidden = YES;
        [self.shop_btn setTitle:@"立即抢购" forState:UIControlStateDisabled];
        self.shop_btn.enabled = NO;
        self.shop_btn.selected = NO;
        self.shop_btn.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.price_label.attributedText = [_info formatPriceWithFontSize:20.0];
    self.market_price_label.attributedText = _info.formatMarketPrice;
}

///立即购买
- (IBAction)shopAction:(id)sender
{
    if(self.isBegan)
    {
        if([self.delegate respondsToSelector:@selector(secondKillListCellDidShop:)])
        {
            [self.delegate secondKillListCellDidShop:self];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(secondKillListCellDidSubscrible:)])
        {
            [self.delegate secondKillListCellDidSubscrible:self];
        }
    }
}

@end
