//
//  WMLoginViewController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaScrollViewController.h"

@class WMImageVerificationCodeView;

///登录界面
@interface WMLoginViewController : SeaScrollViewController<UITextFieldDelegate>

/**背景滚动视图，防止键盘挡住输入框
 */
@property (weak, nonatomic) IBOutlet UIScrollView *bg_scrollView;

///输入框背景
@property (weak, nonatomic) IBOutlet UIView *bg_view;

/**手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phone_numberTextField;

/**密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password_textField;

/**密码顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *password_textField_topLayoutConstraint;

/**图形验证码
 */
@property (weak, nonatomic) IBOutlet WMImageVerificationCodeView *image_code_view;

/**图形验证码顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_code_view_topLayoutConstraint;

/**登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *login_btn;

///注册按钮
@property (weak, nonatomic) IBOutlet UIButton *register_btn;

///社交账号登录 顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *social_collectionViewTopLayoutConstraint;

///眼睛
@property (weak, nonatomic) IBOutlet UIButton *eye_btn;

///社交账号登录
@property (weak, nonatomic) IBOutlet UICollectionView *social_collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *social_flowLayout;

/**忘记密码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *forget_passwd_btn;

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

@end
