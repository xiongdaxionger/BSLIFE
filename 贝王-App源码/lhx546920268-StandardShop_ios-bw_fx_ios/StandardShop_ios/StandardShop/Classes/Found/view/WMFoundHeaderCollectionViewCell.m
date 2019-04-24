//
//  WMFoundHeaderCollectionViewCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundHeaderCollectionViewCell.h"

@implementation WMFoundHeaderCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.name_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.icon_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSea_selected:(BOOL)sea_selected
{
    if(_sea_selected != sea_selected)
    {
        _sea_selected = sea_selected;
        self.name_label.textColor = _sea_selected ? _appMainColor_ : MainDeepGrayColor;
    }
}

@end
