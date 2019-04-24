//
//  ConfirmOrderPayInfoViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#define kConfirmOrderPayInfoViewCellIden @"ConfirmOrderPayInfoViewCellIden"
#define kConfirmOrderPayInfoViewCellHeight 55
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**订单支付页的支付方式展示
 */
@interface ConfirmOrderPayInfoViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**支付方式的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *orderPayInfoImage;
/**支付方式的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPayInfoName;
/**支付方式的选择
 */
@property (weak, nonatomic) IBOutlet UIButton *orderPaySelect;

@end
