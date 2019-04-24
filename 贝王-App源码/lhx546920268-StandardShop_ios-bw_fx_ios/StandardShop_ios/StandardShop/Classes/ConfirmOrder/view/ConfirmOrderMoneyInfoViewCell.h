//
//  ConfirmOrderMoneyInfoViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kConfirmOrderMoneyPayInfoViewCellIden @"ConfirmOrderPayInfoViewCellIden"
#define kConfirmOrderMoneyPayInfoViewCellHeight 182
#define kConfirmOrderMoneyPayInfoExtraWidth 24 //用于计算高度
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**确认订单/订单详情页的价格信息展示
 */
@interface ConfirmOrderMoneyInfoViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**左侧订单信息
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceInfo;
/**右侧订单价格信息
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceContent;
@end
