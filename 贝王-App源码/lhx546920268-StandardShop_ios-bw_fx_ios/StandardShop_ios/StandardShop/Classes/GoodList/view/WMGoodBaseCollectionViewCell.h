//
//  WMGoodBaseCollectionViewCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodInfo,WMGoodBaseCollectionViewCell;

///商品列表代理
@protocol WMGoodListCellDelegate <NSObject>

///加入购物车
- (void)goodListCellDidShopcartAdd:(WMGoodBaseCollectionViewCell*) cell;

///加入收藏
- (void)goodListCellDidCollect:(WMGoodBaseCollectionViewCell *)cell;

@end


///商品列表基础视图
@interface WMGoodBaseCollectionViewCell : UICollectionViewCell

///商品信息
@property (strong, nonatomic) WMGoodInfo *info;

///
@property (weak, nonatomic) UINavigationController *navigationController;

@property (weak, nonatomic) id<WMGoodListCellDelegate> delegate;

@end
