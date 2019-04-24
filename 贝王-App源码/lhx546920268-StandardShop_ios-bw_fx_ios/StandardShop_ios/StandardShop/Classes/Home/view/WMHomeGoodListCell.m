//
//  WMHomeGoodListCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMHomeGoodListCell.h"
#import "WMGoodInfo.h"

@implementation WMHomeGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.name_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.name_label.textColor = [UIColor blackColor];
    self.price_label.textAlignment = NSTextAlignmentLeft;
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMGoodInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.name_label.attributedText = _info.attributedGoodName;
        self.price_label.attributedText = [_info formatPriceWithFontSize:15.0];
        [self.good_imageView sea_setImageWithURL:_info.imageURL];
    }
}

@end
