//
//  WMFoundSingleImageCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundBaseCell.h"

///发现 单一图片的列表 cell
@interface WMFoundSingleImageCell : WMFoundBaseCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///名称背景
@property (weak, nonatomic) IBOutlet UIView *name_bg_view;

@end
