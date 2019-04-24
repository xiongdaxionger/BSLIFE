//
//  WMOrderRemarkViewCell.h
//  SuYan
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMOrderRemarkViewCellHeight 44
#define WMOrderRemarkViewCellIden @"WMOrderRemarkViewCellIden"

/**订单确认页的订单备注
 */
@interface WMOrderRemarkViewCell : UITableViewCell<XTableCellConfigExDelegate,UITextFieldDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *remarkInput;

@end
