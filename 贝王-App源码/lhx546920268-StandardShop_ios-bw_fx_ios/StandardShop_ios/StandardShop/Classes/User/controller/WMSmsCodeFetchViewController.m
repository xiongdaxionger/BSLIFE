//
//  WMSmsCodeFetchViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSmsCodeFetchViewController.h"
#import "WMCustomerServicePhoneInfo.h"
#import "WMUserOperation.h"
#import "WMImageVerificationCodeView.h"
#import "WMRegisterViewController.h"
#import "WMLoginViewController.h"
#import "WMRegisterViewController.h"

@interface WMSmsCodeFetchViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,UIAlertViewDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMSmsCodeFetchViewController

- (void)dealloc
{
    [self.countDownButton stopTimer];
}

- (void)back
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"点击“返回”将中断注册流程" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定", nil];
    [alertView show];
}

#pragma mark- UIAlertView delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"确定"])
    {
        UIViewController *vc = [self.navigationController.viewControllers firstObject];
        if([vc isKindOfClass:[WMLoginViewController class]])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self backToRootViewControllerWithAnimated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.code_textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.backItem = YES;
    self.title = @"手机快速注册";
    self.msg_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.msg_label.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码", self.phoneNumber];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.next_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.next_btn.layer.masksToBounds = YES;
    self.next_btn.titleLabel.font = WMLongButtonTitleFont;
    self.next_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
    [self.next_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [self.next_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    //账号名称
    CGFloat width = 15.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
    label.font = font;
    
    self.code_textField.leftView = label;
    self.code_textField.leftViewMode = UITextFieldViewModeAlways;
    self.code_textField.delegate = self;
    self.code_textField.font = font;
    [self.code_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    ///图形验证码
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
    label.font = font;
    self.image_code_view.textField.leftView = label;
    self.image_code_view.textField.leftViewMode = UITextFieldViewModeAlways;
    self.image_code_view.textField.placeholder = @"请输入图形验证码";
    [self.image_code_view.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)]];
    
    self.countDownButton.normalTitle = @"重新发送";
    self.countDownButton.disableTitle = @"重新发送";
    
     self.image_code_view.hidden = YES;
    [self.countDownButton startTimer];
    
    WeakSelf(self);
    self.countDownButton.countDownDidEndHandler = ^(void){
        
        if(weakSelf.image_code_view.hidden && ![NSString isEmpty:weakSelf.imageCodeURL])
        {
            weakSelf.image_code_view.codeURL = weakSelf.imageCodeURL;
            [weakSelf setImageCodeHidden:NO];
            [weakSelf.image_code_view refreshCode];
        }
    };
    
    
    [self changeBtnState];
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///重新获取短信验证码
- (IBAction)getCodeAction:(id)sender
{
    NSString *code = self.image_code_view.textField.text;
    if(!self.image_code_view.hidden && [NSString isEmpty:code])
    {
        [self alertMsg:@"请输入图形验证码"];
        return;
    }
    NSString *phoneNumber = self.phoneNumber;
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMGetPhoneCodeIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:phoneNumber type:WMPhoneNumberCodeTypeRegister code:code]];
}

///下一步
- (IBAction)nextAction:(id)sender
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMGetSendedCodeIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getSendedCodeParamWithPhoneNumber:self.phoneNumber type:WMPhoneNumberCodeTypeRegister]];
}

///联系客服
- (IBAction)callCumstomService:(id)sender
{
    if([WMCustomerServicePhoneInfo shareInstance].loading)
        return;
    NSString *phone = [WMCustomerServicePhoneInfo shareInstance].call;
    if([NSString isEmpty:phone]){
        
        WeakSelf(self);
        self.showNetworkActivity = YES;
        self.requesting = YES;
        [[WMCustomerServicePhoneInfo shareInstance] loadInfoWithCompletion:^(void){
            
            weakSelf.requesting = NO;
            makePhoneCall([WMCustomerServicePhoneInfo shareInstance].call, YES);
        }];
        
    }else{
        
        makePhoneCall(phone, YES);
    }
}


///判断是否能够下一步
- (BOOL)enableNext
{
    if([NSString isEmpty:self.code_textField.text])
    {
        return NO;
    }
    
    return YES;
}

///改变按钮状态
- (void)changeBtnState
{
    self.next_btn.enabled = [self enableNext];
    self.next_btn.backgroundColor = self.next_btn.enabled ? WMButtonBackgroundColor : WMButtonDisableBackgroundColor;
}

///设置图形验证码显示
- (void)setImageCodeHidden:(BOOL) hidden
{
    self.image_code_view.hidden = hidden;
    if(!self.image_code_view.hidden)
    {
        self.next_btn_topLayoutConstraint.constant = 100;
    }
}

#pragma mark - SeaHttpRequest delegate

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        [self alerBadNetworkMsg:@"获取验证码失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMGetSendedCodeIdentifier])
    {
        [self alerBadNetworkMsg:@"验证失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        if([WMUserOperation getPhoneCodeResultFromData:data])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码已发送，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            [self.countDownButton startTimer];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMGetSendedCodeIdentifier])
    {
        NSString *code = [WMUserOperation getSendedCodeFromData:data];
        if(code)
        {
            if([code isEqualToString:self.code_textField.text])
            {
                WMRegisterViewController *regist = [[WMRegisterViewController alloc] init];
                regist.phoneNumber = self.phoneNumber;
                regist.smsCode = code;
                regist.loginCompletionHandler = self.loginCompletionHandler;
                [self.navigationController pushViewController:regist animated:YES];
            }
            else
            {
                [self alertMsg:@"输入的验证码有误"];
            }
        }
        else
        {
            [self alertMsg:@"输入的验证码有误"];
        }
    }
}

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.code_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
    }
    else if ([textField isEqual:self.image_code_view.textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMImageCodeInputLimitMax];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

///文本输入框改变
- (void)textFieldDidChange:(UITextField*) textField
{
    [self changeBtnState];
}

@end
