//
//  WMRegisterViewController.m
//  AKYP
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMRegisterViewController.h"
#import "WMUserProtocolViewController.h"
#import "SeaCountDownButton.h"
#import "WMUserOperation.h"
#import "WMImageVerificationCodeView.h"
#import "WMInputInfo.h"
#import "WMInputCell.h"
#import "WMAreaSelectViewController.h"
#import "UBPicker.h"
#import "WMShippingAddressOperation.h"
#import "WMShippingAddressInfo.h"
#import "WMPrivacyPolicyViewController.h"
#import "WMSelectionViewController.h"
#import "WMUserInfo.h"
#import "WMCustomerServicePhoneInfo.h"
#import "WMLoginViewController.h"

@interface WMRegisterViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,WMAreaSelectViewControllerDelegate,UBPickerDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;

/**是否是第一次
 */
@property(nonatomic,assign) BOOL isFirst;

/**选中的cell
 */
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

/**底部
 */
@property(nonatomic,strong) WMRegisterFooter *footer;

/**选择器
 */
@property(nonatomic, strong) UBPicker *picker;

@end

@implementation WMRegisterViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.footer.password_textField becomeFirstResponder];
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

#pragma mark - 控制器的生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手机快速注册";
    
    [WMUserInfo logout];
    
    self.backItem = YES;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self initialization];
}

- (void)initialization
{
    self.separatorEdgeInsets = UIEdgeInsetsMake(0, WMInputCellMargin, 0, WMInputCellMargin);
    self.loading = NO;
    self.style = UITableViewStylePlain;

    [super initialization];

    ///添加头部和底部
//    WMRegisterHeader *header = [[WMRegisterHeader alloc] init];
//    self.tableView.tableHeaderView = header;

    WMRegisterFooter *footer = [[WMRegisterFooter alloc] init];
    [footer.register_btn addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer.service_btn addTarget:self action:@selector(callCumstomService:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footer;
    self.footer = footer;

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.rowHeight = 50.0;
}

#pragma mark - 控件的点击事件

///联系客服
- (void)callCumstomService:(id)sender
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

///注册
- (void)registerButtonClick:(UIButton *)sender
{
    [self reconverKeyBord];
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.request.identifier = WMRegisterIdentifier;
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation registerParamsWithPhoneNumber:self.phoneNumber code:self.smsCode password:self.footer.password_textField.text]];
    
//    for(WMInputInfo *info in self.infos)
//    {
//        NSString *content = info.content;
//        switch (info.type)
//        {
//            case WMInputTypePassword :
//            {
//                if (content.length < WMPasswordInputLimitMin)
//                {
//                    [self alertMsg:[NSString stringWithFormat:@"请输入%d-%d位的密码", WMPasswordInputLimitMin, WMPasswordInputLimitMax]];
//                    return;
//                }
//            }
//                break;
//            case WMInputTypeName :
//            case WMInputTypeOther :
//            {
//                
//                switch (info.contentType)
//                {
//                    case WMInputContentTypeLetterAndNumber :
//                    case WMInputContentTypeLetter :
//                    case WMInputContentTypeNumber :
//                    case WMInputContentTypeTextUnlimited :
//                    {
//                        switch (info.contentType)
//                        {
//                            case WMInputContentTypeNumber :
//                            {
//                                if(![NSString isEmpty:content] && ![content isNumText])
//                                {
//                                    [self alertMsg:[NSString stringWithFormat:@"%@只能输入数字", info.title]];
//                                    return;
//                                }
//                            }
//                                break;
//                            case WMInputContentTypeLetter :
//                            {
//                                if(![NSString isEmpty:content] && ![content isLetterText])
//                                {
//                                    [self alertMsg:[NSString stringWithFormat:@"%@只能输入字母", info.title]];
//                                    return;
//                                }
//                            }
//                                break;
//                            case WMInputContentTypeLetterAndNumber :
//                            {
//                                if(![NSString isEmpty:content] && ![content isLetterAndNumberText])
//                                {
//                                    [self alertMsg:[NSString stringWithFormat:@"%@只能输入字母和数字", info.title]];
//                                    return;
//                                }
//                            }
//                                break;
//                            default:
//                                break;
//                        }
//                    }
//                        break;
//                    default:
//                        break;
//                }
//            }
//                break;
//            default:
//                break;
//        }
//    }

  
}


///回收键盘
- (void)reconverKeyBord
{
    self.isFirst = NO;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///获取验证码
- (void)loadImageCode
{
    self.request.identifier = WMRegisterNeedIdentifier;
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation registerInfosParams]];
}

///判断是否能够注册 是否提示信息
- (BOOL)enableRegister:(BOOL) flag
{
    for(WMInputInfo *info in self.infos)
    {
        NSString *content = info.content;
        switch (info.type)
        {
            case WMInputTypeAccount :
            case WMInputTypeCode :
            case WMInputTypePassword :
            {
                if([NSString isEmpty:content])
                {
                    return NO;
                }
            }
                break;
            case WMInputTypeName :
            case WMInputTypeOther :
            {
                switch (info.contentType)
                {
                    case WMInputContentTypeLetterAndNumber :
                    case WMInputContentTypeLetter :
                    case WMInputContentTypeNumber :
                    case WMInputContentTypeTextUnlimited :
                    {
                        if(info.required && [NSString isEmpty:content])
                        {
                            return NO;
                        }
                    }
                        break;
                    default:
                    {
                        if(info.required && [NSString isEmpty:content])
                        {
                            return NO;
                        }
                    }
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
    
    return YES;
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMInputInfo *info = [self.infos objectAtIndex:indexPath.row];

    if([info.cell isKindOfClass:[WMInputTextFieldCell class]])
    {
        WMInputTextFieldCell *cell = (WMInputTextFieldCell*)info.cell;
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        
        if(cell.textField.allTargets.count == 0)
        {
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    else if ([info.cell isKindOfClass:[WMInputImageCodeCell class]])
    {
        WMInputImageCodeCell *cell = (WMInputImageCodeCell*)info.cell;
        cell.codeView.textField.tag = indexPath.row;
    }

    return info.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.selectedIndexPath = indexPath;
    WMInputInfo *info = [self.infos objectAtIndex:indexPath.row];

    [self reconverKeyBord];

    switch (info.type)
    {
        case WMInputTypeOther :
        {
            switch (info.contentType)
            {
                case WMInputContentTypeArea :
                {
                    WMAreaSelectViewController *area = [[WMAreaSelectViewController alloc] init];
                    area.delegate = self;
                    area.rootViewController = self;
                    [self.navigationController pushViewController:area animated:YES];
                }
                    break;
                case WMInputContentTypeDate :
                {
                    [self pickerBirthday];
                }
                    break;
                case WMInputContentTypeMultipleSelection :
                case WMInputContentTypeRadio :
                {
                    WMSelectionViewController *selection = [[WMSelectionViewController alloc] init];
                    selection.options = info.options;
                    selection.selectedOptions = info.selectedOptions;
                    selection.allowsMultipleSelection = info.contentType == WMInputContentTypeMultipleSelection;
                    selection.title = info.title;

                    WMInputSelectedCell *cell = (WMInputSelectedCell*)info.cell;
                    selection.completionHandler = ^(NSMutableArray *selectedOptions){

                        info.selectedOptions = selectedOptions;
                        info.selectedOptionsString = nil;
                        cell.content = info.selectedOptionsString;
                        self.footer.enableRegister = [self enableRegister:NO];
                    };
                    [self.navigationController pushViewController:selection animated:YES];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark- WMAreaSelectViewController delegate

- (void)areaSelectViewController:(WMAreaSelectViewController *)view didSelectArea:(NSString *)area
{
    WMInputInfo *inputInfo = [self.infos objectAtIndex:self.selectedIndexPath.row];
    if(![area isEqualToString:inputInfo.content])
    {
        NSString *value = [WMShippingAddressOperation combineAreaParamFromInfos:view.selectedInfos];
        inputInfo.area = value;
        
        WMInputSelectedCell *cell = (WMInputSelectedCell*)inputInfo.cell;
        cell.content = area;
        self.footer.enableRegister = [self enableRegister:NO];
    }
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
    else if (info.type == WMInputTypeName)
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCountChinesseAsTwoChar:WMUserNameInputLimitMax];
    }

    return YES;
}

///文本输入框改变
- (void)textFieldDidChange:(UITextField*) textField
{
    self.footer.enableRegister = [self enableRegister:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.isFirst = NO;
    
    return YES;
}

#pragma mark - SeaHttpRequest delegate

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMRegisterIdentifier])
    {
        [self alerBadNetworkMsg:@"注册失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    if([request.identifier isEqualToString:WMRegisterIdentifier])
    {
        if([WMUserOperation registerResultFromData:data])
        {
            [self showSuccess];
        }

        return;
    }
}

///显示注册成功
- (void)showSuccess
{
    NSString *account = self.phoneNumber;
    NSString *password = self.footer.password_textField.text;

//    for(WMInputInfo *info in self.infos)
//    {
//        if(info.type == WMInputTypeAccount)
//        {
//            account = info.content;
//        }
//        else if (info.type == WMInputTypePassword)
//        {
//            password = info.content;
//        }
//    }

    [SeaUserDefaults setObject:account forKey:WMLoginAccount];
    [SeaUserDefaults setObject:password forKey:WMLoginPassword];

    [[NSNotificationCenter defaultCenter] postNotificationName:WMLoginSuccessNotification object:self];

    [self dismissViewControllerAnimated:YES completion:^(void){

        !self.loginCompletionHandler ? : self.loginCompletionHandler();
    }];

//    WMRegisterSuccessViewController *success = [[WMRegisterSuccessViewController alloc] init];
//    success.loginCompletionHandler = self.loginCompletionHandler;
//    [self.navigationController pushViewController:success animated:YES];
}

#pragma mark- UBPicker

///选择生日
- (void)pickerBirthday
{
    self.picker = [[UBPicker alloc] initWithSuperView:self.view style:UBPickerStyleBirthDay];

    WMInputInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];
    NSString *birthday = info.content;

    NSDate *date = nil;
    if(![NSString isEmpty:birthday])
    {
        date = [NSDate dateFromString:birthday format:DateFromatYMd];
    }

    if(!date)
    {
        date = [NSDate dateWithTimeIntervalSinceNow:- 365 * 24 * 60 * 60 * 16];
    }

    self.picker.datePicker.date = date;

    self.picker.delegate = self;
    [self.picker showWithAnimated:YES completion:nil];
}

- (void)pickerWillAppear:(UBPicker *)picker
{
    [UIView animateWithDuration:0.25 animations:^(void){

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, _UBPickerHeight_, 0);
    }];

    [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)pickerWillDismiss:(UBPicker *)picker
{
    [UIView animateWithDuration:0.25 animations:^(void){

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions
{
    NSString *birthday = [conditions objectForKey:@(picker.style)];
    WMInputInfo *info = [self.infos objectAtIndex:self.selectedIndexPath.row];

    if(![birthday isEqualToString:info.content])
    {
        WMInputSelectedCell *cell = (WMInputSelectedCell*)info.cell;
        cell.content = birthday;
        self.footer.enableRegister = [self enableRegister:NO];
    }
}

@end
