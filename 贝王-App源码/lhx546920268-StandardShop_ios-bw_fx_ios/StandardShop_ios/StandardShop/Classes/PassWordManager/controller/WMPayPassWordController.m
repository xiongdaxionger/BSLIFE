//
//  WMVerifyIdentityViewController.m
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPayPassWordController.h"

#import "WMImageVerificationCodeView.h"
#import "WMImageCodeViewCell.h"
#import "WMLogInPassWordInputViewCell.h"
#import "WMMessageCodeViewCell.h"

#import "WMPassWordOperation.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"
@interface WMPayPassWordController ()<SeaHttpRequestDelegate,WMLogInPassWordInputViewCellDelegate,UITextFieldDelegate,WMMessageCodeViewCellDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**是否需要图形验证码
 */
@property (assign,nonatomic) BOOL needImageCode;
/**验证身份的途径--用户没绑定手机号时使用登录密码验证，绑定了手机号用手机验证码验证
 */
@property (assign,nonatomic) BOOL needVerifyPhone;
/**返回的图形验证码路径
 */
@property (copy,nonatomic) NSString *imageCodeURL;
/**输入的登陆密码
 */
@property (copy,nonatomic) NSString *logInPassWord;
/**输入的图形验证码
 */
@property (copy,nonatomic) NSString *imageCode;
/**第一次输入的支付密码
 */
@property (copy,nonatomic) NSString *firstPayPassWord;
/**第二次输入的支付密码
 */
@property (copy,nonatomic) NSString *secondPayPassWord;
/**短信验证码
 */
@property (copy,nonatomic) NSString *phoneCode;
/**修改支付密码/忘记支付密码的信息字典--设置支付密码是为nil
 */
@property (strong,nonatomic) NSDictionary *payPassDict;
@end

@implementation WMPayPassWordController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;
        
        self.hidesBottomBarWhenPushed = YES;

        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.separatorEdgeInsets = UIEdgeInsetsZero;
    
    if (self.isSetPayPass) {
        
        self.title = @"设置支付密码";
        
        self.needVerifyPhone = NO;
        
        [self initialization];
    }
    else{
        
        self.title = self.isChangePayPass ? @"修改支付密码" : @"忘记支付密码";
        
        self.loading = YES;
        
        [self reloadDataFromNetwork];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.rowHeight = WMImageCodeViewCellHeight;

    [self.tableView registerNib:[UINib nibWithNibName:@"WMLogInPassWordInputViewCell" bundle:nil] forCellReuseIdentifier:WMLogInPassWordInputViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMImageCodeViewCell" bundle:nil] forCellReuseIdentifier:WMImageCodeViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageCodeViewCell" bundle:nil] forCellReuseIdentifier:WMMessageCodeViewCellIden];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, WMLongButtonHeight)];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, 0, _width_ - 2 * 8.0, WMLongButtonHeight)];
    
    [commitButton setTitle:@"确认" forState:UIControlStateNormal];
    
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    commitButton.backgroundColor = WMRedColor;
    
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    commitButton.layer.cornerRadius = 3.0;
    
    [footerView addSubview:commitButton];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - 确认按钮点击
- (void)commitButtonClick{
    
    if (self.needImageCode) {
        
        if ([NSString isEmpty:self.imageCode]) {
            
            [self alertMsg:@"请输入图形验证码"];
            
            return;
        }
    }
    
    if (self.needVerifyPhone) {
        
        if ([NSString isEmpty:self.phoneCode]) {
            
            [self alertMsg:@"请输入手机验证码"];
            
            return;
        }
    }
    else{
        
        if ([NSString isEmpty:self.logInPassWord]) {
            
            [self alertMsg:@"请输入登陆密码"];
            
            return;
        }
    }
    
    if ([NSString isEmpty:self.firstPayPassWord]) {
        
        [self alertMsg:@"请输入支付密码"];
        
        return;
    }
    
    if ([NSString isEmpty:self.secondPayPassWord]) {
        
        [self alertMsg:@"请再次输入支付密码"];
        
        return;
    }
    
    if (![NSString isEmpty:self.firstPayPassWord] && ![NSString isEmpty:self.secondPayPassWord]) {
        
        if (![self.firstPayPassWord isEqualToString:self.secondPayPassWord]) {
            
            [self alertMsg:@"两次输入的密码不一致，请更改"];
            
            return;
        }
    }
        
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    if (self.payPassDict) {
        
        self.request.identifier = WMVerifyPayPassWordIdentifier;
        
        if (self.needVerifyPhone) {
            
            //修改密码或忘记密码--通过手机验证修改或重设
            [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMPassWordOperation returnVerifyPayPassWordWithPhone:[[self.payPassDict dictionaryForKey:WMHttpData] sea_stringForKey:@"mobile"] phoneCode:self.phoneCode imageCode:nil firstPayPass:self.firstPayPassWord secPayPass:self.secondPayPassWord logInPass:nil]];
        }
        else{
            
            //修改密码或忘记密码--通过登录密码验证修改或重设
            [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMPassWordOperation returnVerifyPayPassWordWithPhone:nil phoneCode:nil imageCode:self.imageCode firstPayPass:self.firstPayPassWord secPayPass:self.secondPayPassWord logInPass:self.logInPassWord]];
        }
    }
    else{
        
        self.request.identifier = WMSetPayPassWordIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMPassWordOperation returnSetPayPassWordWithType:@"setpaypassword" code:self.imageCode logInPassWord:self.logInPassWord firstPayPass:self.firstPayPassWord secondPayPass:self.secondPayPassWord]];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.payPassDict) {
        
        if (self.needVerifyPhone) {
            
            return self.needImageCode ? 5 : 4;
        }
        else{
            
            return self.needImageCode ? 4 : 3;
        }
    }
    else{
        
        return self.needImageCode ? 4 : 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.payPassDict) {
        
        if (self.needVerifyPhone) {
            
            if (self.needImageCode) {
                
                if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
                    
                    WMLogInPassWordInputViewCell *inputCell = [tableView dequeueReusableCellWithIdentifier:WMLogInPassWordInputViewCellIden forIndexPath:indexPath];
                    
                    inputCell.delegate = self;
                    
                    if (indexPath.row == 0) {
                        
                        [inputCell configureWithContent:[[self.payPassDict dictionaryForKey:WMHttpData] sea_stringForKey:@"mobile"] type:InputTypePhone];
                    }
                    else if (indexPath.row == 3){
                        
                        [inputCell configureWithContent:self.firstPayPassWord type:InputTypeFirstPayPass];
                    }
                    else{
                        
                        [inputCell configureWithContent:self.secondPayPassWord type:InputTypeSecondPayPass];
                    }
                    
                    return inputCell;
                }
                else if (indexPath.row == 1){
                    
                    WMImageCodeViewCell *imageCodeCell = [tableView dequeueReusableCellWithIdentifier:WMImageCodeViewCellIden forIndexPath:indexPath];
                    
                    imageCodeCell.imageCodeView.codeURL = [self.payPassDict sea_stringForKey:@"code_url"];
                    
                    imageCodeCell.imageCodeView.textField.delegate = self;
                    
                    [imageCodeCell.imageCodeView.textField addTarget:self action:@selector(textContentChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    return imageCodeCell;
                }
                else{
                    
                    WeakSelf(self);
                    
                    WMMessageCodeViewCell *phoneCodeCell = [tableView dequeueReusableCellWithIdentifier:WMMessageCodeViewCellIden forIndexPath:indexPath];
                    
                    phoneCodeCell.delegate = self;
                    
                    [phoneCodeCell setGetMessageCode:^{
                        
                        [weakSelf getPhoneVerifyCode];
                    }];
                    
                    return phoneCodeCell;
                }
            }
            else{
                
                if (indexPath.row == 1) {
                    
                    WeakSelf(self);
                    
                    WMMessageCodeViewCell *phoneCodeCell = [tableView dequeueReusableCellWithIdentifier:WMMessageCodeViewCellIden forIndexPath:indexPath];
                    
                    phoneCodeCell.delegate = self;
                    
                    [phoneCodeCell setGetMessageCode:^{
                        
                        [weakSelf getPhoneVerifyCode];
                    }];
                    
                    return phoneCodeCell;
                }
                else{
                    
                    WMLogInPassWordInputViewCell *inputCell = [tableView dequeueReusableCellWithIdentifier:WMLogInPassWordInputViewCellIden forIndexPath:indexPath];
                    
                    inputCell.delegate = self;
                    
                    if (indexPath.row == 0) {
                        
                        [inputCell configureWithContent:[[self.payPassDict dictionaryForKey:WMHttpData] sea_stringForKey:@"mobile"] type:InputTypePhone];
                    }
                    else if (indexPath.row == 2){
                        
                        [inputCell configureWithContent:self.firstPayPassWord type:InputTypeFirstPayPass];
                    }
                    else{
                        
                        [inputCell configureWithContent:self.secondPayPassWord type:InputTypeSecondPayPass];
                    }
                    
                    return inputCell;
                }
            }
        }
        else{
            
            return [self verifyLogInPassWordCellWithIndexPath:indexPath];
        }
    }
    else{
        
        return [self verifyLogInPassWordCellWithIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}

- (UITableViewCell *)verifyLogInPassWordCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if (self.needImageCode) {
        
        if (indexPath.row == 1) {
            
            WMImageCodeViewCell *imageCell = [self.tableView dequeueReusableCellWithIdentifier:WMImageCodeViewCellIden forIndexPath:indexPath];
            
            imageCell.imageCodeView.codeURL = self.imageCodeURL;
                        
            imageCell.imageCodeView.textField.delegate = self;
            
            [imageCell.imageCodeView.textField addTarget:self action:@selector(textContentChange:) forControlEvents:UIControlEventEditingChanged];
            
            return imageCell;
        }
        else{
            
            WMLogInPassWordInputViewCell *inputCell = [self.tableView dequeueReusableCellWithIdentifier:WMLogInPassWordInputViewCellIden forIndexPath:indexPath];
            
            inputCell.delegate = self;
            
            switch (indexPath.row) {
                case 0:
                {
                    [inputCell configureWithContent:[NSString isEmpty:self.logInPassWord] ? @"" : self.logInPassWord type:InputTypeLogInPassWord];
                }
                    break;
                case 2:
                {
                    [inputCell configureWithContent:[NSString isEmpty:self.firstPayPassWord] ? @"" : self.firstPayPassWord type:InputTypeFirstPayPass];
                }
                    break;
                case 3:
                {
                    [inputCell configureWithContent:[NSString isEmpty:self.secondPayPassWord] ? @"" : self.secondPayPassWord type:InputTypeSecondPayPass];
                }
                default:
                    break;
            }
            
            return inputCell;
        }
    }
    else{
        
        WMLogInPassWordInputViewCell *inputCell = [self.tableView dequeueReusableCellWithIdentifier:WMLogInPassWordInputViewCellIden forIndexPath:indexPath];
        
        inputCell.delegate = self;
        
        switch (indexPath.row) {
            case 0:
            {
                [inputCell configureWithContent:[NSString isEmpty:self.logInPassWord] ? @"" : self.logInPassWord type:InputTypeLogInPassWord];
            }
                break;
            case 1:
            {
                [inputCell configureWithContent:[NSString isEmpty:self.firstPayPassWord] ? @"" : self.firstPayPassWord type:InputTypeFirstPayPass];
            }
                break;
            case 2:
            {
                [inputCell configureWithContent:[NSString isEmpty:self.secondPayPassWord] ? @"" : self.secondPayPassWord type:InputTypeSecondPayPass];
            }
                break;
            default:
                break;
        }
        
        return inputCell;
    }
}

#pragma mark - WMLogInPassWordInputViewCellDelegate
- (void)inputPassWordFinishWithPassWord:(NSString *)passWord type:(InputType)type{
    
    switch (type) {
        case InputTypeLogInPassWord:
        {
            self.logInPassWord = passWord;
        }
            break;
        case InputTypeFirstPayPass:
        {
            self.firstPayPassWord = passWord;
        }
            break;
        case InputTypeSecondPayPass:
        {
            self.secondPayPassWord = passWord;
        }
            break;
        default:
            break;
    }
}

#pragma mark - WMMessageCodeViewCellDelegate
- (void)messageCodeContentChange:(NSString *)code{
    
    self.phoneCode = code;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.imageCode = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textContentChange:(UITextField *)textField{
    
    self.imageCode = textField.text;
}

#pragma mark - 网络请求
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
    
    if ([request.identifier isEqualToString:WMGetVerifyPayPassWordInfoIdentifier]) {
        
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMSetPayPassWordIdentifier]) {
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        id result = [WMPassWordOperation returnVerifyLogInPassWordResultWithData:data];
        
        if ([result isKindOfClass:[NSNumber class]]) {
            
            if ([result boolValue]) {
                
                WMUserInfo *info = [WMUserInfo sharedUserInfo];
                
                info.has_pay_password = YES;
                
                [info saveUserInfoToUserDefaults];
                
                [self alertMsg:@"设置支付密码成功"];
                
                [self back];
                
                if (self.setPayPassWordSuccess) {
                    
                    WMUserInfo *info = [WMUserInfo sharedUserInfo];
                    
                    info.has_pay_password = YES;
                    
                    [info saveUserInfoToUserDefaults];
                    
                    self.setPayPassWordSuccess(self.secondPayPassWord);
                }
            }
        }
        else if ([result isKindOfClass:[NSString class]]){
            
            self.needImageCode = YES;
            
            self.imageCodeURL = (NSString *)result;
            
            NSLog(@"code url%@",self.imageCodeURL);
            
            [self.tableView reloadData];
        }
    }
    else if ([request.identifier isEqualToString:WMVerifyPayPassWordIdentifier]){
        
        id result = [WMPassWordOperation returnVerifyPayPassWordResultWithData:data];
        
        if ([result isKindOfClass:[NSNumber class]]) {
            
            if ([result boolValue]) {
                
                [self alertMsg:self.isChangePayPass ? @"修改支付密码成功" : @"重设支付密码成功"];
                
                [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
            }
        }
        else if ([result isKindOfClass:[NSDictionary class]]){
            
            self.needImageCode = YES;
            
            self.imageCodeURL = [result sea_stringForKey:@"code_url"];
            
            [self.tableView reloadData];
        }
    }
    else if ([request.identifier isEqualToString:WMGetPhoneCodeIdentifier]){
        
        if ([WMUserOperation getPhoneCodeResultFromData:data]) {
            
            [self alertMsg:@"验证码已发送"];
            
            WMMessageCodeViewCell *codeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.needImageCode ? 2 : 1 inSection:0]];
            
            [codeCell.countDownButton startTimer];
        }
    }
    else if ([request.identifier isEqualToString:WMGetVerifyPayPassWordInfoIdentifier]){
        
        NSDictionary *dict = [WMPassWordOperation returnGetUserIsBindingPhoneResultWithData:data];
        
        if (dict) {
            
            self.payPassDict = dict;
            
            self.needVerifyPhone = [[self.payPassDict numberForKey:@"site_sms_valide"] boolValue];
            
            if (self.needVerifyPhone) {
                
                self.needImageCode = [[self.payPassDict numberForKey:@"show_varycode"] boolValue];
            }
            else{
                
                self.needImageCode = NO;
            }
            
            if (!self.tableView) {
                
                [self initialization];
            }
        }
    }
}

#pragma mark - 获取短信验证码
- (void)getPhoneVerifyCode{
    
    if (self.needImageCode && [NSString isEmpty:self.imageCode]) {
        
        [self alertMsg:@"请输入图形验证码"];
        
        return;
    }
    
    self.request.identifier = WMGetPhoneCodeIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:[[self.payPassDict dictionaryForKey:WMHttpData] sea_stringForKey:@"mobile"] type:@"activation" code:self.needImageCode ? self.imageCode : nil]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

#pragma mark - 获取忘记/修改支付密码的设置信息
- (void)getVerifyPayPassWordSettingInfo{
    
    self.request.identifier = WMGetVerifyPayPassWordInfoIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMPassWordOperation returnGetUserIsBindingPhoneWithType:@"verifypaypassword"]];
}

#pragma mark - 重载网络
- (void)reloadDataFromNetwork{
    
    [self getVerifyPayPassWordSettingInfo];
}














@end
