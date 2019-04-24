//
//  WMRefundInputViewCell.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMRefundInputViewCellIden @"WMRefundInputViewCellIden"
#define WMRefundInputViewCellHeight 175
@interface WMRefundInputViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**快递公司的输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *companyField;
/**快递单号的输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *expressNumField;
/**保存按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (void)configureCellWithModel:(id)model;
@end
