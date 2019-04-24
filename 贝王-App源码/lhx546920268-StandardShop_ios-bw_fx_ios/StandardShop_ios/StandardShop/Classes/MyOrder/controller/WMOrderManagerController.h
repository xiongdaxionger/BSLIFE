//
//  WMOrderManagerController.h
//  StandardFenXiao
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@interface WMOrderManagerController : SeaViewController
/**选中的分段控件下标
 */
@property (assign,nonatomic) NSInteger segementIndex;
/**订单状态的菜单的下标
 */
@property (assign,nonatomic) NSInteger seaMenuBarIndex;
@end
