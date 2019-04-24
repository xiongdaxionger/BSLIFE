//
//  WMCollectMoneyViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

/**收钱
 */
@interface WMCollectMoneyViewController : SeaViewController<UITextFieldDelegate>

/**收款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amount_label;

/**收款金额单位
 */
@property (weak, nonatomic) IBOutlet UILabel *amount_unit_label;

/**收款金额输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *amount_textField;

/**收款名称标题
 */
@property (weak, nonatomic) IBOutlet UILabel *name_title_label;

/**收款名称内容
 */
@property (weak, nonatomic) IBOutlet UITextField *name_textField;

/**下一步按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

/**提示信息
 */
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

@end
