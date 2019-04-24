//
//  WMInputCell.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInputCell.h"

@implementation WMInputCell

- (instancetype)init
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.margin = WMInputCellMargin;
        self.titleWidth = 80.0;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = WMInputCellFont;
        [self.contentView addSubview:_titleLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _titleLabel.frame = CGRectMake(self.margin, 0, self.titleWidth, self.contentView.height);
}

@end

@implementation WMInputTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = self.titleLabel.font;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textField.frame = CGRectMake(self.titleLabel.right + WMInputCellInterval, 0, self.contentView.width - self.titleLabel.right - WMInputCellInterval - self.margin, self.contentView.height);
}

@end


@implementation WMInputCountDownTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80.0, 30.0)];
        _countDownButton = [[SeaCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 80.0, 30.0)];
        [view addSubview:_countDownButton];

        self.textField.rightView = view;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }

    return self;
}

- (void)dealloc
{
    [_countDownButton stopTimer];
}

@end

@implementation WMInputSelectedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {

        UIImage *arrow = [UIImage imageNamed:@"arrow_gray"];
        _arrowImageView = [[UIImageView alloc] initWithImage:arrow];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_arrowImageView];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = self.titleLabel.font;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentLabel];
    }

    return self;
}

- (void)setContent:(NSString *)content
{
    if(![_content isEqualToString:content])
    {
        _content = [content copy];
        _contentLabel.text = content;
        
        if(self.placeHolder)
        {
            if([NSString isEmpty:_contentLabel.text])
            {
                _contentLabel.textColor = [UIColor colorWithWhite:0.702f alpha:0.7];
                _contentLabel.text = _placeHolder;
            }
            else
            {
                _contentLabel.textColor = [UIColor grayColor];
            }
        }
        else
        {
            _contentLabel.textColor = [UIColor grayColor];
        }
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if(_placeHolder != placeHolder)
    {
        _placeHolder = [placeHolder copy];
        self.content = _contentLabel.text;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentLabel.frame = CGRectMake(self.titleLabel.right + WMInputCellInterval, 0, self.contentView.width - self.titleLabel.right - WMInputCellInterval * 2 - self.margin - _arrowImageView.width, self.contentView.height);
    _arrowImageView.left = self.contentView.width - _arrowImageView.width - self.margin;
    _arrowImageView.top = (self.contentView.height - _arrowImageView.height) / 2.0;
}

@end

@implementation WMInputSexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImage *image = [WMImageInitialization untickIcon];
        _boy_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_boy_btn setImage:image forState:UIControlStateNormal];
        [_boy_btn setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
        [_boy_btn setTitle:@" 男" forState:UIControlStateNormal];
        [_boy_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _boy_btn.frame = CGRectMake(0, 0, image.size.width + 30.0, 30.0);
        _boy_btn.titleLabel.font = WMInputCellFont;
        [self.contentView addSubview:_boy_btn];

        _girl_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_girl_btn setImage:image forState:UIControlStateNormal];
        [_girl_btn setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
        [_girl_btn setTitle:@" 女" forState:UIControlStateNormal];
        _girl_btn.frame = CGRectMake(0, 0, _boy_btn.width, 30.0);
        [_girl_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _girl_btn.titleLabel.font = _boy_btn.titleLabel.font;
        [self.contentView addSubview:_girl_btn];

        _boy_btn.selected = YES;

        [_boy_btn addTarget:self action:@selector(sexAction:) forControlEvents:UIControlEventTouchUpInside];
        [_girl_btn addTarget:self action:@selector(sexAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

///性别选择
- (void)sexAction:(UIButton*) btn
{
    if(btn.selected)
        return;

    if([self.girl_btn isEqual:btn])
    {
        self.boy_btn.selected = NO;
        self.girl_btn.selected = YES;
    }
    else
    {
        self.girl_btn.selected = NO;
        self.boy_btn.selected = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _boy_btn.frame = CGRectMake(self.titleLabel.right + WMInputCellInterval, 0, _boy_btn.width, self.contentView.height);
    _girl_btn.frame = CGRectMake(_boy_btn.right + 30, 0, _girl_btn.width, self.contentView.height);
}

@end

@implementation WMInputImageCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _codeView = [[WMImageVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, _width_, 45.0)];
        _codeView.textField.font = WMInputCellFont;
        [self.contentView addSubview:_codeView];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _codeView.frame = CGRectMake(self.titleLabel.right, 0, self.contentView.width - self.titleLabel.right - WMInputCellInterval - self.margin + 10.0, self.contentView.height);
}

@end

@implementation WMRegisterHeader

- (instancetype)init
{
  //  UIImage *image = [UIImage imageNamed:@"login_logo"];
    CGFloat margin = 30.0;
    self = [super initWithFrame:CGRectMake(0, 0, _width_,  margin * 2)];
    if(self)
    {
//        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_width_ - image.size.width) / 2.0, margin, image.size.width, image.size.height)];
//        _logoImageView.image = image;
//        [self addSubview:_logoImageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }

    return self;
}

///点击回收键盘
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end

@interface WMRegisterFooter ()<UITextFieldDelegate>

@end

@implementation WMRegisterFooter

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"WMRegisterFooter" owner:nil options:nil] firstObject];;
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, _width_, 302);
        
        self.register_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
        self.register_btn.layer.masksToBounds = YES;
        self.register_btn.titleLabel.font = WMLongButtonTitleFont;
        self.register_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
        [self.register_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
        [self.register_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        
        self.msg_label.text = [NSString stringWithFormat:@"密码由%d-%d位字符组成，区分大小写", WMPasswordInputLimitMin, WMPasswordInputLimitMax];
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        CGFloat width = 15.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
        label.font = font;
        
        self.password_textField.leftView = label;
        self.password_textField.leftViewMode = UITextFieldViewModeAlways;
        self.password_textField.delegate = self;
        self.password_textField.font = font;
        self.password_textField.placeholder = [NSString stringWithFormat:@"请输入%d-%d位字符", WMPasswordInputLimitMin, WMPasswordInputLimitMax];
        
        [self.tick_btn setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
        [self.tick_btn setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
        self.tick_btn.selected = YES;
        
        self.password_textField.delegate = self;
        [self.password_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        _enableRegister = YES;
        self.enableRegister = NO;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyboard)]];
    }
    
    return self;
}

///回收键盘
- (void)reconverKeyboard
{
    [self.password_textField resignFirstResponder];
}

- (void)setEnableRegister:(BOOL)enableRegister
{
    if(_enableRegister != enableRegister)
    {
        _enableRegister = enableRegister;
        _register_btn.enabled = _enableRegister;
        _register_btn.backgroundColor = _enableRegister ? WMButtonBackgroundColor : WMButtonDisableBackgroundColor;
    }
}

///密码可见
- (IBAction)tickAction:(id)sender
{
    self.tick_btn.selected = !self.tick_btn.selected;
    self.password_textField.secureTextEntry = !self.tick_btn.selected;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
}

///文本输入框改变
- (void)textFieldDidChange:(UITextField*) textField
{
    self.enableRegister = ![NSString isEmpty:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
