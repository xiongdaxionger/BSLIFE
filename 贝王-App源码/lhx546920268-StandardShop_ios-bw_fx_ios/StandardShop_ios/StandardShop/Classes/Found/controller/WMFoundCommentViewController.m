//
//  WMFoundCommentViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentViewController.h"
#import "WMFoundListInfo.h"
#import "WMImageVerificationCodeView.h"
#import "WMFoundOperation.h"
#import "WMFoundCommentInfo.h"
#import "WMUserInfo.h"

@interface WMFoundCommentViewController ()<SeaHttpRequestDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

///背景
@property(nonatomic,strong) UIView *backgroundView;

///内容视图
@property(nonatomic,strong) UIView *contentView;

///发送按钮
@property(nonatomic,strong) UIButton *sendBtn;

///评论内容输入框
@property(nonatomic,strong) SeaTextView *textView;

///图形验证码
@property(nonatomic,strong) WMImageVerificationCodeView *imageCodeView;

///发送按钮左边分割线
@property(nonatomic,strong) UIView *line1;

///发送按钮下面分割线
@property(nonatomic,strong) UIView *line2;

///键盘是否隐藏
@property(nonatomic,readonly) BOOL keyboardHidden;

///键盘大小
@property(nonatomic,readonly) CGRect keyboardFrame;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMFoundCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self addKeyboardNotification];

    CGFloat margin = 10.0;
    CGFloat controlHeight = 40.0;

    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    CGFloat textHeight = font.lineHeight + 8.0 * 2;

    CGFloat height = self.codeURL ? controlHeight * 2 + _separatorLineWidth_ : controlHeight;

    ///背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _height_ - height - margin * 2, _width_, height + margin * 2)];
    view.backgroundColor = _SeaViewControllerBackgroundColor_;
    [self.view addSubview:view];
    self.backgroundView = view;

    ///内容视图
    view = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, self.backgroundView.width - margin * 2, height)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = _separatorLineColor_.CGColor;
    view.layer.borderWidth = _separatorLineWidth_;
    [self.backgroundView addSubview:view];
    self.contentView = view;

    CGFloat buttonWidth = 73.0;
    ///发送按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.contentView.width - buttonWidth, 0, buttonWidth, controlHeight);
    btn.enabled = NO;
    [self.contentView addSubview:btn];
    self.sendBtn = btn;

    ///分割线1
    view = [[UIView alloc] initWithFrame:CGRectMake(self.sendBtn.left - _separatorLineWidth_, 10.0, _separatorLineWidth_, controlHeight - 10.0 * 2)];
    view.backgroundColor = _separatorLineColor_;
    [self.contentView addSubview:view];
    self.line1 = view;


    ///输入框
    SeaTextView *textView = [[SeaTextView alloc] initWithFrame:CGRectMake(0, (controlHeight - textHeight) / 2.0, self.line1.left, textHeight)];
    textView.placeholder = @"请输入评论内容";
    textView.font = font;
    textView.delegate = self;
    textView.showsVerticalScrollIndicator = NO;
    textView.maxCount = WMGoodCommentReplyInputLimitMax;
    [self.contentView addSubview:textView];
    self.textView = textView;

    ///图形验证码
    if(self.codeURL)
    {
        ///分割线2
        view = [[UIView alloc] initWithFrame:CGRectMake(0, self.sendBtn.bottom, self.contentView.width, _separatorLineWidth_)];
        view.backgroundColor = _separatorLineColor_;
        [self.contentView addSubview:view];
        self.line2 = view;

        ///
        WMImageVerificationCodeView *codeView = [[WMImageVerificationCodeView alloc] initWithFrame:CGRectMake(0, self.line2.bottom, self.contentView.width, controlHeight)];
        codeView.codeURL = self.codeURL;
        codeView.textField.font = self.textView.font;
        codeView.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8.0, codeView.height)];
        [codeView.textField addTarget:self action:@selector(imageCodeDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:codeView];
        self.imageCodeView = codeView;
    }

    [self.textView becomeFirstResponder];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

///发送
- (void)send:(UIButton*) btn
{
    if([NSString isEmpty:self.textView.text])
    {
        [[AppDelegate instance] alertMsg:@"请输入评论内容"];
        return;
    }

    if(self.codeURL && [NSString isEmpty:self.imageCodeView.textField.text])
    {
        [[AppDelegate instance] alertMsg:@"请输入验证码"];
        return;
    }

    if(!self.httpRequest)
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    }

    self.showNetworkActivity = YES;
    self.requesting = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMFoundOperation foundCommentParamWithInfo:self.info content:self.textView.text code:self.imageCodeView.textField.text]];
}

///发送按钮状态改变
- (void)changeSendBtnState
{
    if(self.codeURL)
    {
        self.sendBtn.enabled = ![NSString isEmpty:self.textView.text] && ![NSString isEmpty:self.imageCodeView.textField.text];
    }
    else
    {
        self.sendBtn.enabled = ![NSString isEmpty:self.textView.text];
    }
}

///点击黑色半透明视图
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [self dismiss];
}

- (void)dismiss
{
    [self removeKeyboardNotification];
    [super dismiss];
}

#pragma mark- UITapGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if(CGRectContainsPoint(self.backgroundView.frame, point))
    {
        return NO;
    }

    return YES;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;
    [self alerBadNetworkMsg:@"评论失败"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    self.showNetworkActivity = NO;

    if([WMFoundOperation foundCommentResultFromData:data])
    {
        WMFoundCommentInfo *info = [[WMFoundCommentInfo alloc] init];
        info.userInfo = [[WMUserInfo sharedUserInfo] copy];
        info.content = self.textView.text;
        info.time = @"刚刚";

        !self.commentCompletionHandler ?: self.commentCompletionHandler(info);

        [self dismiss];
    }
    else
    {
        [self.imageCodeView refreshCode];
    }
}

#pragma mark- SeaTextView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnState];
    NSString *text = textView.text;

    ///输入内容改变，调整输入框
    CGFloat margin = 8.0;
    CGSize size = [text stringSizeWithFont:textView.font contraintWith:textView.width - margin * 2];

    size.height = MAX(size.height, textView.font.lineHeight);
    if(size.height > textView.font.lineHeight * 4)
    {
        size.height = textView.font.lineHeight * 4;
    }

    ///输入框高度改变了
    if(textView.height != size.height + margin * 2)
    {
        textView.height = size.height + margin * 2;
        self.sendBtn.top = MAX(0, textView.height - self.sendBtn.height);
        self.line1.top = self.sendBtn.top + (self.sendBtn.height - self.line1.height) / 2.0;
        self.line2.top = textView.bottom;
        self.imageCodeView.top = self.line2.bottom;
        self.contentView.height = self.codeURL ? self.imageCodeView.bottom : textView.bottom;

        CGRect frame = self.backgroundView.frame;
        frame.size.height = self.contentView.top * 2 + self.contentView.height;
        frame.origin.y = _height_ - _keyboardFrame.size.height - frame.size.height;
        self.backgroundView.frame = frame;
    }

    [self.textView textDidChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [self.textView shouldChangeTextInRange:range replacementText:text];
}

///验证码输入改变
- (void)imageCodeDidChange:(UITextField*) textField
{
    [self changeSendBtnState];
}

#pragma mark- 键盘

/**添加键盘监听
 */
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/**移除键盘监听
 */
- (void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

/**键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    CGFloat height;
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];

    if(self.keyboardHidden)
    {
        height = 0;
    }
    else
    {
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        height = _keyboardFrame.size.height;
    }

    [UIView animateWithDuration:duration delay:0 options:curve animations:^(void){

        self.backgroundView.top = _height_ - self.backgroundView.height - height;
    }completion:nil];
}

//键盘隐藏
- (void)keyboardWillHide:(NSNotification*) notification
{
    _keyboardHidden = YES;

    [self keyboardWillChangeFrame:notification];
}

//键盘显示
- (void)keyboardWillShow:(NSNotification*) notification
{
    _keyboardHidden = NO;
    [self keyboardWillChangeFrame:notification];
}



@end
