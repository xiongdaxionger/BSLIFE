//
//  WMAddWithDrawAccountViewController.m
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMAddWithDrawAccountViewController.h"
#import "WMBalanceOperation.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"
#import "UBPicker.h"
#import "SeaTextFieldCell.h"

@interface WMAddWithDrawAccountViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,UBPickerDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**银行卡配置的单元格数组 数组元素是 SeaTextFieldInfo
 */
@property (strong,nonatomic) NSMutableArray *blankCellInfos;
/**支付宝配置的单元格数组 数组元素是 SeaTextFieldInfo
 */
@property (strong,nonatomic) NSMutableArray *payCellInfos;

///手机号码、验证码、图形验证码等信息 数组元素是 SeaTextFieldInfo
@property (strong,nonatomic) NSMutableArray *codeInfos;

///数据源 数组元素是 NSArray,数组元素是 SeaTextFieldInfo
@property (strong,nonatomic) NSMutableArray *infos;

/**添加账号的类型
 */
@property (assign,nonatomic) NSInteger accountType;
/**操作类
 */
@property (strong,nonatomic) WMBalanceOperation *operation;
/**选择器
 */
@property (strong,nonatomic) UBPicker *picker;

///银行卡号
@property (strong,nonatomic) UITextField *bankCardTextField;

///持卡人
@property (strong,nonatomic) UITextField *cardHolderTextField;

///选择的发卡银行
@property (strong,nonatomic) UITextField *selectedBankTextField;

///输入的发卡银行
@property (strong,nonatomic) UITextField *inputBankTextField;

///图形验证码
@property (strong,nonatomic) SeaImageCodeTextFieldCell *imageCodeCell;

///短信验证码
@property (strong,nonatomic) UITextField *codeTextField;

///手机号码
@property (strong,nonatomic) UITextField *phoneNumberTextField;

///支付宝账号
@property (strong,nonatomic) UITextField *aliAccountTextField;

///支付宝账号名字
@property (strong,nonatomic) UITextField *aliHolderTextField;

///验证码按钮
@property (strong,nonatomic) SeaCountDownButton *countDownButton;

@end

@implementation WMAddWithDrawAccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_width_ == 320.0)
    {
        [self addKeyboardNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if(_width_ == 320.0)
    {
        [self removeKeyboardNotification];
    }
}

- (void)dealloc
{
    [self.countDownButton stopTimer];
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"提现账户";
    
    self.backItem = YES;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    self.accountType = 0;
    
    [self initialization];
}

#pragma mark - 初始化
- (void)initialization{
    
    WeakSelf(self);

    [self getAliInfos];
    [self getCodeInfos];
    [self getBlankCellInfos];

    _operation = [[WMBalanceOperation alloc] init];

    [_operation setCommitButtonAction:^{
        
        [weakSelf commitGetMoneyAction];
    }];
    
    [_operation setSegementAction:^(UISegmentedControl *segement) {
        
        [weakSelf segementControlTap:segement];
    }];

    [self segementControlTap:nil];
    
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    self.tableView.rowHeight = 45.0;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.tableHeaderView = [_operation returnSegementControlView];
    
    self.tableView.tableFooterView = [_operation returnFooterView];
}

#pragma mark - 获取验证码

///获取短信验证码
- (void)getMessageCode
{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(![self.phoneNumberTextField.text isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号码"];
        
        return;
    }

    if(![NSString isEmpty:self.codeURL] && [NSString isEmpty:self.imageCodeCell.textField.text])
    {
        [self alertMsg:@"请输入短信验证码"];
        
        return;
    }
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGetPhoneCodeIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:self.phoneNumberTextField.text type:WMPhoneNumberCodeTypeActivation code:self.imageCodeCell.textField.text]];
}

#pragma mark - 确定提现

///确定
- (void)commitGetMoneyAction
{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    

    if (self.accountType == 0)
    {
        NSString *blankNumber = self.bankCardTextField.text;
        
        if ([NSString isEmpty:blankNumber])
        {
            [self alertMsg:@"请输入银行卡号"];
            return;
        }
        else if (blankNumber.length < WMBlankCardNumInputLimitMin)
        {
            [self alertMsg:@"请输入有效的银行卡号"];
            return;
        }
        
        NSString *blankPersonName = self.cardHolderTextField.text;
        
        if ([NSString isEmpty:blankPersonName])
        {
            [self alertMsg:@"请输入持卡人姓名"];
            return;
        }
        
        NSString *blankName = self.selectedBankTextField.text;
        
        if ([NSString isEmpty:blankName])
        {
            [self alertMsg:@"请选择发卡银行"];
            return;
        }
        else if ([blankName isEqualToString:@"其他"])
        {
            blankName = self.inputBankTextField.text;
            if([NSString isEmpty:blankName])
            {
                [self alertMsg:@"请输入发卡银行"];
                return;
            }
        }
    }
    else
    {
        NSString *aLiPayCount = self.aliAccountTextField.text;

        if ([NSString isEmpty:aLiPayCount])
        {
            [self alertMsg:@"请输入支付宝账号"];
            return;
        }
        
        if(![aLiPayCount isMobileNumber] && ![aLiPayCount isEmail])
        {
            [self alertMsg:@"请输入有效支付宝账号"];
            return;
        }
        
        NSString *aLiPayName = self.aliHolderTextField.text;
        
        if ([NSString isEmpty:aLiPayName])
        {
            [self alertMsg:@"请输入支付宝用户名"];
            return;
        }
    }

    if(![self.phoneNumberTextField.text isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号码"];
        return;
    }

    if ([NSString isEmpty:self.codeTextField.text]) {
        
        [self alertMsg:@"请输入验证码"];
        return;
    }
    
    if (self.codeTextField.text.length < WMPhoneNumberCodeInputLimitMax)
    {
        [self alertMsg:@"请输入有效的验证码"];
        return;
    }
    
    self.request.identifier = WMAddAccountInfoIdentifier;
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    if (self.accountType == 0)
    {
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnAddAccountParamWith:self.blankCellInfos accountType:self.accountType phoneCode:self.codeTextField.text]];
    }
    else
    {
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnAddAccountParamWith:self.payCellInfos accountType:self.accountType phoneCode:self.codeTextField.text]];
    }
}

#pragma mark - 分段控件的点击
- (void)segementControlTap:(UISegmentedControl *)segement{
    
    self.accountType = segement.selectedSegmentIndex;

    if(!self.infos)
    {
        self.infos = [NSMutableArray arrayWithCapacity:2];
        [self.infos addObject:self.codeInfos];
    }

    if(self.infos.count == 2)
        [self.infos removeObjectAtIndex:0];

    if(segement.selectedSegmentIndex == 0)
    {
        [self.infos insertObject:self.blankCellInfos atIndex:0];
    }
    else
    {
        [self.infos insertObject:self.payCellInfos atIndex:0];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 网络回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMGetPhoneCodeIdentifier])
    {
        [self alerBadNetworkMsg:@"获取验证码失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
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
        else{
            
            if (![NSString isEmpty:self.codeURL]) {
                
                [self.imageCodeCell refreshCode];
            }
        }
        
        return;
    }
    else if ([request.identifier isEqualToString:WMAddAccountInfoIdentifier]){
        
        if ([WMBalanceOperation returnAddAccountResultWithData:data]) {
            
            [self alertMsg:@"添加账户成功"];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAccountSuccess" object:nil];
        }
    }
}

#pragma mark - 文本框的协议

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.bankCardTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string formatTextWithInterval:WMBlankCardNumFormatInterval limitCount:WMBlankCardNumInputLimitMax];
    }
    else if ([textField isEqual:self.cardHolderTextField] || [textField isEqual:self.aliHolderTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMWithdrawAccountHolderInputLimitMax];
    }
    else if ([textField isEqual:self.aliAccountTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMALiPayAccountInputLimitMax];
    }
    else if ([textField isEqual:self.phoneNumberTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
    }
    else if ([textField isEqual:self.codeTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.selectedBankTextField])
    {
        [self selectBlank];
        return NO;
    }
    
    return YES;
}

#pragma mark - 回收jianpan

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


#pragma mark - 表格视图的协议

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.infos objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeaTextFieldInfo *info = [[self.infos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return info.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    SeaTextFieldInfo *info = [[self.infos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([info.cell.textField isEqual:self.selectedBankTextField])
    {
        [self selectBlank];
    }
}

#pragma mark - 选择银行卡
- (void)selectBlank
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(!self.picker || self.picker.infos.count == 0)
    {
        [self.picker removeFromSuperview];
        
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        self.picker = [[UBPicker alloc] initWithSuperView:delegate.window style:UBPickerStyleBlank];
        self.picker.delegate = self;
    }
    
    [self.picker showWithAnimated:YES completion:nil];
}

#pragma mark - 银行卡选择器代理

- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions{
    
    SeaTextFieldInfo *info = [self.blankCellInfos objectAtIndex:2];
    
    info.cell.textField.text = [conditions objectForKey:@(UBPickerStyleBlank)];
}



#pragma mark- cells

///获取添加银行卡cell信息
- (void)getBlankCellInfos
{
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:3];

    SeaTextFieldInfo *info = [[SeaTextFieldInfo alloc] init];

    ///银行卡号
    info.cell.titleLabel.text = @"银行卡号";
    info.cell.textField.placeholder = @"请输入银行卡号";
    info.cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    info.cell.textField.delegate = self;
    self.bankCardTextField = info.cell.textField;
    [infos addObject:info];

    ///持卡人姓名
    info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"持卡人";
    info.cell.textField.placeholder = @"请输入持卡人姓名";
    info.cell.textField.inputLimitMax = WMWithdrawAccountHolderInputLimitMax;
    [info.cell.textField addTextDidChangeNotification];
    info.cell.textField.delegate = self;
    self.cardHolderTextField = info.cell.textField;
    [infos addObject:info];

    ///发卡银行
    info = [[SeaTextFieldInfo alloc] init];
    info.classString = NSStringFromClass([SeaDownArrowTextFieldCell class]);
    info.cell.titleLabel.text = @"发卡银行";
    info.cell.textField.placeholder = @"请选择发卡银行";
    info.cell.textField.delegate = self;
    self.selectedBankTextField = info.cell.textField;
    [infos addObject:info];

    self.blankCellInfos = infos;
}

///获取验证码cell信息
- (void)getCodeInfos
{
    WeakSelf(self);
    NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:2];

    ///手机号码
    SeaTextFieldInfo *info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"手机号码";
    info.cell.textField.placeholder = @"请输入手机号码";
    info.cell.textField.text = [WMUserInfo sharedUserInfo].accountSecurityInfo.phoneNumber;
    info.cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    info.cell.textField.delegate = self;;
    self.phoneNumberTextField = info.cell.textField;
    [infos addObject:info];

    if(![NSString isEmpty:self.codeURL])
    {
        ///图形验证码
        info = [[SeaTextFieldInfo alloc] init];
        info.classString = NSStringFromClass([SeaImageCodeTextFieldCell class]);
        info.cell.titleLabel.text = @"验证码";
        info.cell.textField.placeholder = @"请输入验证码";
        [(SeaImageCodeTextFieldCell*)info.cell setCodeURL:self.codeURL];
        self.imageCodeCell = (SeaImageCodeTextFieldCell*)info.cell;
        [infos addObject:info];
    }

    ///验证码
    info = [[SeaTextFieldInfo alloc] init];
    info.classString = NSStringFromClass([SeaCountDownTextFieldCell class]);
    info.cell.titleLabel.text = @"验证码";
    info.cell.textField.placeholder = @"请输入验证码";
    info.cell.textField.delegate = self;
    info.cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    [(SeaCountDownTextFieldCell*)info.cell setGetCodeHandler:^(void){

        [weakSelf getMessageCode];
    }];
    self.countDownButton = [(SeaCountDownTextFieldCell*)info.cell countDownButton];
    self.codeTextField = info.cell.textField;
    [infos addObject:info];

    self.phoneNumberTextField.enabled = NO;

    self.codeInfos = infos;
}

///获取支付宝cell信息
- (void)getAliInfos
{
    NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:2];

    ///支付宝账号
    SeaTextFieldInfo *info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"支付宝";
    info.cell.textField.placeholder = @"请输入支付宝账号";
    info.cell.textField.delegate = self;
    info.cell.textField.forbidInputChinese = YES;
    [info.cell.textField addTextDidChangeNotification];
    info.cell.textField.inputLimitMax = WMALiPayAccountInputLimitMax;
    info.cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.aliAccountTextField = info.cell.textField;
    [infos addObject:info];

    ///支付宝姓名
    info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"账号名字";
    info.cell.textField.placeholder = @"请输入支付宝名字";
    info.cell.textField.inputLimitMax = WMWithdrawAccountHolderInputLimitMax;
    [info.cell.textField addTextDidChangeNotification];
    info.cell.textField.delegate = self;
    self.aliHolderTextField = info.cell.textField;
    [infos addObject:info];

    self.payCellInfos = infos;
}

@end
