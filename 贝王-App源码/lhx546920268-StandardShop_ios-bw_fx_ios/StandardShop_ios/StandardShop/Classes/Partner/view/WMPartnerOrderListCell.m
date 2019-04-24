//
//  WMPartnerOrderListCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerOrderListCell.h"
#import "WMOrderInfo.h"

@implementation WMPartnerOrderListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.amount_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.amount_label.adjustsFontSizeToFitWidth = YES;
}

- (void)setInfo:(WMOrderGoodInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        [self.good_imageView sea_setImageWithURL:info.image];
        self.name_label.text = info.goodName;
        
        self.amount_label.text = [NSString stringWithFormat:@"商品金额：%@", formatStringPrice(info.price.string)];
    }
}

@end
