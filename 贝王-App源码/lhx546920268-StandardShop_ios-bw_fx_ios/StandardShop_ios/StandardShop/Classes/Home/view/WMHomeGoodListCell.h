//
//  WMHomeGoodListCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodInfo;

///间距
#define WMHomeGoodListCellInterval 5.0

///大小
#define WMHomeGoodListCellSize CGSizeMake((_width_ - WMHomeGoodListCellInterval * 3) / 2, (_width_ - WMHomeGoodListCellInterval * 3) / 2 + 5.0 + 40.0 + 20.0 + 5.0)

///首页图片分类商品cell
@interface WMHomeGoodListCell : UICollectionViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///商品价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///商品信息
@property (strong, nonatomic) WMGoodInfo *info;

@end
