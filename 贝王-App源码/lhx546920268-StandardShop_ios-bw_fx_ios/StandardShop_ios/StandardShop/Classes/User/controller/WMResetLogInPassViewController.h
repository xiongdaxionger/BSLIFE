//
//  WMResetLogInPassViewController.h
//  WanShoes
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaScrollViewController.h"

@class WMImageVerificationCodeView;

///忘记密码
@interface WMResetLogInPassViewController : SeaScrollViewController

///滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *bg_scrollView;

///输入框背景
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**账号输入文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber_textField;

/**图形验证码
 */
@property (weak, nonatomic) IBOutlet WMImageVerificationCodeView *image_code_view;

/**验证码输入文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *code_textField;

/**短信验证码输入文本框顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *code_textField_topLayoutConstraint;

/**密码输入文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *password_textField;

/**确认密码输入文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *confirm_password_textField;

/**确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *confirm_btn;

//客服电话
@property (weak, nonatomic) IBOutlet UIButton *tipButton;

///需要重置的密码
@property (copy, nonatomic) NSString *phoneNumber;

@end
