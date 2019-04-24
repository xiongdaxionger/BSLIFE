//
//  WMInvioceInputViewCell.h
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMInvioceInputViewCellIden @"WMInvioceInputViewCellIden"
#define WMInvioceInputViewCellHeight 80

///发票输入框
@interface WMInvioceInputViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**显示信息
 */
@property (weak, nonatomic) IBOutlet UILabel *invioceInfoLabel;
/**输入信息
 */
@property (weak, nonatomic) IBOutlet UITextField *invioceInputField;

- (void)configureCellWithModel:(id)model;
@end
