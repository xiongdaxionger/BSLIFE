//
//  ConfirmOrderPayHeaderViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define ConfirmOrderCommonHeaderViewCellIden @"ConfirmOrderCommonHeaderViewCellIden"
#define ConfirmOrderCommonHeaderViewCellHeight 44
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**确认订单的标准信息显示
 */
@interface ConfirmOrderCommonHeaderViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题信息
 */
@property (weak, nonatomic) IBOutlet UILabel *orderInfoLabel;
/**选择信息
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**指向按钮
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImage;

@end
