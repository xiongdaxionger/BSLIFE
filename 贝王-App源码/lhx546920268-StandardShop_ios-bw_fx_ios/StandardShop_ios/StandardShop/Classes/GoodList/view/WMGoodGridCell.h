//
//  WMGoodGridCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodBaseCollectionViewCell.h"

@class WMGoodMarkView, WMGoodTagView;

///间距
#define WMGoodGridCellInterval 5.0

///item大小
#define WMGoodGridCellSize CGSizeMake((_width_ - WMGoodGridCellInterval * 3) / 2.0, (_width_ - WMGoodGridCellInterval * 3) / 2.0 + 5.0 + 21.0 + 5.0 + 26.0 + 5.0 + 20.0 + 10.0)

///网格类型的商品列表，一行两列
@interface WMGoodGridCell : WMGoodBaseCollectionViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///添加购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *shopcart_btn;

///价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///已售罄标识
@property (weak, nonatomic) IBOutlet UIImageView *soldout_imageView;

///标签
@property (weak, nonatomic) IBOutlet WMGoodTagView *tag_view;

///标识
@property (weak, nonatomic) IBOutlet WMGoodMarkView *mark_view;

///评论人数
@property (weak, nonatomic) IBOutlet UILabel *comment_count_label;

@end
