//
//  WMGoodCollectListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCollectListCell.h"
#import "WMGoodCollectionInfo.h"

@implementation WMGoodCollectListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.good_imageView.layer.borderWidth = _separatorLineWidth_;
    self.good_imageView.layer.borderColor = _separatorLineColor_.CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.price_label.textColor = WMPriceColor;
    self.price_label.font = [UIFont fontWithName:MainNumberFontName size:21];
    self.status_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.status_bg_view.layer.borderWidth = 1.0;
    [self.notice_btn setBackgroundColor:WMButtonBackgroundColor];
    self.notice_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.notice_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    [self.notice_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
}

- (void)setInfo:(WMGoodCollectionInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.good_imageView sea_setImageWithURL:info.goodInfo.imageURL];
        self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
        self.name_label.text = info.goodInfo.goodName;

        if(info.goodInfo.isMarket)
        {
            if(info.goodInfo.inventory > 0)
            {
                self.status_label.textColor = WMRedColor;
                self.status_label.text = @"有货";
            }
            else
            {
                self.status_label.textColor = [UIColor grayColor];
                self.status_label.text = @"无货";
            }
        }
        else
        {
            self.status_label.text = @"已下架";
            self.status_label.textColor = [UIColor grayColor];
        }
        
        self.notice_btn.hidden = !info.goodInfo.isMarket || info.goodInfo.inventory > 0;
        self.shopcart_btn.hidden = !info.goodInfo.isMarket || info.goodInfo.inventory == 0;
        self.status_bg_view.layer.borderColor = self.status_label.textColor.CGColor;
        self.price_label.attributedText = [info.goodInfo formatPriceConbinationWithPriceFontSize:18.0 marketPriceFontSize:13.0];
    }
}

///加入购物车
- (IBAction)shopcarAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodCollectListCellDidAddShopcart:)])
    {
        [self.delegate goodCollectListCellDidAddShopcart:self];
    }
}

///到货通知
- (IBAction)noticeAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(goodCollectListCellDidNotice:)])
    {
        [self.delegate goodCollectListCellDidNotice:self];
    }
}

@end
