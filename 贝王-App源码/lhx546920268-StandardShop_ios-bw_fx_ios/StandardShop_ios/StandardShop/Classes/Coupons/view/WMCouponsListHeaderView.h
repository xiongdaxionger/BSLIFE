//
//  WMCouponsListHeaderView.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaMenuBar.h"

/**优惠券列表表头
 */
@interface WMCouponsListHeaderView : UIView

/**菜单
 */
@property(nonatomic,readonly) SeaMenuBar *menuBar;

/**优惠券使用说明按钮
 */
@property(nonatomic,readonly) UIButton *button;

/**跳转导航
 */
@property(nonatomic,weak) UINavigationController *navigationController;

@end
