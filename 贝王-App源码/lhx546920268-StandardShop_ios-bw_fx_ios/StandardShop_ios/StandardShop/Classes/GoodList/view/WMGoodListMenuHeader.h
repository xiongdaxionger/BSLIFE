//
//  WMGoodListMenuHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaDropDownMenu;

///无商品信息高度
#define WMGoodListMenuHeaderNoGoodHeight 80.0

///商品列表头部菜单，用于有品牌信息时 悬浮菜单
@interface WMGoodListMenuHeader : UICollectionReusableView

///分割线
@property(nonatomic,readonly) UIView *line;

///菜单
@property(nonatomic,strong) SeaDropDownMenu *menuBar;

///无商品信息时显示
@property(nonatomic,readonly) UILabel *textLabel;

@end
