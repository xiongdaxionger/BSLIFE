//
//  WMLoginViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMLoginViewController.h"
#import "SeaHttpRequest.h"
#import "WMUserInfo.h"
#import "WMUserOperation.h"
#import "WMResetLogInPassViewController.h"
#import "SeaNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WMPhoneInputViewController.h"
#import "WMTabBarController.h"
#import "WMImageVerificationCodeView.h"
#import "WMBindPhoneNumberViewController.h"
#import "WMShareOperation.h"
#import "WMSocialLoginOperation.h"
#import "WMLoginPageInfo.h"
#import "WMLoginPageInfo.h"
#import "WMSocialLoginCell.h"

@interface WMLoginViewController ()<SeaHttpRequestDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CAAnimationDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpReqeust;

///是否是社交账号登录
@property(nonatomic,assign) BOOL isSocailLogin;

///是否需要刷新验证码
@property(nonatomic,assign) BOOL needRefresh;

///授权用户
@property(nonatomic,strong) WMSocialUser *authorizedUser;

///第三方登录操作
@property(nonatomic,strong) WMSocialLoginOperation *socialLoginOperation;

///登录页面信息
@property(nonatomic,strong) WMLoginPageInfo *loginPageInfo;

///当前动画到第几个
@property(nonatomic,assign) NSInteger animationIndex;

///是否需要动画
@property(nonatomic, assign) BOOL shouldAnimate;

@end

@implementation WMLoginViewController

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_width_ == 320)
    {
        [self addKeyboardNotification];
    }
    if(self.needRefresh)
    {
        self.needRefresh = NO;
        [self.image_code_view refreshCode];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_width_ == 320)
    {
        [self removeKeyboardNotification];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.animationIndex = NSNotFound;
    self.shouldAnimate = NO;
    [self.social_collectionView reloadData];
    self.shouldAnimate = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.animationIndex == NSNotFound)
    {
        self.animationIndex = 0;
        [self.social_collectionView reloadData];
    }
}

- (void)back
{
//    if(![AppDelegate instance].isLogin && ([AppDelegate tabBarController].selectedIndex == 3))
//    {
//        [AppDelegate tabBarController].selectedIndex = 0;
//    }
//    
    [super back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    

    [WMUserInfo logout];
    self.animationIndex = NSNotFound;

    self.bg_view.backgroundColor = _separatorLineColor_;
    
    self.backItem = YES;
    
    CGFloat contentHeight = 321.0;
    if(is3_5Inch)
    {
        contentHeight -= self.bg_view.sea_topLayoutConstraint.constant;
        self.bg_view.sea_topLayoutConstraint.constant = 15.0;
        contentHeight += 15;
    }
    
    self.social_collectionViewTopLayoutConstraint.constant = _height_ - self.statusBarHeight - self.navigationBarHeight - contentHeight - self.social_collectionView.sea_heightLayoutConstraint.constant + 50.0;

    self.password_textField_topLayoutConstraint.constant = _separatorLineWidth_;
    self.image_code_view_topLayoutConstraint.constant = _separatorLineWidth_;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
    UIColor *textColor = MainGrayColor;
    
    self.login_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.login_btn.titleLabel.font = WMLongButtonTitleFont;
    self.login_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
    [self.login_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [self.login_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.login_btn.backgroundColor = WMButtonBackgroundColor;
    
    self.forget_passwd_btn.titleLabel.font = font;
    [self.forget_passwd_btn setTitleColor:textColor forState:UIControlStateNormal];
    self.register_btn.titleLabel.font = self.forget_passwd_btn.titleLabel.font;
    [self.register_btn setTitleColor:textColor forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = self.bg_scrollView;
    
    self.social_flowLayout.itemSize = CGSizeMake(70.0, 75.0);
    self.social_flowLayout.minimumInteritemSpacing = 0;
    self.social_flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.social_collectionView.backgroundColor = [UIColor clearColor];
    [self.social_collectionView registerNib:[UINib nibWithNibName:@"WMSocialLoginCell" bundle:nil] forCellWithReuseIdentifier:@"WMSocialLoginCell"];
    
    //账号名称
    CGFloat width = 50.0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
    label.font = font;
    label.text = @"账号";
    label.textColor = [UIColor blackColor];
    
    self.phone_numberTextField.leftView = label;
    self.phone_numberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phone_numberTextField.delegate = self;
    self.phone_numberTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginAccount];
    self.phone_numberTextField.font = font;

    //密码名称
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, font.lineHeight)];
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.text = @"密码";
    
    self.password_textField.leftView = label;
    self.password_textField.leftViewMode = UITextFieldViewModeAlways;
    self.password_textField.delegate = self;
    self.password_textField.font = font;
    
    ///验证码
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, font.lineHeight)];
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.text = @"图形验证码";
    self.image_code_view.textField.leftView = label;
    self.image_code_view.textField.leftViewMode = UITextFieldViewModeAlways;
    self.image_code_view.textField.placeholder = nil;
    
    
    //眼睛，查看密码
//    image = [UIImage imageNamed:@"login_eye_open"];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:image forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"login_eye_close"] forState:UIControlStateSelected];
//    [btn addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setFrame:CGRectMake(0, 0, image.size.width + expand, 40.0)];
//    self.password_textField.rightView = btn;
//    self.password_textField.rightViewMode = UITextFieldViewModeAlways;
    
    self.httpReqeust = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    /**
     *  监听app状态
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    ///文本输入框改变
    [self.password_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phone_numberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.image_code_view.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self enableLogin];

    [self setImageCodeHidden:YES];

    [self loadImageCode];
    
    self.socialLoginOperation = [[WMSocialLoginOperation alloc] init];
}

///设置图形验证码显示
- (void)setImageCodeHidden:(BOOL) hidden
{
    self.image_code_view.hidden = hidden;
    self.bg_view.sea_heightLayoutConstraint.constant = hidden ? (100 + _separatorLineWidth_ * 2) : (150 + _separatorLineWidth_ * 3);
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///眼睛
- (IBAction)eyeAction:(id)sender
{
    self.eye_btn.selected = !self.eye_btn.selected;
    self.password_textField.secureTextEntry = !self.eye_btn.selected;
}

#pragma mark- action

/**获取验证码链接
 */
- (void)loadImageCode
{
    self.httpReqeust.identifier = WMLoginNeedIdentifier;
    [self.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation loginNeedParams]];
}

/**登录
 */
- (IBAction)login:(id)sender
{
    self.authorizedUser = nil;
    self.isSocailLogin = NO;
    
    if(self.password_textField.text.length < WMPasswordInputLimitMin)
    {
        [self alertMsg:@"密码错误"];
        return;
    }

    NSString *code = self.image_code_view.textField.text;
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.httpReqeust.identifier = WMLoginIdentifier;
    [self.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation loginParamWithAccout:self.phone_numberTextField.text password:self.password_textField.text code:code]];
}

///是否能够登录
- (void)enableLogin
{
    BOOL enable = YES;
    
    if([NSString isEmpty:self.phone_numberTextField.text])
    {
        enable = NO;
    }
    
    if([NSString isEmpty:self.password_textField.text])
    {
        enable = NO;
    }
    
    NSString *code = self.image_code_view.textField.text;
    if(!self.image_code_view.hidden && [NSString isEmpty:code])
    {
        enable = NO;
    }
    
    self.login_btn.enabled = enable;
    self.login_btn.backgroundColor = enable ? WMButtonBackgroundColor : WMButtonDisableBackgroundColor;
}

///忘记密码
- (IBAction)forgetButtonAction:(UIButton *)sender {

    self.needRefresh = YES;
    WMResetLogInPassViewController *forgetLogIn = [[WMResetLogInPassViewController alloc] init];
    forgetLogIn.phoneNumber = self.phone_numberTextField.text;
    [self.navigationController pushViewController:forgetLogIn animated:YES];
}

///注册
- (IBAction)registerAction:(id)sender
{
    self.needRefresh = YES;
    WMPhoneInputViewController *registerVC = [[WMPhoneInputViewController alloc] init];
    registerVC.loginCompletionHandler = self.loginCompletionHandler;
    [self.navigationController pushViewController:registerVC animated:YES];
}

///查看密码
- (void)seePassword:(UIButton*) btn
{
    btn.selected = !btn.selected;
    self.password_textField.secureTextEntry = !btn.selected;
}

#pragma mark- 社交账号登录

///微信登录
- (IBAction)weixinLogin
{
    if(![WXApi isWXAppInstalled])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未安装微信客户端，请使用其他登录方式，或者注册一个账号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    [self socialLoginWithPlatform:WMPlatformTypeWeixin];
}


///qq登录
- (IBAction)qqLogin
{
    [self socialLoginWithPlatform:WMPlatformTypeQQ];
}

///社交账号登录
- (void)socialLoginWithPlatform:(WMPlatformType) platform
{
    WeakSelf(self);
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.isSocailLogin = YES;
    
    [self.socialLoginOperation authorize:platform completion:^(BOOL success, WMSocialUser *user, NSError *error){
       
        if(success)
        {
            weakSelf.authorizedUser = user;
            weakSelf.isSocailLogin = NO;
            weakSelf.requesting = YES;
            weakSelf.showNetworkActivity = YES;
            
            weakSelf.httpReqeust.identifier = WMSocialLoginIdentifier;
            [weakSelf.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation socialLoginWithUser:user]];
        }
        else
        {
            weakSelf.requesting = NO;
            weakSelf.isSocailLogin = NO;
            NSLog(@"取消授权 %@", error);
        }
    }];
}

///加载个人信息
- (void)loadUserInfo
{
    self.httpReqeust.identifier = WMGetUserInfoIdentifier;
    [self.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation userInfoParams]];
}

///animation for
- (void)animationCell:(UICollectionViewCell*) cell
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(cell.center.x, cell.center.y + 150)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(cell.center.x, cell.center.y)];
    animation.duration = 0.3;
    [cell.layer addAnimation:animation forKey:@"position"];
    cell.hidden = NO;
    
    self.animationIndex ++;
}


#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.loginPageInfo.socialLogins.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(self.loginPageInfo.socialLogins.count == 0)
        return UIEdgeInsetsZero;
    
    if(self.loginPageInfo.socialLogins.count == 1)
    {
        CGFloat margin = (_width_ - 10.0 * 2 - self.social_flowLayout.itemSize.width * self.loginPageInfo.socialLogins.count) / 2;
        
        if(margin < 0)
            margin = 0;
        
        return UIEdgeInsetsMake(0, margin, self.social_collectionView.sea_heightLayoutConstraint.constant - self.social_flowLayout.itemSize.height, margin);
    }
    else
    {
        return UIEdgeInsetsMake(0, 30.0, self.social_collectionView.sea_heightLayoutConstraint.constant - self.social_flowLayout.itemSize.height, 30.0);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(self.loginPageInfo.socialLogins.count < 2)
        return 0;
    
    CGFloat space = (_width_ - 40.0 * 2 - self.social_flowLayout.itemSize.width * self.loginPageInfo.socialLogins.count) / (self.loginPageInfo.socialLogins.count - 1);
    return space;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.shouldAnimate)
    {
        CGFloat delay = indexPath.item * 0.3;
        if(delay == 0)
        {
            [self animationCell:cell];
        }
        else
        {
            [self performSelector:@selector(animationCell:) withObject:cell afterDelay:delay];
        }
    }
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMSocialLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMSocialLoginCell" forIndexPath:indexPath];
    WMSocialLoginTypeInfo *info = [self.loginPageInfo.socialLogins objectAtIndex:indexPath.item];
    cell.imageView.image = info.image;
    cell.title_label.text = info.title;
    cell.hidden = self.animationIndex == NSNotFound || indexPath.item > self.animationIndex;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMSocialLoginTypeInfo *info = [self.loginPageInfo.socialLogins objectAtIndex:indexPath.item];
    switch (info.type)
    {
        case WMPlatformTypeQQ :
        {
            [self qqLogin];
        }
            break;
        case WMPlatformTypeWeixin :
        {
            [self weixinLogin];
        }
            break;
        default:
            break;
    }
}

#pragma mark- 通知

///
- (void)applicationDidBecomeActive:(NSNotification*) notification
{
    if(self.isSocailLogin)
    {
        self.requesting = NO;
        self.isSocailLogin = NO;
    }
}


#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    self.showNetworkActivity = NO;

    if([request.identifier isEqualToString:WMLoginNeedIdentifier])
    {

    }
    else
    {
        [self alerBadNetworkMsg:@"登录失败"];
        [WMUserInfo logout];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMLoginIdentifier])
    {
        NSString *codeURL = nil;
        WMLoginResult result = [WMUserOperation loginResultFromData:data alertFailMsg:YES errorMsg:nil codeURL:&codeURL];
        
        switch (result)
        {
            case WMLoginResultSuccess :
            {
                [self loadUserInfo];
            }
                break;
            case WMLoginResultNeedVerifyCode :
            {
                 self.requesting = NO;
                [self setImageCodeHidden:NO];
                self.image_code_view.codeURL = codeURL;
                [self enableLogin];
            }
                break;
            default:
            {
                 self.requesting = NO;
                [self.image_code_view refreshCode];
                [self enableLogin];
            }
                break;
        }
        return;
    }
    
    if([request.identifier isEqualToString:WMSocialLoginIdentifier])
    {
        WMLoginResult result = [WMUserOperation socialLoginResultFromData:data alertFailMsg:YES];
        
        switch (result)
        {
            case WMLoginResultSuccess :
            {
                [self loadUserInfo];
            }
                break;
            case WMLoginResultNeedAssociateAccount :
            {
                 self.requesting = NO;
                ///绑定手机号
                WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
                bind.authorizedUser = self.authorizedUser;
                bind.loginCompletionHandler = self.loginCompletionHandler;
                [self.navigationController pushViewController:bind animated:YES];
            }
                break;
            default:
            {
                self.requesting = NO;
                [self alertMsg:@"登录失败"];
            }
                break;
        }
        return;
    }

    if([request.identifier isEqualToString:WMGetUserInfoIdentifier])
    {
        self.requesting = NO;
        if([WMUserOperation userInfoFromData:data])
        {
            [self loginSuccess];
        }
        else
        {
            [WMUserInfo logout];
        }
    }
    
    if([request.identifier isEqualToString:WMLoginNeedIdentifier])
    {
        WMLoginPageInfo *info = [WMUserOperation loginNeedResultFromData:data];
        if(![NSString isEmpty:info.imageCodeURL])
        {
            self.image_code_view.codeURL = info.imageCodeURL;
            [self setImageCodeHidden:NO];
            [self enableLogin];
            
            self.social_collectionViewTopLayoutConstraint.constant -= 50.0;
        }
        
        self.loginPageInfo = info;
        
        self.shouldAnimate = YES;
        [self.social_collectionView reloadData];
        
        return;
    }
}

///登录成功处理
- (void)loginSuccess
{
    [AppDelegate instance].isLogin = YES;
    [self reconverKeyBord];
    
    if(self.authorizedUser)
    {
        [WMSocialLoginOperation saveSocialAuth:self.authorizedUser];
    }
    else
    {
        [SeaUserDefaults setObject:self.phone_numberTextField.text forKey:WMLoginAccount];
        [SeaUserDefaults setObject:self.password_textField.text forKey:WMLoginPassword];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMLoginSuccessNotification object:self];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
        !self.loginCompletionHandler ?: self.loginCompletionHandler();
    }];
}

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.phone_numberTextField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
    else if ([textField isEqual:self.password_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPasswordInputLimitMax];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(_width_ == 320.0)
//    {
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^(void){
//
//            CGPoint offset = CGPointMake(0, self.scrollView.contentSize.height - (self.view.height - self.keyboardFrame.size.height) - 30.0);
//            if(offset.y < 0)
//                offset.y = 0;
//
//            [self.scrollView setContentOffset:offset animated:YES];
//        });
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

///文本输入框改变
- (void)textFieldDidChange:(UITextField*) textField
{
    [self enableLogin];
}

#pragma mark- UICollectionView delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [touch.view isEqual:self.view];
}

@end
