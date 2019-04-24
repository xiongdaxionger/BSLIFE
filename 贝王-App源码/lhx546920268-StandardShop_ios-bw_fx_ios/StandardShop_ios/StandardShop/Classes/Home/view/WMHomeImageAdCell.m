//
//  WMHomeImageAdCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/30.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMHomeImageAdCell.h"
#import "WMHomeInfo.h"

@implementation WMHomeImageAdCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imageView.sea_placeHolderContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMHomeAdInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.imageView sea_setImageWithURL:_info.imageURL];
    }
}

@end
