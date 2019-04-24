//
//  WMFoundSingleImageCell.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundSingleImageCell.h"
#import "WMFoundListInfo.h"

@implementation WMFoundSingleImageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.name_bg_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.good_imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
}

- (void)setInfo:(WMFoundListInfo *)info
{
    [super setInfo:info];
    
    [self.good_imageView sea_setImageWithURL:info.imageURL];
    self.name_label.text = info.title;
}

@end
