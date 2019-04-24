//
//  WMTopupTableHeader.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMTopupInfo;

/**充值表头
 */
@interface WMTopupTableHeader : UIView<UITextFieldDelegate>

/**输入金额标题
 */
@property (weak, nonatomic) IBOutlet UILabel *account_title_label;

/**金额输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *account_textField;

/**充值信息
 */
@property(nonatomic,strong) WMTopupInfo *topupInfo;

@end
