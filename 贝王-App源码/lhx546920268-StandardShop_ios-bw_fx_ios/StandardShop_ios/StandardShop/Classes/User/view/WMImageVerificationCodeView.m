//
//  WMImageVerificationCodeView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMImageVerificationCodeView.h"

@implementation WMImageVerificationCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }

    return self;
}

- (void)initialization
{
    _textField = [[UITextField alloc] init];
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.font = [UIFont fontWithName:MainFontName size:16.0];
    _textField.placeholder = @"图形验证码";
    _textField.forbidInputChinese = YES;
    _textField.delegate = self;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
   // [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.forbidSelectors = [NSArray arrayWithObjects:NSStringFromSelector(@selector(paste:)), nil];

    UIImage *image = [UIImage imageNamed:@"login_image_code"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15.0, image.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = image;
    _textField.leftView = imageView;

    [self addSubview:_textField];


    _code_imageView = [[UIImageView alloc] init];
    _code_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _code_imageView.contentMode = UIViewContentModeScaleAspectFit;
    _code_imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeDidChange:)];
    [_code_imageView addGestureRecognizer:tap];

    [self addSubview:_code_imageView];


    NSDictionary *views = NSDictionaryOfVariableBindings(_textField, _code_imageView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_textField]-0-[_code_imageView]-10-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];

    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_textField]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:constraints];

    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_code_imageView(20)]" options:0 metrics:nil views:views];
    [self addConstraints:constraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_code_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_code_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_code_imageView attribute:NSLayoutAttributeHeight multiplier:64.0 / 20.0 constant:0]];
}

- (void)setCodeURL:(NSString *)codeURL
{
    if(_codeURL != codeURL)
    {
        _codeURL = codeURL;
        [self refreshCode];
    }
}

- (void)codeDidChange:(id) sender
{
    if(self.codeURL)
    {
        _textField.text = nil;
        //写在cookie里
        [_code_imageView sea_setImageWithURL:[NSString stringWithFormat:@"%@?%.0f", self.codeURL, [[NSDate date] timeIntervalSince1970]]];
    }
}

///刷新验证码
- (void)refreshCode
{
    [self codeDidChange:nil];
}

#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMImageCodeInputLimitMax];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

///输入改变
- (void)textDidChange:(UITextField*) textField
{
    //[textField unmarkText];
}

@end
