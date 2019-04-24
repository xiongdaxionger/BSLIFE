//
//  WMGoodCollectListCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodCollectListCell,WMGoodCollectionInfo;

///行高
#define WMGoodCollectListCellHeight 132.0

///商品收藏列表cell代理
@protocol WMGoodCollectListCellDelegate <NSObject>

///加入购物车
- (void)goodCollectListCellDidAddShopcart:(WMGoodCollectListCell*) cell;

///到货通知
- (void)goodCollectListCellDidNotice:(WMGoodCollectListCell*) cell;

@end

///商品收藏列表cell
@interface WMGoodCollectListCell : UITableViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///商品名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///商品状态背景
@property (weak, nonatomic) IBOutlet UIView *status_bg_view;

///商品状态
@property (weak, nonatomic) IBOutlet UILabel *status_label;

///加入购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *shopcart_btn;

///到货通知按钮
@property (weak, nonatomic) IBOutlet UIButton *notice_btn;

///商品收藏信息
@property (strong, nonatomic) WMGoodCollectionInfo *info;

@property (weak, nonatomic) id<WMGoodCollectListCellDelegate> delegate;

@end
