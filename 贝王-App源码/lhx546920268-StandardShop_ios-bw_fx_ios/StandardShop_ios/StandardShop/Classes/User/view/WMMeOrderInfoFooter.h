//
//  WMMeOrderInfoFooter.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///我 订单信息 按钮
@interface WMMeOrderInfoFooterCell : UIView

///按钮
@property(nonatomic,readonly) UIButton *button;

///角标
@property(nonatomic,readonly) SeaNumberBadge *badge;

@end

#define WMMeOrderInfoFooterHeight (90.0 * WMDesignScale)

///我 订单信息 底部
@interface WMMeOrderInfoFooter : UICollectionViewCell

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;

///刷新数据
- (void)reloadData;

@end
