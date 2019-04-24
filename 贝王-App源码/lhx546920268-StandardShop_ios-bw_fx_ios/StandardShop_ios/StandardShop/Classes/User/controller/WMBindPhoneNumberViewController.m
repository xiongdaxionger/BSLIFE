//
//  WMBindPhoneNumberViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBindPhoneNumberViewController.h"
#import "WMInputCell.h"
#import "WMInputInfo.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"
#import "WMSettingInfo.h"
#import <ShareSDK/ShareSDK.h>
#import "WMSocialLoginOperation.h"
#import "WMBindPhoneNumberFooter.h"

@interface WMBindPhoneNumberViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,UIAlertViewDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *httpRequest;

/**倒计时按钮
 */
@property (strong,nonatomic) SeaCountDownButton *countDownbutton;

/**底部
 */
@property (strong,nonatomic) WMBindPhoneNumberFooter *footer;

/**注册信息，数组元素是 WMInputInfo
 */
@property (strong,nonatomic) NSMutableArray *infos;

/**验证码链接
 */
@property (copy,nonatomic) NSString *codeURL;

/**图形验证码
 */
@property (strong, nonatomic) WMImageVerificationCodeView *image_code_view;

/**账号是否已存在
 */
@property (assign, nonatomic) BOOL isExist;

/**账号，不为空则表示当前账号已判断
 */
@property (copy, nonatomic) NSString *account;

/**检测完后是否直接绑定
 */
@property (assign, nonatomic) BOOL shouldBindAfterDetectAccount;

@end

@implementation WMBindPhoneNumberViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(is3_5Inch)
    {
        [self addKeyboardNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(is3_5Inch)
    {
        [self removeKeyboardNotification];
    }
}

- (void)dealloc
{
    [_countDownbutton stopTimer];
}

- (void)back
{
    [self reconverKeyBord];
    if(self.authorizedUser)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定放弃绑定手机号？" message:[NSString stringWithFormat:@"第三方登录如果没有绑定手机号将无法登入%@", appName()] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定", nil];
        [alertView show];
    }
    else
    {
        [super back];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.authorizedUser)
    {
        self.title = @"绑定手机号";
    }
    else
    {
        self.title = @"绑定手机号";
    }
    self.backItem = YES;
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStyleGrouped;
    
    self.infos = [NSMutableArray array];
    
    WMInputInfo *info = [WMInputInfo infoWithType:WMInputTypeAccount];
    [self.infos addObject:info];
    
    ///添加账号变动通知，第三方登录才需要
    if(self.authorizedUser)
    {
        WMInputTextFieldCell *cell = (WMInputTextFieldCell*)info.cell;
        if([cell isKindOfClass:[WMInputTextFieldCell class]])
        {
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    
    if(self.codeURL)
    {
        WMInputInfo *info = [WMInputInfo infoWithType:WMInputTypeImageCode];
        WMInputImageCodeCell *cell = (WMInputImageCodeCell*)info.cell;
        self.image_code_view = cell.codeView;
        self.image_code_view.textField.leftViewMode = UITextFieldViewModeNever;
        self.image_code_view.textField.placeholder = nil;
        self.image_code_view.codeURL = self.codeURL;
        
        [self.infos addObject:info];
    }
    
    info = [WMInputInfo infoWithType:WMInputTypeCode];
    [self.infos addObject:info];
    
    WMInputCountDownTextFieldCell *cell1 = (WMInputCountDownTextFieldCell*)info.cell;
    
    self.countDownbutton = cell1.countDownButton;
    [self.countDownbutton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.authorizedUser)
    {
        [self.infos addObject:[WMInputInfo infoWithType:WMInputTypePassword]];
    }
    
    for(WMInputInfo *info in self.infos)
    {
        info.cell.margin = 15.0;
    }
    
    [super initialization];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50.0;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    ///脚部
    /**
     CGFloat height = WMLongButtonHeight + 40.0;
     CGFloat margin = 15.0;
     UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, height)];
     footer.backgroundColor = [UIColor clearColor];
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(margin, height - WMLongButtonHeight, footer.width - margin * 2, WMLongButtonHeight);
     btn.backgroundColor = WMButtonBackgroundColor;
     btn.layer.cornerRadius = WMLongButtonCornerRaidus;
     [btn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
     [btn setTitle:@"确定" forState:UIControlStateNormal];
     [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
     btn.titleLabel.font = WMLongButtonTitleFont;
     [footer addSubview:btn];
     self.confirm_btn = btn;
     
     ///绑定已有手机号按钮
     if(self.authorizedUser)
     {
     btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(margin, self.confirm_btn.top - 35.0, 150.0, 25.0);
     [btn setTitleColor:WMRedColor forState:UIControlStateNormal];
     [btn setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
     [btn setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
     [btn setTitle:@" 绑定已注册手机号" forState:UIControlStateNormal];
     [btn addTarget:self action:@selector(associatedAction:) forControlEvents:UIControlEventTouchUpInside];
     btn.titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
     [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [footer addSubview:btn];
     self.associate_btn = btn;
     }
     
     self.tableView.tableFooterView = footer;
     **/
}

#pragma mark- action

///确定
- (IBAction)confirmAction:(UIButton *)sender
{
    [self reconverKeyBord];
    
    NSString *phoneNumber = nil;
    NSString *code = nil;
    NSString *password = nil;
    
    for(WMInputInfo *info in self.infos)
    {
        NSString *content = info.content;
        switch (info.type)
        {
            case WMInputTypeAccount :
            {
                if(![content isMobileNumber])
                {
                    [self alertMsg:@"请输入有效的手机号"];
                    return;
                }
                phoneNumber = content;
            }
                break;
            case WMInputTypeCode :
            {
                if([NSString isEmpty:content])
                {
                    [self alertMsg:@"请输入短信验证码"];
                    return;
                }
                code = content;
            }
                break;
            case WMInputTypePassword :
            {
                if ([NSString isEmpty:content])
                {
                    [self alertMsg:@"请输入密码"];
                    return;
                }
                else if (content.length < WMPasswordInputLimitMin)
                {
                    [self alertMsg:[NSString stringWithFormat:@"请输入%d-%d位的密码", WMPasswordInputLimitMin, WMPasswordInputLimitMax]];
                    return;
                }
                
                password = content;
            }
                break;
            default:
                break;
        }
    }
    
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    if(self.authorizedUser)
    {
        if([self.account isEqualToString:phoneNumber])
        {
            [self socialLoginAssociateAccount];
        }
        else
        {
            self.shouldBindAfterDetectAccount = YES;
            [self detectAccount];
        }
    }
    else
    {
        self.httpRequest.identifier = WMChangeBindPhoneIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation changeBindPhoneParam:phoneNumber vcode:code]];
    }
}

///第三方登录关联账号
- (void)socialLoginAssociateAccount
{
    NSString *phoneNumber = nil;
    NSString *code = nil;
    NSString *password = nil;
    
    for(WMInputInfo *info in self.infos)
    {
        NSString *content = info.content;
        switch (info.type)
        {
            case WMInputTypeAccount :
            {
                phoneNumber = content;
            }
                break;
            case WMInputTypeCode :
            {
                code = content;
            }
                break;
            case WMInputTypePassword :
            {
                password = content;
            }
                break;
            default:
                break;
        }
    }
    
    self.httpRequest.identifier = WMSocialoginAssociateAccountIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation socialoginAssociateAccount:phoneNumber password:password code:code SSDKUser:self.authorizedUser exist:self.isExist]];
}

///获取验证码
- (void)getCodeButtonClick:(SeaCountDownButton *)button{
    
    if(self.countDownbutton.timing)
        return;
    
    NSString *code = nil;
    NSString *phoneNumber = nil;
    
    for(WMInputInfo *info in self.infos)
    {
        NSString *content = info.content;
        switch (info.type)
        {
            case WMInputTypeAccount :
            {
                if(![content isMobileNumber])
                {
                    [self alertMsg:@"请输入有效的手机号"];
                    return;
                }
                phoneNumber = content;
            }
                break;
            case WMInputTypeImageCode :
            {
                if([NSString isEmpty:content])
                {
                    [self alertMsg:@"请输入图形验证码"];
                    return;
                }
                
                code = content;
            }
                break;
            default:
                break;
        }
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    self.httpRequest.identifier = WMGetPhoneCodeIdentifier;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:phoneNumber type:self.authorizedUser ? WMPhoneNumberCodeTypeSocialLogin : WMPhoneNumberCodeTypeBindPhone code:code]];
}

///跳过此操作
- (void)associatedAction:(UIButton*) btn
{
    btn.selected = !btn.selected;
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///获取验证码
- (void)loadImageCode
{
    if(self.authorizedUser)
    {
        self.httpRequest.identifier = WMSocialoginAssociateAccountNeedsIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation socialoginAssociateAccountNeedsParams]];
    }
    else
    {
        self.httpRequest.identifier = WMChangeBindPhoneNeedsIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation changeBindPhoneNeedsParams]];
    }
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"确定"])
    {
        [WMUserInfo logout];
        [super back];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        [self alerBadNetworkMsg:@"获取验证码失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMChangeBindPhoneNeedsIdentifier] || [request.identifier isEqualToString:WMSocialoginAssociateAccountNeedsIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMChangeBindPhoneIdentifier])
    {
        [self alerBadNetworkMsg:@"绑定手机号失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMDetectAccountExistIdentifier] || [request.identifier isEqualToString:WMSocialoginAssociateAccountIdentifier])
    {
        if(self.shouldBindAfterDetectAccount)
        {
            [self alerBadNetworkMsg:@"绑定手机号失败"];
        }
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        self.requesting = NO;
        if([WMUserOperation getPhoneCodeResultFromData:data])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码已发送，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            [self.countDownbutton startTimer];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMDetectAccountExistIdentifier])
    {
        NSString *msg = [WMUserOperation detectAccountExistResultFromData:data];
        if(msg)
        {
            self.isExist = YES;
        }
        else
        {
            self.isExist = NO;
        }
        
        ///显示提示信息
        [self.footer setMsg:msg];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView beginUpdates];
        
        WMInputInfo *info = [self.infos firstObject];
        self.account = info.content;
        
        return;
    }
    
    if([request.identifier isEqualToString:WMChangeBindPhoneNeedsIdentifier])
    {
        self.codeURL = [WMUserOperation changeBindPhoneNeedsFromData:data];
        [self initialization];
        
        return;
    }
    
    if([request.identifier isEqualToString:WMSocialoginAssociateAccountNeedsIdentifier])
    {
        self.codeURL = [WMUserOperation socialoginAssociateAccountNeedsFromData:data];
        [self initialization];
        
        return;
    }
    
    if([request.identifier isEqualToString:WMChangeBindPhoneIdentifier])
    {
        self.showNetworkActivity = NO;
        if([WMUserOperation changeBindPhoneResult:data])
        {
            self.leftBarButtonItem.enabled = NO;
            [[AppDelegate instance] alertMsg:@"绑定手机号成功"];
            
            NSString *phoneNumber = nil;
            
            for(WMInputInfo *info in self.infos)
            {
                NSString *content = info.content;
                switch (info.type)
                {
                    case WMInputTypeAccount :
                    {
                        phoneNumber = content;
                    }
                        break;
                    default:
                        break;
                }
            }
            if(self.settingInfo)
            {
                self.settingInfo.content = phoneNumber;
                self.settingInfo.selectable = NO;
            }
            
            [WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber = phoneNumber;
            [[WMUserInfo sharedUserInfo] saveUserInfoToUserDefaults];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMUserInfoDidModifyNotification object:self];
            [self performSelector:@selector(bindSuccess) withObject:nil afterDelay:1.0];
        }
        else
        {
            self.requesting = NO;
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMSocialoginAssociateAccountIdentifier])
    {
        self.showNetworkActivity = NO;
        if([WMUserOperation socialoginAssociateAccountFromData:data])
        {
            self.leftBarButtonItem.enabled = NO;
            [[AppDelegate instance] alertMsg:@"绑定手机号成功"];
            
            NSString *phoneNumber = nil;
            NSString *password = nil;
            
            for(WMInputInfo *info in self.infos)
            {
                NSString *content = info.content;
                switch (info.type)
                {
                    case WMInputTypeAccount :
                    {
                        phoneNumber = content;
                    }
                    case WMInputTypePassword :
                    {
                        password = content;
                    }
                        break;
                    default:
                        break;
                }
            }
            
            ///保存手机号和密码
            [SeaUserDefaults setObject:phoneNumber forKey:WMLoginAccount];
            [SeaUserDefaults setObject:password forKey:WMLoginPassword];
            
            [WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber = phoneNumber;
            [[WMUserInfo sharedUserInfo] saveUserInfoToUserDefaults];
            
            [self performSelector:@selector(bindSuccess) withObject:nil afterDelay:1.0];
        }
        else
        {
            self.requesting = NO;
            [self.image_code_view refreshCode];
        }
        
        return;
    }
}

///检测账号是否存在
- (void)detectAccount
{
    WMInputInfo *info = [self.infos firstObject];
    
    NSString *phoneNumber = info.content;
    if([phoneNumber isMobileNumber] && ![self.account isEqualToString:phoneNumber])
    {
        self.account = nil;
        self.httpRequest.identifier = WMDetectAccountExistIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation detectAccountExist:phoneNumber]];
    }
}

///绑定成功
- (void)bindSuccess
{
    if(self.authorizedUser)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMLoginSuccessNotification object:self];
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            
            !self.loginCompletionHandler ?: self.loginCompletionHandler();
        }];
    }
    else
    {
        [self back];
    }
}


///
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadImageCode];
}



#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section != 0)
    {
        if(!self.footer)
        {
            self.footer = [[WMBindPhoneNumberFooter alloc] init];
            [self.footer.confirm_btn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return self.footer.footerHeight;
    }
    
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section != 0)
    {
        return self.footer;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.infos.count;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMInputInfo *info = [self.infos objectAtIndex:indexPath.row];
    
    if([info.cell isKindOfClass:[WMInputTextFieldCell class]])
    {
        WMInputTextFieldCell *cell = (WMInputTextFieldCell*)info.cell;
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
    }
    else if ([info.cell isKindOfClass:[WMInputImageCodeCell class]])
    {
        WMInputImageCodeCell *cell = (WMInputImageCodeCell*)info.cell;
        cell.codeView.textField.tag = indexPath.row;
    }
    
    return info.cell;
}


#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    WMInputInfo *info = [self.infos objectAtIndex:textField.tag];
    if(info.type == WMInputTypeAccount)
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
    else if (info.type == WMInputTypePassword)
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
    }
    else if (info.type == WMInputTypeCode)
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
    }
    
    return YES;
}

///输入改变
- (void)textFieldDidChange:(UITextField*) textField
{
    self.shouldBindAfterDetectAccount = NO;
    [self detectAccount];
}

#pragma mark- UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(is3_5Inch)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
