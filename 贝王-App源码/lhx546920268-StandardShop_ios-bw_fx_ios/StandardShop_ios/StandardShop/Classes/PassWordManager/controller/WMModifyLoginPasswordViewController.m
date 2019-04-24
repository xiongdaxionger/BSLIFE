//
//  WMModifyLoginPasswordViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMModifyLoginPasswordViewController.h"
#import "WMUserInfo.h"
#import "WMPassWordOperation.h"

@interface WMModifyLoginPasswordViewController ()<SeaHttpRequestDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMModifyLoginPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.backItem = YES;
    self.title = @"修改登录密码";
    
    CGFloat width = 8.0;
    UIFont *font = [UIFont fontWithName:MainFontName size:16.0];
    SeaTextInsetLabel *label = [[SeaTextInsetLabel alloc] initWithFrame:CGRectMake(0, 0, width, 30.0)];
    label.font = font;
    label.insets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    label.textColor = [UIColor blackColor];
    self.org_passwdTextField.leftView = label;
    self.org_passwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.org_passwdTextField.font = [UIFont fontWithName:MainFontName size:15.0];
    self.org_passwdTextField.delegate = self;
    self.org_passwdTextField.placeholder = @"请输入原登录密码";
    
    label = [[SeaTextInsetLabel alloc] initWithFrame:CGRectMake(0, 0, width, 30.0)];
    label.insets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    label.font = font;
    label.textColor = [UIColor blackColor];
    self.news_passwdTextField.leftView = label;
    self.news_passwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.news_passwdTextField.font = [UIFont fontWithName:MainFontName size:15.0];
    self.news_passwdTextField.delegate = self;
    self.news_passwdTextField.placeholder = [NSString stringWithFormat:@"请输入新密码，必须为%d-%d个字符", WMPasswordInputLimitMin, WMPasswordInputLimitMax];
    
    label = [[SeaTextInsetLabel alloc] initWithFrame:CGRectMake(0, 0, width, 30.0)];
    label.insets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    label.font = font;
    label.textColor = [UIColor blackColor];
    self.confirm_passwdTextField.leftView = label;
    self.confirm_passwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirm_passwdTextField.font = [UIFont fontWithName:MainFontName size:15.0];
    self.confirm_passwdTextField.delegate = self;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)];
    [self.view addGestureRecognizer:tap];
    
    self.confirm_btn.backgroundColor = WMButtonBackgroundColor;
    self.confirm_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.confirm_btn.layer.masksToBounds = YES;
    self.confirm_btn.titleLabel.font = WMLongButtonTitleFont;
    [self.confirm_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    self.confirm_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
}

//回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/**确认修改
 */
- (IBAction)confirmModify:(id)sender
{
    if(self.org_passwdTextField.text.length == 0)
    {
        [self alertMsg:@"请输入原密码"];
        return;
    }
    
    if(self.org_passwdTextField.text.length < WMPasswordInputLimitMin)
    {
        [self alertMsg:@"原密码错误"];
        return;
    }
    
    if(self.news_passwdTextField.text.length == 0)
    {
        [self alertMsg:@"请输入新密码"];
        return;
    }
    
    if(self.news_passwdTextField.text.length < WMPasswordInputLimitMin)
    {
        [self alertMsg:[NSString stringWithFormat:@"请输入%d-%d位的新密码", WMPasswordInputLimitMin, WMPasswordInputLimitMax]];
        return;
    }
    
    if(![self.news_passwdTextField.text isEqualToString:self.confirm_passwdTextField.text])
    {
        [self alertMsg:@"新密码和确认密码不一致"];
        return;
    }
    
    [self reconverKeyBord];
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPassWordOperation modifyPasswdParamWithOrg:self.org_passwdTextField.text news:self.news_passwdTextField.text confirm:self.confirm_passwdTextField.text]];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    [self alerBadNetworkMsg:@"登录失败"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([WMPassWordOperation returnModifyPassWordReslutWithData:data])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
