//
//  WMGoodBrowseHistoryCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodBrowseHistoryCell.h"
#import "WMGoodInfo.h"

@implementation WMGoodBrowseHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.good_imageView.layer.borderWidth = _separatorLineWidth_;
    self.good_imageView.layer.borderColor = _separatorLineColor_.CGColor;
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.price_label.textColor = WMPriceColor;
    self.price_label.font = [UIFont fontWithName:MainNumberFontName size:20.0];
}

- (void)setInfo:(WMGoodInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.good_imageView sea_setImageWithURL:info.imageURL];
        self.name_label.text = info.goodName;
        self.price_label.attributedText = [info formatPriceConbinationWithPriceFontSize:18.0 marketPriceFontSize:13.0];
    }
}
@end
