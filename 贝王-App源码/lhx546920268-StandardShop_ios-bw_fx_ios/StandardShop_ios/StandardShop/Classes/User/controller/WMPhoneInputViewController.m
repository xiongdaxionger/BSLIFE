//
//  WMPhoneInputViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPhoneInputViewController.h"
#import "WMUserOperation.h"
#import "WMInputInfo.h"
#import "WMImageVerificationCodeView.h"
#import "WMCustomerServicePhoneInfo.h"
#import "WMSmsCodeFetchViewController.h"
#import "WMUserProtocolViewController.h"

@interface WMPhoneInputViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**注册信息，数组元素是 WMInputInfo
 */
@property (strong,nonatomic) NSArray *infos;

@end

@implementation WMPhoneInputViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    self.backItem = YES;
    self.title = @"手机快速注册";
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.phone_number_textField becomeFirstResponder];
}

///初始化
- (void)initialization
{
    self.loading = NO;
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
    
    self.phone_number_textField.leftView = label;
    self.phone_number_textField.leftViewMode = UITextFieldViewModeAlways;
    self.phone_number_textField.delegate = self;
    self.phone_number_textField.font = font;
    [self.phone_number_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    ///图形验证码
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
    label.font = font;
    self.image_code_view.textField.leftView = label;
    self.image_code_view.textField.leftViewMode = UITextFieldViewModeAlways;
    self.image_code_view.textField.placeholder = @"请输入图形验证码";
    [self.image_code_view.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.tick_btn setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    [self.tick_btn setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)]];
    
    self.tick_btn.selected = YES;
    [self changeBtnState];
}

///同意协议
- (IBAction)tickAction:(id)sender
{
    self.tick_btn.selected = !self.tick_btn.selected;
    [self changeBtnState];
}

///下一步
- (IBAction)nextAction:(id)sender
{
    if(![self.phone_number_textField.text isMobileNumber])
    {
        [self alertMsg:@"请输入正确的手机号"];
        return;
    }
    
    [self getCode];
}

///获取验证码
- (void)getCode
{
    NSString *code = self.image_code_view.textField.text;
    NSString *phoneNumber = self.phone_number_textField.text;
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMGetPhoneCodeIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:phoneNumber type:WMPhoneNumberCodeTypeRegister code:code]];
}

///点击协议
- (IBAction)protocolAction:(UIButton*) btn
{
    WMUserProtocolViewController *protocol = [[WMUserProtocolViewController alloc] init];
    protocol.title = btn.currentTitle;
    [self.navigationController pushViewController:protocol animated:YES];
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
    
    if([request.identifier isEqualToString:WMRegisterNeedIdentifier])
    {
        [self failToLoadData];
        
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
            WMSmsCodeFetchViewController *sms = [[WMSmsCodeFetchViewController alloc] init];
            sms.phoneNumber = self.phone_number_textField.text;
            sms.imageCodeURL = self.image_code_view.codeURL;
            sms.loginCompletionHandler = self.loginCompletionHandler;
            [self.navigationController pushViewController:sms animated:YES];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMRegisterNeedIdentifier])
    {
        NSArray *infos = [WMUserOperation registerInfosFromData:data];
        if(infos)
        {
            self.infos = infos;
            [self shouldUseImageCode];
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }
        
        return;
    }
}

///
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadImageCode];
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///获取验证码
- (void)loadImageCode
{
    self.httpRequest.identifier = WMRegisterNeedIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation registerInfosParams]];
}

///判断是否能够下一步
- (BOOL)enableNext
{
    if(!self.tick_btn.selected)
        return NO;
    
    if([NSString isEmpty:self.phone_number_textField.text])
    {
        return NO;
    }
    
    if(!self.image_code_view.hidden && [NSString isEmpty:self.image_code_view.textField.text])
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

///检测是否需要图形验证码
- (void)shouldUseImageCode
{
    NSString *codeURL = nil;
    for(WMInputInfo *info in self.infos)
    {
        if(info.type == WMInputTypeImageCode)
        {
            codeURL = info.codeURL;
            break;
        }
    }
    
    if(![NSString isEmpty:codeURL])
    {
        self.image_code_view.codeURL = codeURL;
        [self setImageCodeHidden:NO];
    }
    else
    {
        [self setImageCodeHidden:YES];;
    }
}

///设置图形验证码显示
- (void)setImageCodeHidden:(BOOL) hidden
{
    
    self.image_code_view.hidden = hidden;
    if(self.image_code_view.hidden)
    {
        self.tick_btn_topLayoutConstraint.constant = 10.0;
    }
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

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.phone_number_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
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
