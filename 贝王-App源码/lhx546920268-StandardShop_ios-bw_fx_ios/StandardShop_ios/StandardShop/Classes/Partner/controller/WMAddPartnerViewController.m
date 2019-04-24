//
//  WMAddPartnerViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMAddPartnerViewController.h"
#import "SeaTextFieldCell.h"
#import "WMUserOperation.h"
#import "WMPartnerOperation.h"

@interface WMAddPartnerViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///输入框信息 数组元素是 SeaTextFieldInfo
@property(nonatomic,strong) NSArray *infos;

///图形验证码链接
@property(nonatomic,copy) NSString *imageCodeURL;

/**图形验证码
 */
@property(strong, nonatomic) SeaImageCodeTextFieldCell *image_code_view;

/**确认按钮
 */
@property(nonatomic,strong) UIButton *confirm_btn;

@end

@implementation WMAddPartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.title = @"添加会员";
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:4];
    
    SeaTextFieldInfo *info = [[SeaTextFieldInfo alloc] init];

    info.cell.titleLabel.text = @"手机号";
    info.cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    [info.cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [infos addObject:info];
    
    if(![NSString isEmpty:self.imageCodeURL])
    {
        info = [[SeaTextFieldInfo alloc] init];
        info.classString = @"SeaImageCodeTextFieldCell";
        
        SeaImageCodeTextFieldCell *cell = (SeaImageCodeTextFieldCell*)info.cell;
        self.image_code_view = cell;
        cell.titleLabel.text = @"图形验证码";
        cell.codeURL = self.imageCodeURL;
        [cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        [infos addObject:info];
    }
    
    info = [[SeaTextFieldInfo alloc] init];
    info.classString = NSStringFromClass([SeaCountDownTextFieldCell class]);
    info.cell.titleLabel.text = @"验证码";
    info.cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    WeakSelf(self);
    [(SeaCountDownTextFieldCell*)info.cell setGetCodeHandler:^(void){
      
        [weakSelf getCode];
    }];
    [info.cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [infos addObject:info];
    
    info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"姓名";
    info.cell.textField.inputLimitMax = WMUserNameInputLimitMax;
    info.cell.textField.chineseAsTwoCharWhenInputLimit = YES;
    [info.cell.textField addTextDidChangeNotification];
    [info.cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [infos addObject:info];
    
    info = [[SeaTextFieldInfo alloc] init];
    info.cell.titleLabel.text = @"密码";
    info.cell.textField.secureTextEntry = YES;
    [info.cell.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [infos addObject:info];
    
    self.infos = infos;
    
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    self.style = UITableViewStyleGrouped;
    [super initialization];
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.rowHeight = 45.0;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 70)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont fontWithName:MainFontName size:16.0];
    [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn setTitle:@"确认添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addPartner:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:WMButtonBackgroundColor];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    btn.frame = CGRectMake(15.0, footer.height - 45.0, _width_ - 15.0 * 2, 45.0);
    [footer addSubview:btn];
    self.confirm_btn = btn;
    self.tableView.tableFooterView = footer;
    
    [self enableAddPartner];
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
    
    if([request.identifier isEqualToString:WMAddPartnerIdentifier])
    {
        [self alerBadNetworkMsg:@"添加会员失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMAddPartnerNeedsIdentifier])
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码已发送，请注意查收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            SeaTextFieldInfo *info = [self.infos objectAtIndex:self.image_code_view ? 2 : 1];
            
            [info.countDownBtn startTimer];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMAddPartnerIdentifier])
    {
        if([WMPartnerOperation addPartnerResultFromData:data])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"添加会员成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMPartnerDidAddNotification object:self];
        }
        else
        {
            [self.image_code_view refreshCode];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMAddPartnerNeedsIdentifier])
    {
        self.imageCodeURL = [WMPartnerOperation addPartnerNeedsFromData:data];
        [self initialization];
        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadImageCode];
}

#pragma mark- UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

#pragma mark- private method

///添加会员
- (void)addPartner:(UIButton*) btn
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSInteger index = 0;
    SeaTextFieldInfo *info = [self.infos objectAtIndex:index];
    NSString *phoneNumber = info.cell.textField.text;

    if(![phoneNumber isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号码"];
        return;
    }
    index ++;
    
    if(self.image_code_view)
    {
        index ++;
    }
    
    info = [self.infos objectAtIndex:index];
    NSString *code = info.cell.textField.text;
    index ++;
    
    info = [self.infos objectAtIndex:index];
    NSString *name = info.cell.textField.text;
    index ++;
    
    info = [self.infos objectAtIndex:index];
    NSString *passwd = info.cell.textField.text;
    
    if(passwd.length < WMPasswordInputLimitMin)
    {
        [self alertMsg:[NSString stringWithFormat:@"请输入%d-%d位的密码", WMPasswordInputLimitMin, WMPasswordInputLimitMax]];
        return;
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMAddPartnerIdentifier;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation addPartnerParamWithPhoneNumber:phoneNumber code:code name:name passwd:passwd]];
}

///是否可以添加会员
- (void)enableAddPartner
{
    BOOL enable = YES;
    
    NSInteger index = 0;
    SeaTextFieldInfo *info = [self.infos objectAtIndex:index];
    NSString *phoneNumber = info.cell.textField.text;
    
    if([NSString isEmpty:phoneNumber])
    {
        enable = NO;
    }
    index ++;
    
    if(self.image_code_view)
    {
        NSString *code = self.image_code_view.textField.text;
        if([NSString isEmpty:code])
        {
            enable = NO;
        }
        index ++;
    }
    
    info = [self.infos objectAtIndex:index];
    NSString *code = info.cell.textField.text;
    
    if([NSString isEmpty:code])
    {
        enable = NO;
    }
    index ++;
    
    info = [self.infos objectAtIndex:index];
    NSString *name = info.cell.textField.text;
    
    if([NSString isEmpty:name])
    {
        enable = NO;
    }
    index ++;
    
    info = [self.infos objectAtIndex:index];
    NSString *passwd = info.cell.textField.text;
    
    if([NSString isEmpty:passwd])
    {
        enable = NO;
    }
    
    self.confirm_btn.enabled = enable;
    self.confirm_btn.backgroundColor = enable ? WMButtonBackgroundColor : [UIColor colorWithWhite:0.85 alpha:1.0];
}

/**获取验证码
 */
- (void)getCode
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    SeaTextFieldInfo *info = [self.infos objectAtIndex:0];

    if(![info.cell.textField.text isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号码"];
        return;
    }
    
    if(self.image_code_view && [NSString isEmpty:self.image_code_view.textField.text])
    {
        [self alertMsg:@"请输入图形验证码"];
        return;
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpRequest.identifier = WMGetPhoneCodeIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation getPhoneCodeParamWithPhoneNumber:info.cell.textField.text type:WMPhoneNumberCodeTypeAddPartner code:self.image_code_view.textField.text]];
}

///加载图形验证码
- (void)loadImageCode
{
    self.httpRequest.identifier = WMAddPartnerNeedsIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation addPartnerNeedsParams]];
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeaTextFieldInfo *info = [self.infos objectAtIndex:indexPath.row];
    info.cell.textField.delegate = self;
    info.cell.textField.tag = indexPath.row;
    
    return info.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case 0 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
        }
            break;
        case 1 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberCodeInputLimitMax];
        }
            break;
        case 2 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCountChinesseAsTwoChar:WMUserNameInputLimitMax];
        }
            break;
        case 3 :
        {
            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
        }
            break;
        default:
            break;
    }
   
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

///文字改变
- (void)textDidChange:(UITextField*) textField
{
    [self enableAddPartner];
}

@end
