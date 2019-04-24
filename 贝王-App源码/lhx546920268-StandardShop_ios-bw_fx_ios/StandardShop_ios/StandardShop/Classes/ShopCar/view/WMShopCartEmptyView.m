//
//  WMShopCartEmptyView.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/1/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShopCartEmptyView.h"

@implementation WMShopCartEmptyView

- (instancetype)init
{
    WMShopCartEmptyView *view = [[[NSBundle mainBundle] loadNibNamed:@"WMShopCartEmptyView" owner:nil options:nil] firstObject];
    view.frame = CGRectMake(0, 0, _width_, _height_);
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.title_label.font = [UIFont fontWithName:MainFontName size:20.0];
    self.subtitle_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.shopping_btn.layer.cornerRadius = 3.0;
    self.shopping_btn.layer.masksToBounds = YES;
    self.shopping_btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.shopping_btn.layer.borderWidth = 1.0;
    self.shopping_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    self.logo_imageView.layer.cornerRadius = 25.0;
    self.logo_imageView.layer.masksToBounds = YES;
}

@end
