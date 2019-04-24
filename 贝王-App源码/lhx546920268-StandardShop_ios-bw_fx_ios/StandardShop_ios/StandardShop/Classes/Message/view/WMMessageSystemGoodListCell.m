//
//  WMMessageSystemGoodListCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageSystemGoodListCell.h"
#import "WMGoodInfo.h"

@implementation WMMessageSystemGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
}

- (void)setInfo:(WMGoodInfo *)info
{
    if(_info != info)
    {
        _info = info;

        [self.good_imageView sea_setImageWithURL:_info.imageURL];
        self.name_label.text = _info.goodName;
    }
}

@end
