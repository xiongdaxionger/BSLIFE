//
//  WMHomeCategoryCell.m
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/13.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMHomeCategoryCell.h"
#import "WMHomeAdInfo.h"

@implementation WMHomeCategoryCell

- (void)awakeFromNib {
   
    [super awakeFromNib];
    self.contentView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.title_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.title_label.textColor = [UIColor blackColor];
}

- (void)setInfo:(WMHomeAdInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self.icon_imageView sea_setImageWithURL:info.imageURL];
        self.title_label.text = _info.text;
    }
}

@end
