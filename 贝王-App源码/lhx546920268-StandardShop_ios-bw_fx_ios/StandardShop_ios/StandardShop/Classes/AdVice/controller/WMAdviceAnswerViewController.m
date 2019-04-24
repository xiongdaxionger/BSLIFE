//
//  WMAdviceAnsertViewController.m
//  StandardShop
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceAnswerViewController.h"

#import "WMAdviceSettingInfo.h"
#import "WMAdviceQuestionInfo.h"
#import "WMAdviceOperation.h"
#import "WMAdviceContentInfo.h"

#import "WMAdviceQuestionView.h"
#import "WMImageVerificationCodeView.h"

@interface WMAdviceAnswerViewController ()<SeaHttpRequestDelegate,UITextViewDelegate,UITextFieldDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**图形验证码
 */
@property (strong,nonatomic) WMImageVerificationCodeView *codeView;
@end

@implementation WMAdviceAnswerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"回复咨询";
    
    self.backItem = YES;
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    
    CGFloat margin = 10.0;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:13.0];
    
    UIColor *textColor = MainGrayColor;
    
    WMAdviceQuestionView *headerView = [[WMAdviceQuestionView alloc] initWithInfo:self.questionInfo];
    
    headerView.frame = CGRectMake(0, 0, _width_, headerView.height);
    
    [_scrollView addSubview:headerView];
    
    _intPutView = [[SeaTextView alloc] initWithFrame:CGRectMake(margin, headerView.bottom + margin, _width_ - margin * 2, 150.0)];
    
    _intPutView.delegate = self;
    
    _intPutView.maxCount = 100.0;
    
    _intPutView.backgroundColor = [UIColor whiteColor];
    
    _intPutView.limitable = YES;
    
    _intPutView.textColor = textColor;
    
    _intPutView.font = font;
    
    _intPutView.placeholderFont = font;
        
    _intPutView.placeholder = @"请输入回复内容100字以内";
    
    _intPutView.returnKeyType = UIReturnKeyDone;
    
    [_scrollView addSubview:_intPutView];
    
    CGFloat bottom = 0.0;
    
    if ([NSString isEmpty:_settingInfo.verifyCode]) {
        
        bottom = _intPutView.bottom + 3 * margin;
    }
    else{
        
        WMImageVerificationCodeView *codeView = [[WMImageVerificationCodeView alloc] initWithFrame:CGRectMake(margin, _intPutView.bottom + _separatorLineWidth_, _intPutView.width, 45.0)];
        
        codeView.backgroundColor = [UIColor whiteColor];
        
        codeView.textField.placeholder = @"  请输入图形验证码";
        
        codeView.textField.font = [UIFont fontWithName:MainFontName size:13.0];
        
        codeView.textField.textColor = textColor;
        
        codeView.textField.returnKeyType = UIReturnKeyDone;
        
        codeView.textField.delegate = self;
        
        codeView.textField.leftView = nil;
        
        codeView.codeURL = _settingInfo.verifyCode;
        
        [_scrollView addSubview:codeView];
        
        _codeView = codeView;
        
        bottom = _codeView.bottom + 3 * margin;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"如果有更多问题，您可以拨打客服电话:%@",self.settingInfo.adviceServicePhone]];
    
    [attrString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainDeepGrayColor} range:NSMakeRange(0, attrString.string.length)];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(1.0)} range:[attrString.string rangeOfString:self.settingInfo.adviceServicePhone]];
    
    UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, bottom, _width_ - margin * 2, 21.0)];
    
    callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [callButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    [callButton addTarget:self action:@selector(callButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:callButton];
        
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont fontWithName:MainFontName size:MainFontSize56];
    
    [btn setBackgroundColor:WMPriceColor];
    
    [btn setFrame:CGRectMake(margin, self.contentHeight - WMLongButtonHeight - margin, _width_ - 2 * margin, WMLongButtonHeight)];
    
    [btn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘显示或隐藏
- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    UIEdgeInsets insets;
    
    if(self.keyboardHidden)
    {
        insets = UIEdgeInsetsZero;
    }
    else
    {
        CGRect frame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        insets = UIEdgeInsetsMake(0, 0, frame.size.height, 0);
    }
    
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
        self.scrollView.contentInset = insets;
        
        if(!self.keyboardHidden && _height_ == 480.0)
        {
            self.scrollView.contentOffset = CGPointMake(0, _intPutView.frame.origin.y - 10.0);
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*) notification
{
    self.keyboardHidden = YES;
}

- (void)keyboardWillShow:(NSNotification*) notification
{
    self.keyboardHidden = NO;
}

- (void)reconverKeyboard
{
    [_intPutView resignFirstResponder];
    
    [_codeView.textField resignFirstResponder];
}

#pragma mark - 文本框协议
- (void)textViewDidChange:(UITextView *)textView
{
    [_intPutView textDidChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return [_intPutView shouldChangeTextInRange:range replacementText:text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 拨打电话
- (void)callButtonAction{
    
    makePhoneCall(self.settingInfo.adviceServicePhone, YES);
}

#pragma mark - 回复咨询
- (void)upload
{
    if([NSString isEmpty:_intPutView.text])
    {
        [self alertMsg:@"请输入回复内容"];
        
        return;
    }
    
    if (![NSString isEmpty:_settingInfo.verifyCode] && [NSString isEmpty:_codeView.textField.text]) {
        
        [self alertMsg:@"请输入验证码"];
        
        return;
    }
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMReplyAdviceIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMAdviceOperation returnReplyAdviceWithAdviceID:self.questionInfo.adviceID comment:self.intPutView.text replyverifyCode:_codeView.textField.text]];
}

#pragma mark - 网络请求

- (void)setRequesting:(BOOL)requesting
{
    [super setRequesting:requesting];
    
    self.view.userInteractionEnabled = !self.requesting;
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alerBadNetworkMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMReplyAdviceIdentifier]) {
        
        if ([WMAdviceOperation returnReplyAdviceResultWithData:data]) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONDictionaryWithData:data];
            
            NSString *msgString = [dataDict sea_stringForKey:WMHttpMessage];
            
            [self alertMsg:msgString];
            
            if (!self.settingInfo.needAdminVerify) {
                
                if (self.commitReplySuccess) {
                    
                    self.commitReplySuccess([WMAdviceContentInfo returnAdviceContentInfoWithDict:[[[[dataDict dictionaryForKey:WMHttpData] dictionaryForKey:@"comlist"] arrayForKey:@"items"] firstObject]]);
                }
            }
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
        else{
            
            self.requesting = NO;
        }
    }
}









@end
