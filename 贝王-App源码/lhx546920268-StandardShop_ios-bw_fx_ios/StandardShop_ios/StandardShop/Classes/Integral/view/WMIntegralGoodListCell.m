//
//  WMIntegralGoodListCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/18.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMIntegralGoodListCell.h"
#import "WMInegralGoodInfo.h"

@implementation WMIntegralGoodListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.integral_label.font = [UIFont fontWithName:MainFontName size:11.0];
    self.integral_label.textColor = WMPriceColor;
}

- (void)setInfo:(WMInegralGoodInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.good_imageView sea_setImageWithURL:_info.imageURL];
        self.name_label.text = _info.goodName;
        self.integral_label.attributedText = _info.integralAttributedString;
    }
}

@end
