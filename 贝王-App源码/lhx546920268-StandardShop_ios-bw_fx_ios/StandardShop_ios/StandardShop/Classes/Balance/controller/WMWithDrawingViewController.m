//
//  WMWithDrawingViewController.m
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMWithDrawingViewController.h"
#import "WMWithDrawAccountViewController.h"
#import "WMPayPassWordController.h"
#import "WMBalanceOperation.h"
#import "WMConfirmOrderOperation.h"
#import "WMWithDrawInfo.h"
#import "WMUserInfo.h"

#import "UIView+XQuickControl.h"
#import "WMTradePasswordInputView.h"
#import "WMBindPhoneNumberViewController.h"

@interface WMWithDrawingViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate,WMTradePasswordInputViewDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**数据模型
 */
@property (strong,nonatomic) WMWithDrawInfo *drawInfos;
/**选中的提现账号
 */
@property (copy,nonatomic) NSString *selectWithDrawAccount;
@end

@implementation WMWithDrawingViewController


#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"提现";
    
    self.backItem = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAccountNotifi:) name:@"DeleteAccountSuccess" object:nil];
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 删除账号成功回调
- (void)deleteAccountNotifi:(NSNotification *)notifi{
    
    NSString *deleteAccountID = [notifi.userInfo objectForKey:@"accountID"];
    
    if ([self.selectWithDrawAccount isEqualToString:deleteAccountID]) {
        
        self.accountInfoLabel.text = @"";
        
        self.addAccountButton.hidden = NO;
        
        self.selectWithDrawAccount = nil;
    }
}

#pragma mark - 网络重载
- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    
    self.request.identifier = WMGetDrawAccountInfoIden;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnWithDrawInfoParam]];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
        
    self.withDrawnField.text = [NSString stringWithFormat:@"%.2f",self.drawInfos.canWithDrawMoney.doubleValue];
    
    self.inWithDrawField.placeholder = [NSString stringWithFormat:@"单笔最高提现%@元",self.drawInfos.maxWithDrawMoney];
    
    self.inWithDrawField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.inWithDrawField.delegate = self;
    
    self.accountInfoLabel.text = @"";
    
    self.inWithDrawTaxField.text = [NSString stringWithFormat:@"扣除%.1f%%税金",self.drawInfos.withDrawTax.doubleValue * 100];
    
    self.platformLabel.text = [NSString stringWithFormat:@"平台收取费用%.1f%%",self.drawInfos.withDrawPlatformMoney.doubleValue * 100];
    
    self.platformViewHeight.constant = self.drawInfos.withDrawPlatformMoney.doubleValue == 0.0 ? CGFLOAT_MIN : 44.0;
    
    self.taxViewHeight.constant = self.drawInfos.withDrawTax.doubleValue == 0.0 ? CGFLOAT_MIN : 44.0;
    
    [self.inWithDrawField addTarget:self action:@selector(changeTax:) forControlEvents:UIControlEventEditingChanged];
    
    [self.withDrawButton setBackgroundColor:WMButtonBackgroundColor];
    
    [self.withDrawButton setTitleColor:WMTintColor forState:UIControlStateNormal];
    
    self.withDrawButton.layer.cornerRadius = 3.0;
    
    [self.withDrawButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    self.withDrawButton.titleLabel.font = WMLongButtonTitleFont;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    
    self.addAccountButton.titleLabel.font = font;
    
    self.withDrawnField.font = font;
    
    self.inWithDrawField.font = font;
    
    self.accountInfoLabel.font = font;
    
    self.platformLabel.font = font;
    
    self.inWithDrawTaxField.font = font;
    
    self.withDrawnField.textColor = MainTextColor;
    
    self.inWithDrawField.textColor = MainTextColor;
    
    self.accountInfoLabel.textColor = MainTextColor;
    
    self.platformLabel.textColor = MainTextColor;
    
    self.inWithDrawTaxField.textColor = MainTextColor;

    self.accountInfoLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapInfoLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAccountButtonTap:)];

    [self.accountInfoLabel addGestureRecognizer:tapInfoLabel];
    
    NSMutableString *contentString = [NSMutableString new];
    
    for (NSDictionary *noticeDict in self.drawInfos.noticeInfoArr) {
        
        NSString *noticeStr = [NSString stringWithFormat:@"●%@\n",[noticeDict sea_stringForKey:@"notice"]];
        
        [contentString appendString:noticeStr];
        
        self.statusInfoLabel.font = [UIFont fontWithName:MainFontName size:13.0];
        
        self.statusInfoLabel.textColor = MainTextColor;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSMutableParagraphStyle *paragarphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragarphStyle setLineSpacing:5.0];
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragarphStyle range:NSMakeRange(0, [contentString length])];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:MainFontName size:13.0],NSForegroundColorAttributeName:MainTextColor} range:NSMakeRange(0, [contentString length])];
    
    self.statusInfoLabel.attributedText = attrString;
    
    self.statusInfoLabel.height = [attrString boundsWithConstraintWidth:_width_ - 30].height;
}

#pragma mark - 网络回调
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGetDrawAccountInfoIden]) {
        
        WMWithDrawInfo *info = [WMBalanceOperation returnWithDrawInfoWithData:data];
        
        if (info) {
            
            self.drawInfos = info;
            
            [self configureUI];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WithDrawMoneyIndetifier]){
        
        if ([WMBalanceOperation returnCommitWithDrawResultWithData:data]) {
            
            [self alertMsg:@"提交提现申请成功"];
            
            NSString *updateMoney = [NSString stringWithFormat:@"%.2f",self.drawInfos.canWithDrawMoney.doubleValue - self.inWithDrawField.text.doubleValue];
            
            self.withDrawnField.text = updateMoney;
            
            self.drawInfos.canWithDrawMoney = [NSNumber numberWithDouble:updateMoney.doubleValue];
            
            self.inWithDrawTaxField.text = [NSString stringWithFormat:@"扣除%.1f%%税金",self.drawInfos.withDrawTax.doubleValue * 100];
            
            self.platformLabel.text = [NSString stringWithFormat:@"平台收取费用%.1f%%",self.drawInfos.withDrawPlatformMoney.doubleValue * 100];
            
            self.inWithDrawField.text = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMDidWithdrawNotification object:nil];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGetDrawAccountInfoIden]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMCheckPayPassWordIden]){
        
        [self alerBadNetworkMsg:@"网络出错"];
    }
    else if ([request.identifier isEqualToString:WithDrawMoneyIndetifier]){
        
        [self alerBadNetworkMsg:@"网络出错"];
    }
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    
    [self reconverKeyBord];
}

- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - 控件的点击事件
- (void)withDrawButtonClick:(UIButton *)sender{
    
    if ([NSString isEmpty:self.inWithDrawField.text]) {
        
        [self alertMsg:@"请输入提现金额"];
        
        return;
    }
    
    if ([NSString isEmpty:self.selectWithDrawAccount]) {
        
        [self alertMsg:@"请选择提现账号"];
        
        return;
    }
    
    if ([self.inWithDrawField.text sea_lastCharacter] == '.' || self.inWithDrawField.text.doubleValue < self.drawInfos.minWithDrawMoney.doubleValue) {
        
        [self alertMsg:[NSString stringWithFormat:@"提现金额不能小于%.2f", self.drawInfos.minWithDrawMoney.doubleValue]];
        
        return;
    }
    
    if ([WMUserInfo sharedUserInfo].has_pay_password) {
      
        WMTradePasswordInputView *payPassWordInputView = [[WMTradePasswordInputView alloc] initWithType:1 price:self.inWithDrawField.text];
        
        payPassWordInputView.delegate = self;
        
        [payPassWordInputView show];
    }
    else{
        
        WeakSelf(self);
        
        if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
        {
            [self bindPhoneWithClass:^(void){
                WMPayPassWordController *payPassController = [WMPayPassWordController new];
                [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {
                    
                    [weakSelf withDrawMoneyActionPayPass:payPass];
                }];
                return payPassController;
            }];
            return;
        }
        
        WMPayPassWordController *payPassController = [WMPayPassWordController new];
        
        [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {
        
            [weakSelf withDrawMoneyActionPayPass:payPass];
        }];
        
        [self.navigationController pushViewController:payPassController animated:YES];
    }
}

//绑定手机号
- (void)bindPhoneWithClass:(UIViewController* (^)(void)) obtainViewController
{
    WeakSelf(self);
    WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
    __weak WMBindPhoneNumberViewController *weakBind = bind;
    bind.shouldBackAfterBindCompletion = NO;
    bind.bindCompletionHandler = ^(void){
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
        
        NSInteger index = [viewControllers indexOfObject:weakBind];
        [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
        [viewControllers addObject:obtainViewController()];
        [weakSelf.navigationController setViewControllers:viewControllers animated:YES];
    };
    [self.navigationController pushViewController:bind animated:YES];
}

#pragma mark - 密码框回调
- (void)tradePasswordInputView:(WMTradePasswordInputView *)view didFinishInputPasswd:(NSString *)passwd{
    
    [self withDrawMoneyActionPayPass:passwd];
}

#pragma mark - 提现
- (void)withDrawMoneyActionPayPass:(NSString *)payPass{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WithDrawMoneyIndetifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnCommitWithDrawParamWithMoney:self.inWithDrawField.text accountNumber:self.selectWithDrawAccount payPassWord:payPass]];
}

- (void)addAccountButtonTap:(UIButton *)sender{
    
    WeakSelf(self);
    
    WMWithDrawAccountViewController *accountViewController = [[WMWithDrawAccountViewController alloc] init];
    
    [accountViewController setSelectAccountCallBakc:^(NSString *accountName,NSString *accountID) {
        
        weakSelf.accountInfoLabel.text = accountName;
        
        weakSelf.selectWithDrawAccount = accountID;
        
        weakSelf.addAccountButton.hidden = YES;
    }];
    
    [self.navigationController pushViewController:accountViewController animated:YES];
}

#pragma mark - 文本框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSNumber *maxInt = self.drawInfos.maxWithDrawMoney.integerValue > self.drawInfos.canWithDrawMoney.integerValue ? self.drawInfos.canWithDrawMoney : self.drawInfos.maxWithDrawMoney;
    
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedNum:[maxInt doubleValue]];
}

- (void)changeTax:(UITextField *)textField{
    
    if (textField.text.doubleValue == 0.0) {
        
        self.inWithDrawTaxField.text = [NSString stringWithFormat:@"扣除%.1f%%税金",self.drawInfos.withDrawTax.doubleValue * 100];
        
        self.platformLabel.text = [NSString stringWithFormat:@"平台收取费用%.1f%%",self.drawInfos.withDrawPlatformMoney.doubleValue * 100];
        
        return;
    }
    
    self.inWithDrawTaxField.text = [NSString stringWithFormat:@"%.3f",textField.text.doubleValue * self.drawInfos.withDrawTax.doubleValue];
    
    self.platformLabel.text = [NSString stringWithFormat:@"%.3f",textField.text.doubleValue * self.drawInfos.withDrawPlatformMoney.doubleValue];
}









@end
