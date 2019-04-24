//
//  WMSecondKillListCell.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define WMSecondKillListCellMargin 10.0

///行高
#define WMSecondKillListCellHeight (120.0 + WMSecondKillListCellMargin)

@class WMGoodInfo, WMSecondKillListCell;

///秒杀商品列表代理
@protocol WMSecondKillListCellDelegate <NSObject>

///立即抢购
- (void)secondKillListCellDidShop:(WMSecondKillListCell*) cell;

///订阅
- (void)secondKillListCellDidSubscrible:(WMSecondKillListCell*) cell;

@end

///秒杀商品列表
@interface WMSecondKillListCell : UITableViewCell

///商品图片
@property (weak, nonatomic) IBOutlet UIImageView *good_imageView;

///已售罄标识
@property (weak, nonatomic) IBOutlet UIImageView *soldout_imageView;

///名称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///价格
@property (weak, nonatomic) IBOutlet UILabel *price_label;

///市场价格
@property (weak, nonatomic) IBOutlet UILabel *market_price_label;

///购买按钮
@property (weak, nonatomic) IBOutlet UIButton *shop_btn;

///秒杀是否开始
@property (assign, nonatomic) BOOL isBegan;

///是否结束
@property (assign, nonatomic) BOOL isEnd;

///是否可以订阅，订阅提醒时间大于当前时间时才可以订阅
@property (assign, nonatomic) BOOL enableSubscrible;

@property (weak, nonatomic) id<WMSecondKillListCellDelegate> delegate;

///商品信息
@property (strong, nonatomic) WMGoodInfo *info;

@end
