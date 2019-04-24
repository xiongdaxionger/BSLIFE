//
//  WMIntegralGoodListCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/18.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMIntegralGoodListCellMargin 10.0

///大小
#define WMIntegralGoodListCellSize CGSizeMake((_width_ - WMIntegralGoodListCellMargin * 3) / 2.0, (_width_ - WMIntegralGoodListCellMargin * 3) / 2.0 + 40.0 + 10.0)

@class WMInegralGoodInfo;

///积分换购商品列表
@interface WMIntegralGoodListCell : UICollectionViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///兑换所需积分
@property (weak, nonatomic) IBOutlet UILabel *integral_label;

///商品信息
@property(nonatomic,strong) WMInegralGoodInfo *info;


@end
