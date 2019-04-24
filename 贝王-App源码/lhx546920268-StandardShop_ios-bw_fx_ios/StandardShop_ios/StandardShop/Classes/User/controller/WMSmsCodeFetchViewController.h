//
//  WMSmsCodeFetchViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/11/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMImageVerificationCodeView;

///短信验证码获取界面
@interface WMSmsCodeFetchViewController : SeaViewController

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *code_textField;

///获取短信验证啊倒计时按钮
@property (weak, nonatomic) IBOutlet SeaCountDownButton *countDownButton;

///图形验证码
@property (weak, nonatomic) IBOutlet WMImageVerificationCodeView *image_code_view;

///下一步
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

///下一步按钮顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *next_btn_topLayoutConstraint;

///手机号码
@property (copy, nonatomic) NSString *phoneNumber;

///图形验证码链接，不为nil则表示需要图形验证码
@property (copy, nonatomic) NSString *imageCodeURL;

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

@end
