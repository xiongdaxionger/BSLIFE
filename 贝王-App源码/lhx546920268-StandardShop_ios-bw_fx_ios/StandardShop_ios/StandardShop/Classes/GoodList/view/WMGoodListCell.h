//
//  WMGoodListCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodBaseCollectionViewCell.h"

///边距
#define WMGoodListCellMargin 8.0

///高度
#define WMGoodListCellSize CGSizeMake(_width_ - WMGoodListCellMargin * 2, 125.0 + 10.0 * 2 + 1.0 + 40.0)

@class WMGoodMarkView, WMGoodTagView;

///商品分类列表
@interface WMGoodListCell : WMGoodBaseCollectionViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///标签
@property (weak, nonatomic) IBOutlet WMGoodTagView *tag_view;

///标识
@property (weak, nonatomic) IBOutlet WMGoodMarkView *mark_view;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///佣金
@property (weak, nonatomic) IBOutlet UILabel *commission_label;

///评论人数
@property (weak, nonatomic) IBOutlet UILabel *comment_count_label;

///销量
@property (weak, nonatomic) IBOutlet UILabel *sales_label;

///加入购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *shopcart_btn;

///已售罄标识
@property (weak, nonatomic) IBOutlet UIImageView *soldout_imageView;

///按钮顶部分割线
@property (weak, nonatomic) IBOutlet UIView *top_line;

///收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collect_btn;

///对比按钮
@property (weak, nonatomic) IBOutlet UIButton *compare_btn;

///分享按钮
@property (weak, nonatomic) IBOutlet UIButton *share_btn;

///按钮之间的分割线1
@property (weak, nonatomic) IBOutlet UIView *line1;

///按钮之间的分割线2
@property (weak, nonatomic) IBOutlet UIView *line2;

@end
