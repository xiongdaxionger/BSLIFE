//
//  WMCollectMoneyViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollectMoneyViewController.h"
#import "WMUserInfo.h"
#import "WMCollecMoneyShareViewController.h"
#import "WMCollectMoneyInfo.h"
#import "WMCollectMoneyOperation.h"

@interface WMCollectMoneyViewController ()<SeaHttpRequestDelegate>

/**当前登录的用户信息
 */
@property(nonatomic,strong) WMUserInfo *userInfo;

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMCollectMoneyViewController

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    [self alertMsg:@"收钱失败"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    
    WMCollectMoneyInfo *info = [WMCollectMoneyOperation collectMoneyResultFromData:data];
    
    if(info)
    {
        info.amount = self.amount_textField.text;
        info.name = self.name_textField.text;
        WMCollecMoneyShareViewController *collectMoney = [[WMCollecMoneyShareViewController alloc] init];
        collectMoney.collectMoneyInfo = info;
        [self.navigationController pushViewController:collectMoney animated:YES];
    }
}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.backItem = YES;
    self.title = @"收钱";
    self.userInfo = [WMUserInfo sharedUserInfo];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.amount_textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(cut:)), NSStringFromSelector(@selector(paste:)), nil];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:16.0];
    self.amount_label.font = font;
    self.amount_textField.delegate = self;
    self.amount_textField.font = font;
    
    self.name_title_label.font = font;
    self.name_textField.font = font;
    self.name_textField.delegate = self;
    self.name_textField.inputLimitMax = WMCollectMoneyNameInputLimitMax;
    [self.name_textField addTextDidChangeNotification];
   // self.name_textField.enabled = NO;
    
    NSString *name = [NSString isEmpty:self.userInfo.name] ? self.userInfo.account : self.userInfo.name;
    self.name_textField.text = [NSString stringWithFormat:@"%@直接收款", name];

    self.msg_label.font = [UIFont fontWithName:MainFontName size:14.0];
    self.msg_label.text = [NSString stringWithFormat:@"*%@配合银行共同打击虚假交易、转账套现、洗钱等被禁止的交易行为，请进行真实交易，否则款项将不能提现!", appName()];
    
    self.next_btn.backgroundColor = WMButtonBackgroundColor;
    self.next_btn.layer.cornerRadius = 3.0;
    self.next_btn.layer.masksToBounds = YES;
    self.next_btn.titleLabel.font = WMLongButtonTitleFont;
    [self.next_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [self.next_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.next_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)];
    [self.view addGestureRecognizer:tap];
    
    [self.amount_textField becomeFirstResponder];
    
    [self.amount_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.name_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self enableNext];
}

//回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


/**下一步
 */
- (IBAction)next:(id)sender
{
    float value = [self.amount_textField.text floatValue];
    if(value < WMTopupInputLimitMin || [self.amount_textField.text sea_lastCharacter] == '.')
    {
        [self alertMsg:[NSString stringWithFormat:@"收款金额不得少于%d元", WMCollectMoneyInputLimitMin]];
        return;
    }
    
    
    [self reconverKeyBord];
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    if(!self.httpRequest)
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    }
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCollectMoneyOperation collectMoneyParamWithAmount:self.amount_textField.text title:self.name_textField.text]];
}

///是否能够下一步
- (void)enableNext
{
    BOOL enable = YES;
    if([NSString isEmpty:self.amount_textField.text])
    {
        enable = NO;
    }
    
    if([NSString isEmpty:self.name_textField.text])
    {
        enable = NO;
    }
    
    self.next_btn.enabled = enable;
    self.next_btn.backgroundColor = enable ? WMButtonBackgroundColor : [UIColor colorWithWhite:0.85 alpha:1.0];
}

#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.amount_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedNum:WMCollectMoneyInputLimitMax];
    }
    else
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMCollectMoneyNameInputLimitMax];
    }
}

///文字输入改变
- (void)textDidChange:(UITextField*) textField
{
    [self enableNext];
}

@end
