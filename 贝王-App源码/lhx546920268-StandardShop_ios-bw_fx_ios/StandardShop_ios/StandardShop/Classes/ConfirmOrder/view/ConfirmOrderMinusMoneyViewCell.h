//
//  ConfirmOrderMinusMoneyViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kConfirmOrderMinusMoneyViewCellIden @"ConfirmOrderMinusMoneyViewCellIden"
#define kConfirmOrderMinusMoneyViewCellHeight 55

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**确认订单的积分抵扣显示
 */
@interface ConfirmOrderMinusMoneyViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**积分抵扣栏标题
 */
@property (weak, nonatomic) IBOutlet UILabel *orderMinusMoneyLabel;
/**使用积分的开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *orderMinusSwitch;

@end
