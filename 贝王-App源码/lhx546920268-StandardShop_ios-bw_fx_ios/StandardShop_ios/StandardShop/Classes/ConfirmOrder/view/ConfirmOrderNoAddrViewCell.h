//
//  ConfirmOrderNoAddrViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kConfirmOrderNoAddrViewCellIden @"ConfirmOrderNoAddrViewCellIden"
#define kConfirmOrderNoAddrViewCellHeight 53

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**确认订单的空地址展示
 */
@interface ConfirmOrderNoAddrViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**提示文本
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNoAddrLabel;
@end
