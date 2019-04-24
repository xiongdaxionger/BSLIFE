//
//  WMUserInfoModifyController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMUserInfoModifyController.h"
#import "WMUserOperation.h"
#import "WMSettingInfo.h"
#import "WMUserInfo.h"
#import "WMSettingInfo.h"
#import "SeaNumberKeyboard.h"

@interface WMUserInfoModifyController ()<SeaHttpRequestDelegate,UITextViewDelegate>

/**单行输入框
 */
@property(nonatomic,strong) UITextField *textField;

/**提示信息
 */
@property(nonatomic,strong) UILabel *msgLabel;

/**多行输入框
 */
@property(nonatomic,strong) SeaTextView *textView;

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**当前登录的用户信息
 */
@property(nonatomic,strong) WMUserInfo *userInfo;

@end

@implementation WMUserInfoModifyController


#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.rightBarButtonItem.enabled = YES;
    self.requesting = NO;
    self.showNetworkActivity = NO;
    [self alerBadNetworkMsg:[NSString stringWithFormat:@"修改%@失败", self.title]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.rightBarButtonItem.enabled = YES;
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMModifyUserInfoIdentifier])
    {
        if(![WMUserOperation modifyUserInfoResultFromData:data])
        {
            return;
        }
    }
    
    if([request.identifier isEqualToString:WMSetupUsernameIdentifier])
    {
        if(![WMUserOperation setupUsernameResultFromData:data])
        {
            return;
        }
    }
    
    self.settingInfo.content = _textField == nil ? _textView.text : _textField.text;
    
    switch (self.settingInfo.type)
    {
        case WMSettingTypeName :
        {
            WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
            userInfo.name = self.settingInfo.content;
            [userInfo saveUserInfoToUserDefaults];
        }
            break;
        case WMSettingTypeAccount :
        {
            self.settingInfo.selectable = NO;
            WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
            userInfo.account = self.settingInfo.content;
            [userInfo saveUserInfoToUserDefaults];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMUserInfoDidModifyNotification object:nil];
    [self back];
}

#pragma mark- 加载视图


- (void)back
{
    [self reconverKeyBord];
    [super back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    //[self setBarItemsWithTitle:@"保存" icon:nil action:@selector(save) position:SeaNavigationItemPositionRight];
    self.backItem = YES;
    
    CGFloat topMargin = 15.0;
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    UIColor *textColor = [UIColor blackColor];
    
    _userInfo = [WMUserInfo sharedUserInfo];
    
    CGFloat y = 0;
    self.title = self.settingInfo.title;
    
    switch (self.settingInfo.type)
    {
//        case WMSettingTypeSignature :
//        {
//            _textView = [[SeaTextView alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, topMargin, _width_ + _separatorLineWidth_ * 2, 100.0)];
//            _textView.backgroundColor = [UIColor whiteColor];
//            _textView.font = font;
//            _textView.textColor = [UIColor blackColor];
//            _textView.limitable = YES;
//            _textView.maxCount = WMPersonIntroInputLimitMax;
//            _textView.text = self.settingInfo.content;
//            _textView.layer.borderColor = _separatorLineColor_.CGColor;
//            _textView.layer.borderWidth = _separatorLineWidth_;
//            _textView.delegate = self;
//            [self.view addSubview:_textView];
//            y = _textView.bottom;
//        }
//            break;
        default:
        {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, topMargin, _width_ + _separatorLineWidth_ * 2, 40.0)];
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _textField.backgroundColor = [UIColor whiteColor];
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.textColor = textColor;
            _textField.font = font;
            _textField.layer.borderColor = _separatorLineColor_.CGColor;
            _textField.layer.borderWidth = _separatorLineWidth_;
            
            
            _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 40.0)];
            _textField.leftViewMode = UITextFieldViewModeAlways;
            _textField.delegate = self;
            [self.view addSubview:_textField];
            
            _textField.text = _settingInfo.content;
            self.title = _settingInfo.title;
            _textField.placeholder = [NSString stringWithFormat:@"输入%@", self.title];
            
            
            y = _textField.bottom;
            
            NSString *title = nil;
            switch (_settingInfo.type)
            {
                case WMSettingTypeName :
                {
//                    _textField.inputLimitMax = WMUserNameInputLimitMax;
//                    _textField.chineseAsTwoCharWhenInputLimit = YES;
//                    [_textField addTextDidChangeNotification];
//                    title = [NSString stringWithFormat:@"姓名不能超过%d个汉字或%d个英文字符，支持中文、数字、下划线", WMUserNameInputLimitMax / 2, WMUserNameInputLimitMax];
                }
                    break;
                case WMSettingTypeOther :
                {
                    switch (_settingInfo.contentType)
                    {
                        case WMSettingContentTypeNumber :
                        {
                            _textField.keyboardType = UIKeyboardTypeNumberPad;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case WMSettingTypeAccount :
                {
                    title = [NSString stringWithFormat:@"* %@设置后不可修改", _settingInfo.title];
                }
                    break;
                default:
                    break;
            }
            if(title != nil)
            {
                font = [UIFont fontWithName:MainFontName size:13.0];
                CGSize size = [title stringSizeWithFont:font contraintWith:_width_ - topMargin * 2];
                _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(topMargin, _textField.bottom + 10.0, _width_ - topMargin * 2, size.height)];
                _msgLabel.numberOfLines = 0;
                _msgLabel.textColor = [UIColor grayColor];
                _msgLabel.font = font;
                
                if(_settingInfo.type == WMSettingTypeAccount)
                {
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
                    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                    _msgLabel.attributedText = text;
                }
                else
                {
                    _msgLabel.text = title;
                }
                
                [self.view addSubview:_msgLabel];
                y = _msgLabel.bottom;
            }
        }
            break;
    }
    
    //保存按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = WMButtonBackgroundColor;
    btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = WMLongButtonTitleFont;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    btn.frame = CGRectMake(15.0, y + 30.0, _width_ - 15 * 2, WMLongButtonHeight);
    [self.view addSubview:btn];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)];
    [self.view addGestureRecognizer:tap];
    
    [_textField becomeFirstResponder];
    [_textView becomeFirstResponder];
}

//回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//保存
- (void)save
{
    if(_textField != nil && [NSString isEmpty:_textField.text])
    {
        [self alertMsg:[NSString stringWithFormat:@"%@不能为空", self.title]];
        return;
    }
    
    ///内容没有修改，直接返回
    if(_textField != nil && [_textField.text isEqualToString:_settingInfo.content])
    {
        [self back];
        return;
    }

    switch (_settingInfo.contentType)
    {
        case WMSettingContentTypeNumber :
        {
            if(![_textField.text isNumText])
            {
                [self alertMsg:[NSString stringWithFormat:@"%@只能输入数字", self.title]];
                return;
            }
        }
            break;
        case WMSettingContentTypeLetter :
        {
            if(![_textField.text isLetterText])
            {
                [self alertMsg:[NSString stringWithFormat:@"%@只能输入字母", self.title]];
                return;
            }
        }
            break;
        case WMSettingContentTypeLetterAndNumber :
        {
            if(![_textField.text isLetterAndNumberText])
            {
                [self alertMsg:[NSString stringWithFormat:@"%@只能输入字母和数字", self.title]];
                return;
            }
        }
            break;
        default:
            break;
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    NSString *content = _textField.text;
    if(content == nil)
    {
        content = _textView.text;
    }
    
    if(self.settingInfo.type == WMSettingTypeAccount)
    {
        self.httpRequest.identifier = WMSetupUsernameIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation setupUsernameParams:content]];
    }
    else
    {
        NSString *key = self.settingInfo.key;
        
        if(key != nil)
        {
            self.httpRequest.identifier = WMModifyUserInfoIdentifier;
            [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation modifyUserInfoParamWithDictionary:[NSDictionary dictionaryWithObject:content forKey:key]]];
        }
    }
}


#pragma mark- UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (_settingInfo.type)
    {
        case WMSettingTypeName :
        {
//            return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCountChinesseAsTwoChar:WMUserNameInputLimitMax];
        }
            break;
        default:
        {
            return YES;
        }
            break;
    }
    
    return YES;
}

#pragma mark- UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [_textView shouldChangeTextInRange:range replacementText:text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_textView textDidChange];
}

@end
