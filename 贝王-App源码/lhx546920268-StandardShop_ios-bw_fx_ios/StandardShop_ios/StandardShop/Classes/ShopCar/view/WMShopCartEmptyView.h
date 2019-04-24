//
//  WMShopCartEmptyView.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/1/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  购物车空视图
 */
@interface WMShopCartEmptyView : UIView

/**
 *  图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *logo_imageView;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title_label;

/**
 *  副标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

/**
 *  去购物按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopping_btn;

@end
