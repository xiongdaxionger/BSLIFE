//
//  WMConfirmOrderCustomerTableViewCell.h
//  StandardShop
//
//  Created by Hank on 16/11/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMConfirmOrderCustomerTableViewCellIden @"WMConfirmOrderCustomerTableViewCellIden"
#define WMConfirmOrderCustomerTableViewCellHeight 44.0
/**代客下单
 */
@interface WMConfirmOrderCustomerTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**开关的回调
 */
@property (copy,nonatomic) void(^switchCallBack)(BOOL isNeed);
/**提示文本
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/**开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *needSwitch;

@end
