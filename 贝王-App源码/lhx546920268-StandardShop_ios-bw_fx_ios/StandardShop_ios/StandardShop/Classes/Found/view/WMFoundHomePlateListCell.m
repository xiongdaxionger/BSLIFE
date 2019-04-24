//
//  WMFoundHomePlateListCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomePlateListCell.h"
#import "WMFoundCategoryInfo.h"

@implementation WMFoundHomePlateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.title_label.font = [UIFont fontWithName:MainFontName size:15.0];
    self.subtitle_label.textColor = MainGrayColor;
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
}

- (void)setInfo:(WMFoundCategoryInfo *)info
{
    if(_info != info)
    {
        _info = info;
        self.title_label.text = _info.name;
        self.subtitle_label.text = _info.intro;
        [self.imageView sea_setImageWithURL:_info.imageURL];
    }
}

@end
