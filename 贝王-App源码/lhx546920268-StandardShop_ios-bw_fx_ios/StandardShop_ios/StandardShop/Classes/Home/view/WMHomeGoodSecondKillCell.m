//
//  WMHomeGoodSecondKillCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMHomeGoodSecondKillCell.h"
#import "WMGoodInfo.h"


@implementation WMHomeGoodSecondKillCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0;
    self.contentView.layer.masksToBounds = YES;
    
    self.price_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.price_label.textColor = WMPriceColor;

    self.market_price_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.market_price_label.textColor = WMMarketPriceColor;
    
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMGoodInfo*)info
{
    if(_info != info)
    {
        _info = info;
        self.price_label.attributedText = _info.formatPrice;
        [self.good_imageView sea_setImageWithURL:_info.imageURL];
       // self.market_price_label.attributedText = _info.formatMarketPrice;
    }
}

@end
