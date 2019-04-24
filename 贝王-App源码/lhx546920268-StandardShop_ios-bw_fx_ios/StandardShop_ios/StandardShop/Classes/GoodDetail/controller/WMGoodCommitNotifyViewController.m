//
//  WMGoodCommitNotifyViewController.m
//  StandardShop
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommitNotifyViewController.h"

#import "WMGoodDetailOperation.h"

@interface WMGoodCommitNotifyViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**手机号码输入
 */
@property (strong,nonatomic) UITextField *cellPhoneField;
/**邮箱输入
 */
@property (strong,nonatomic) UITextField *emailField;
@end

@implementation WMGoodCommitNotifyViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;
        
        self.title = @"到货通知";
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    CGFloat margin = 8.0;
    
    CGFloat textFieldHeight = 50.0;
    
    NSString *tipMsgString = @"一旦此商品在1个月到货，您将收到手机短信提醒或邮件通知";
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, _width_ - 2 * margin, [tipMsgString stringSizeWithFont:font contraintWith:_width_ - 2 * margin].height)];
    
    tipLabel.text = tipMsgString;
    
    tipLabel.numberOfLines = 0;
    
    tipLabel.font = font;
    
    [self.view addSubview:tipLabel];
    
    UIView *phoneBackView = [[UIView alloc] initWithFrame:CGRectMake(0, tipLabel.bottom + margin, _width_, textFieldHeight)];
    
    phoneBackView.backgroundColor = [UIColor whiteColor];
    
    _cellPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, _width_ - 2 * margin, textFieldHeight)];
    
    _cellPhoneField.placeholder = @"请填写您的手机号";
    
    _cellPhoneField.font = font;
    
    _cellPhoneField.backgroundColor = [UIColor whiteColor];
    
    _cellPhoneField.delegate = self;
    
    _cellPhoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    [phoneBackView addSubview:_cellPhoneField];
    
    [self.view addSubview:phoneBackView];
    
    UIView *emailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneBackView.bottom + margin, _width_, textFieldHeight)];
    
    emailBackView.backgroundColor = [UIColor whiteColor];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, _width_ - 2 * margin, textFieldHeight)];
    
    _emailField.placeholder = @"请填写您的邮箱";
    
    _emailField.font = font;
    
    _emailField.delegate = self;
    
    _emailField.backgroundColor = [UIColor whiteColor];
    
    [emailBackView addSubview:_emailField];
    
    [self.view addSubview:emailBackView];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0, emailBackView.bottom + 4 * margin, _width_ - 10.0, WMLongButtonHeight)];
    
    [commitButton setBackgroundColor:WMRedColor];
    
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [commitButton.titleLabel setFont:WMLongButtonTitleFont];
    
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitButton];
}

#pragma mark - 提交缺货登记
- (void)commitButtonClick:(UIButton *)button{
    
    if ([NSString isEmpty:self.emailField.text] && [NSString isEmpty:self.cellPhoneField.text]) {
        
        [self alertMsg:@"请输入邮箱或手机号码"];
        
        return;
    }
    else{
        
        if (![self.cellPhoneField.text isMobileNumber] && ![NSString isEmpty:self.cellPhoneField.text]) {
            
            [self alertMsg:@"请输入正确的手机号码"];
            
            return;
        }
        
        if (![self.emailField.text isEmail] && ![NSString isEmpty:self.emailField.text]) {
            
            [self alertMsg:@"请输入正确的邮箱"];
            
            return;
        }
        
    }
    
    [self commitGoodNotify];
}


#pragma mark - 输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.cellPhoneField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
    else if ([textField isEqual:self.emailField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMEmailInputLimitMax];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - 网络请求
- (void)commitGoodNotify{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGoodCommitNotifyIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation returnGoodCommitNotifyWithGoodID:self.goodID productID:self.productID cellPhone:self.cellPhoneField.text email:self.emailField.text]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([WMGoodDetailOperation returnGoodCommitNotifyWithData:data]) {
        
        [self alertMsg:@"提交成功"];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
    }
}





@end
