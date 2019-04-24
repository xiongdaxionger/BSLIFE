//
//  WMHomeGoodSecondKillCell.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodInfo;


///首页限时秒杀cell
@interface WMHomeGoodSecondKillCell : UICollectionViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///名称
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///参与人数
@property (weak, nonatomic) IBOutlet UILabel *market_price_label;

///秒杀商品信息
@property (strong, nonatomic) WMGoodInfo *info;

@end
