//
//  WMTradePasswordInputView.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMTradePasswordInputView.h"


@interface WMTradePasswordInputView ()

//内容
@property(nonatomic,strong) UIView *contentView;

//内容目标frame
@property(nonatomic,assign) CGRect targetFrame;

//黑色背景
@property(nonatomic,strong) UIView *backgroundView;

//标题
@property(nonatomic,strong) UILabel *titleLabel;

//关闭按钮
@property(nonatomic,strong) SeaButton *closeBtn;

//类型
@property(nonatomic,strong) UILabel *typeLabel;

/**输入框
 */
@property(nonatomic,strong) UITextField *textField;

/**密码框
 */
@property(nonatomic,strong) SeaGridPasswordLabel *passwdLabel;

/**价格
 */
@property(nonatomic,strong) UILabel *priceLabel;

///是否可以取消第一响应者
@property(nonatomic,assign) BOOL enableReconverKeyboard;

/**键盘是否隐藏
 */
@property(nonatomic,readonly) BOOL keyboardHidden;

/**键盘大小
 */
@property(nonatomic,readonly) CGRect keyboardFrame;

@end

@implementation WMTradePasswordInputView


/**初始化
 *@param type 类型 0 充值，1提现
 *@param price 充值或提现金额
 */
- (id)initWithType:(int) type price:(NSString*) price
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _height_)];
    if(self)
    {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        CGFloat textMargin = 10.0;
        CGFloat contentWidth = 250.0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 40)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"请输入支付密码";
        
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = font;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(_width_ / 2.0, _height_ / 2.0, 1.0, 1.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
        
        [_contentView addSubview:_titleLabel];
        
        //关闭按钮
        _closeBtn = [[SeaButton alloc] initWithFrame:CGRectMake(contentWidth - _titleLabel.height, 0, _titleLabel.height, _titleLabel.height) buttonType:SeaButtonTypeClose];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.lineColor = [UIColor grayColor];
        [_contentView addSubview:_closeBtn];
        
        //红色分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, contentWidth, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [_contentView addSubview:line];
        
        //类型
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, line.bottom + 10.0, contentWidth, 20.0)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:MainFontName size:13.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        switch (type)
        {
            case 0 :
            {
                label.text = @"预存款支付";
            }
                break;
            case 1 :
            {
                label.text = @"提现";
            }
                break;
            case 2 :
            {
                label.text = @"储值卡支付";
            }
                break;
        }
        
        [_contentView addSubview:label];
        self.typeLabel = label;
        
        //价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom, contentWidth, 40.0)];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont fontWithName:MainFontName size:25.0];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.text = formatStringPrice(price);
        
        [_contentView addSubview:_priceLabel];
        
        //密码
        _passwdLabel = [[SeaGridPasswordLabel alloc] initWithFrame:CGRectMake(textMargin, _priceLabel.bottom, contentWidth - textMargin * 2, 40.0) count:WMTradePasswdCount];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_passwdLabel addGestureRecognizer:tap];
        [_contentView addSubview:_passwdLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_contentView addSubview:_textField];
        
        CGFloat height = _passwdLabel.bottom + textMargin;
        //        _contentView.width = contentWidth;
        //        _contentView.height = height;
        
        CGFloat y = (_height_ - height) / 2.0;
        
        
        self.targetFrame = CGRectMake((_width_ - contentWidth) / 2.0, MIN(y, _height_ - 216 - height - 40.0), contentWidth, height);
    }
    
    return self;
}

/**关闭
 */
- (void)close:(id) sender
{
    [self dismiss];
}

/**显示
 */
- (void)show
{
    self.contentView.frame = self.targetFrame;
    [self addKeyboardNotification];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
        self.backgroundView.alpha = 1.0;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:0.3];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = _animatedDuration_;
        [self.contentView.layer addAnimation:animation forKey:@"scale"];
        
    } completion:^(BOOL finish){
        
        [self.textField becomeFirstResponder];
    }];
}

/**消失
 */
- (void)dismiss
{
    [self removeKeyboardNotification];
    self.enableReconverKeyboard = YES;
    [_textField resignFirstResponder];
    [self removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(![self.textField isFirstResponder])
    {
        [self.textField becomeFirstResponder];
    }
}

/**文本改变
 */
- (void)textDidChange:(UITextField*) textField
{
    self.passwdLabel.string = textField.text;
    
    if(textField.text.length == WMTradePasswdCount && [self.delegate respondsToSelector:@selector(tradePasswordInputView:didFinishInputPasswd:)])
    {
        [self.delegate tradePasswordInputView:self didFinishInputPasswd:textField.text];
        [self dismiss];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMTradePasswdCount];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return self.enableReconverKeyboard;
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
    CGFloat y = 0;
    if(self.keyboardHidden)
    {
        y = self.targetFrame.origin.y;
    }
    else
    {
        _keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        y = MIN(self.targetFrame.origin.y, _height_ - _keyboardFrame.size.height - self.targetFrame.size.height - 20.0);
    }
    
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
        self.contentView.top = y;
    }];
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
