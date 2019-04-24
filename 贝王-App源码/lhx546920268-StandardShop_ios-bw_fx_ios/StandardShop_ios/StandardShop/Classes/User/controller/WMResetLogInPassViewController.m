//
//  WMResetLogInPassViewController.m
//  WanShoes
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMResetLogInPassViewController.h"
#import "SeaCountDownButton.h"
#import "WMUserOperation.h"
#import "WMImageVerificationCodeView.h"

@interface WMResetLogInPassViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,UIAlertViewDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;

/**倒计时按钮
 */
@property (strong,nonatomic) SeaCountDownButton *countDownbutton;

/**改变密码的显示状态
 */
@property (strong,nonatomic) UIButton *eye_btn;

/**电话
 */
@property (copy,nonatomic) NSString *phone;


@end

@implementation WMResetLogInPassViewController

#pragma mark - 控制器的生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(_width_ == 320.0)
    {
        [self addKeyboardNotification];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if(_width_ == 320.0)
    {
        [self removeKeyboardNotification];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView = self.bg_scrollView;
    
    self.title = @"找回密码";
    
    self.backItem = YES;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];

    self.bg_view.layer.cornerRadius = 2.0;
    self.bg_view.layer.borderColor = _separatorLineColor_.CGColor;
    self.bg_view.layer.borderWidth = _separatorLineWidth_;
    self.bg_view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:16.0];
    CGFloat margin = 15.0;

    ///手机号码输入框
    //图标
    UIImage *image = nil;//[UIImage imageNamed:@"login_phoneNumber"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.width = image.size.width + margin;
    imageView.contentMode = UIViewContentModeCenter;

    self.phoneNumber_textField.font = font;
    self.phoneNumber_textField.leftView = imageView;
    self.phoneNumber_textField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumber_textField.delegate = self;


    ///验证码获取按钮
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90.0, 30.0)];
    self.countDownbutton = [[SeaCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.countDownbutton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.countDownbutton];
    self.code_textField.rightView = view;
    self.code_textField.rightViewMode = UITextFieldViewModeAlways;

    ///短信验证码输入框
  //  image = [UIImage imageNamed:@"login_code"];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.width = image.size.width + margin;
    imageView.contentMode = UIViewContentModeCenter;

    self.code_textField.font = font;
    self.code_textField.leftView = imageView;
    self.code_textField.leftViewMode = UITextFieldViewModeAlways;
    self.code_textField.delegate = self;

    ///密码输入文本框

   // image = [UIImage imageNamed:@"login_password"];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.width = image.size.width + margin;
    imageView.contentMode = UIViewContentModeCenter;

    //    _changePassWordSecure = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    //    [_changePassWordSecure setImage:[UIImage imageNamed:@"login_eye_close"] forState:UIControlStateNormal];
    //    [_changePassWordSecure setImage:[UIImage imageNamed:@"login_eye_open"] forState:UIControlStateSelected];
    //    [_changePassWordSecure addTarget:self action:@selector(changePassWordSecureClick:) forControlEvents:UIControlEventTouchUpInside];
    //    _changePassWordSecure.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    _changePassWordSecure.width = [_changePassWordSecure imageForState:UIControlStateNormal].size.width + 5.0;
    //    _changePassWordSecure.selected = YES;
    self.password_textField.font = font;
    self.password_textField.leftView = imageView;
    self.password_textField.leftViewMode = UITextFieldViewModeAlways;
    //    _passWordTextField.rightView = _changePassWordSecure;
    //    _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    self.password_textField.delegate = self;
    self.password_textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(paste:)), nil];


  //  image = [UIImage imageNamed:@"login_password"];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.width = image.size.width + margin;
    imageView.contentMode = UIViewContentModeCenter;

    self.confirm_password_textField.font = font;
    self.confirm_password_textField.leftView = imageView;
    self.confirm_password_textField.leftViewMode = UITextFieldViewModeAlways;
    self.confirm_password_textField.delegate = self;
    self.confirm_password_textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(paste:)), nil];

    self.confirm_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.confirm_btn.layer.masksToBounds = YES;
    self.confirm_btn.backgroundColor = WMButtonBackgroundColor;
    [self.confirm_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    self.confirm_btn.titleLabel.font = WMLongButtonTitleFont;
    self.confirm_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
    
    self.tipButton.hidden = YES;
    
    self.tipButton.titleLabel.numberOfLines = 2;
    
    [self.tipButton addTarget:self action:@selector(callService:) forControlEvents:UIControlEventTouchUpInside];

    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;

    if([self.phoneNumber isMobileNumber])
    {
        self.phoneNumber_textField.text = self.phoneNumber;
    }

    [self setImageCodeHidden:YES];
    
    self.image_code_view.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, margin, margin)];

    [self loadImageCode];
}

- (void)callService:(UIButton *)button{
    
    makePhoneCall(self.phone, YES);
}

///设置图形验证码显示
- (void)setImageCodeHidden:(BOOL) hidden
{
    self.image_code_view.hidden = hidden;
    self.bg_view.sea_heightLayoutConstraint.constant = hidden ? 203 : 254;
    self.code_textField_topLayoutConstraint.constant = hidden ? 1 : 52;
}

- (void)dealloc{
    
    [_countDownbutton stopTimer];
}

#pragma mark - action

- (IBAction)buttonClick:(UIButton *)sender
{
    [self reconverKeyBord];
    
    if(![self.phoneNumber_textField.text isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号"];
        return;
    }
    
    if([NSString isEmpty:self.code_textField.text])
    {
        [self alertMsg:@"请输入验证码"];
        return;
    }
    else if(self.code_textField.text.length < WMPhoneNumberCodeInputLimitMax)
    {
        [self alertMsg:@"请输入6位的验证码"];
        
        return;
    }

    if ([NSString isEmpty:self.password_textField.text]) {
        
        [self alertMsg:@"请输入密码"];
        
        return;
    }
    else if (self.password_textField.text.length < WMPasswordInputLimitMin)
    {
        [self alertMsg:[NSString stringWithFormat:@"请输入%d-%d位的密码", WMPasswordInputLimitMin, WMPasswordInputLimitMax]];
        return;
    }

    if(![self.password_textField.text isEqualToString:self.confirm_password_textField.text])
    {
        [self alertMsg:@"两次密码不一致"];
        return;
    }

    [self resetPassword];
}

- (void)resetPassword
{
    self.requesting = YES;
    self.showNetworkActivity = YES;

    self.request.identifier = WMResetLogInPassWordIdentifier;

    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation resetLogInPassWordWithPhone:self.phoneNumber_textField.text newPassWord:self.password_textField.text code:self.code_textField.text]];
}

///获取验证码
- (void)loadImageCode
{
    self.request.identifier = WMResetLoginPasswordNeedIdentifier;
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation resetLoginPasswordNeedParams]];
}

///获取验证码
- (void)getCodeButtonClick:(SeaCountDownButton *)button{
    
    if(self.countDownbutton.timing)
        return;

    if([NSString isEmpty:self.phoneNumber_textField.text])
    {
        [self alertMsg:@"请输入手机号"];
        return;
    }
    
    if(self.phoneNumber_textField.text.length < WMPhoneNumberInputLimitMax)
    {
        [self alertMsg:@"请输入有效手机号"];
        return;
    }

    NSString *code = self.image_code_view.textField.text;
    if(!self.image_code_view.hidden && [NSString isEmpty:code])
    {
        [self alertMsg:@"请输入图形验证码"];
        return;
    }

    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGetPhoneCodeIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:self.phoneNumber_textField.text type:WMPhoneNumberCodeTypeForgot code:code]];
}

///密码可见切换
- (void)changePassWordSecureClick:(UIButton *)sender{
    
    self.eye_btn.selected = !self.eye_btn.selected;
    
    self.password_textField.secureTextEntry = sender.selected;
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.phoneNumber_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
    else if ([textField isEqual:self.password_textField] || [textField isEqual:self.confirm_password_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
    }
    else if ([textField isEqual:self.code_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_width_ == 320.0)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, _animatedDuration_ * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^(void){

            CGFloat maxoffsexY = self.scrollView.contentSize.height - (self.view.height - self.keyboardFrame.size.height);

            if(maxoffsexY > 0)
            {
                CGPoint offset = CGPointMake(0, MIN(textField.frame.origin.y - 5.0, maxoffsexY));

                [self.scrollView setContentOffset:offset animated:YES];
            }
        });
    }
}

#pragma mark - SeaHttpRequestDelegate

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        [self alerBadNetworkMsg:@"获取验证码失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMRegisterIdentifier])
    {
        [self alerBadNetworkMsg:@"重置登录密码失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMResetLogInPassWordIdentifier])
    {
        if([WMUserOperation resetLogInPassWordResultWithData:data])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"重置登陆密码成功，请使用新密码登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        return;
    }
    
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        if([WMUserOperation getPhoneCodeResultFromData:data])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码已发送，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];

            [self.code_textField becomeFirstResponder];
            [self.countDownbutton startTimer];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }


    if([request.identifier isEqualToString:WMResetLoginPasswordNeedIdentifier])
    {
        NSDictionary *dict = [WMUserOperation resetLoginPasswordNeedResultFromData:data];
        
        NSString *codeUrl = [dict sea_stringForKey:@"code"];
        
        if(![NSString isEmpty:codeUrl])
        {
            self.image_code_view.codeURL = codeUrl;
            
            [self setImageCodeHidden:NO];
        }
        else
        {
            [self setImageCodeHidden:YES];
        }
        
        self.tipButton.hidden = NO;
        
        self.phone = [dict sea_stringForKey:@"phone"];
        
        [self.tipButton setTitle:[NSString stringWithFormat:@"如无绑定手机号码，请联系商城客服处理，客服热线：%@",[dict sea_stringForKey:@"phone"]] forState:UIControlStateNormal];
        
        return;
    }
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

@end
