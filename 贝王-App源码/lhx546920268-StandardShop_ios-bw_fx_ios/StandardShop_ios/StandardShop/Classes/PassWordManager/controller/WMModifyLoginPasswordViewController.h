//
//  WMModifyLoginPasswordViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


/**修改登录密码
 */
@interface WMModifyLoginPasswordViewController : SeaScrollViewController<UITextFieldDelegate,UIAlertViewDelegate>

/**背景滚动视图
 */
@property (weak, nonatomic) IBOutlet UIScrollView *bg_scrollView;

/**旧密码
 */
@property (weak, nonatomic) IBOutlet UITextField *org_passwdTextField;

/**新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *news_passwdTextField;

/**确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwdTextField;

/**确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;

@end
