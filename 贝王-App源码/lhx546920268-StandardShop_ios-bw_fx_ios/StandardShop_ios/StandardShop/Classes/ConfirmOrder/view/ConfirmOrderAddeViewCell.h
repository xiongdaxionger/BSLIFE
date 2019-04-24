//
//  ConfirmOrderAddeViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kConfirmOrderAddrViewCellIden @"ConfirmOrderAddrViewCellIden"
#define kConfirmOrderAddrViewCellHeight 79
#define kConfirmOrderAddrExtraWidth 36 //用于计算地址高度
#define kConfirmOrderAddrExtraHeight 47 //用于计算地址高度

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
/**确认订单的地址显示
 */
@interface ConfirmOrderAddeViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**地址的配送用户名称
 */
@property (weak, nonatomic) IBOutlet UIButton *orderNameLabel;
/**地址的配送用户手机号
 */
@property (weak, nonatomic) IBOutlet UIButton *orderMobileLabel;
/**地址的配送地址
 */
@property (weak, nonatomic) IBOutlet UILabel *orderAddrLabel;
/**右箭头
 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@end
