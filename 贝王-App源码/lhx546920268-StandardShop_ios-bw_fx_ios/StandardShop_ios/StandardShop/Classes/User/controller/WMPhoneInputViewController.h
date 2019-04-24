//
//  WMPhoneInputViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/11/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMImageVerificationCodeView;

///手机号码输入，获取短信验证码
@interface WMPhoneInputViewController : SeaViewController

///手机号码
@property (weak, nonatomic) IBOutlet UITextField *phone_number_textField;

///图形验证码
@property (weak, nonatomic) IBOutlet WMImageVerificationCodeView *image_code_view;

///同意打钩按钮
@property (weak, nonatomic) IBOutlet UIButton *tick_btn;

///下一步
@property (weak, nonatomic) IBOutlet UIButton *next_btn;

///打钩按钮顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tick_btn_topLayoutConstraint;

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

@end
