//
//  WMGoodListShopcartButton.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///大小
#define WMGoodListSuspensionButtonSize CGSizeMake(40.0, 81.0)

///商品列表右下角悬浮按钮，有购物车和回到顶部
@interface WMGoodListSuspensionButton : UIView

///购物车按钮
@property(nonatomic,readonly) UIButton *shopcart_btn;

///回到顶部
@property(nonatomic,readonly) UIButton *scroll_to_top_btn;

///关联的UIScrollView
@property(nonatomic,weak) UIScrollView *scrollView;

///购物车商品数量
@property(nonatomic,readonly) SeaNumberBadge *badge;

///跳转导航
@property(nonatomic,weak) UINavigationController *navigationController;

@end
