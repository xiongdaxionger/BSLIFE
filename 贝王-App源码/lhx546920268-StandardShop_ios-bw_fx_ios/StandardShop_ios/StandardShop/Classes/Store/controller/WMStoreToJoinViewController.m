//
//  WMStoreToJoinViewController.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMStoreToJoinViewController.h"
#import "WMStoreOperation.h"
#import "WMStoreToJoinInfo.h"

@interface WMStoreToJoinViewController ()<SeaHttpRequestDelegate,UITextFieldDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///门店加盟信息
@property(nonatomic,strong) WMStoreToJoinInfo *info;

@end

@implementation WMStoreToJoinViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.title)
    {
        self.title = @"合伙人加盟";
    }
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
    
    self.scrollView = self.bg_scrollView;
    self.bg_view.layer.cornerRadius = 2.0;
    self.bg_view.layer.borderColor = _separatorLineColor_.CGColor;
    self.bg_view.layer.borderWidth = _separatorLineWidth_;
    self.bg_view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.backItem = YES;
    
    [self.submit_btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    [self.submit_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.submit_btn.layer.cornerRadius = WMLongButtonCornerRaidus;
    self.submit_btn.titleLabel.font = WMLongButtonTitleFont;
    self.submit_btn.sea_heightLayoutConstraint.constant = WMLongButtonHeight;
    self.submit_btn.backgroundColor = WMButtonBackgroundColor;
    
    self.msg_label.font = [UIFont fontWithName:MainFontName size:16.0];
    self.msg_label.textColor = [UIColor grayColor];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
 
    UIFont *font = [UIFont fontWithName:MainFontName size:16.0];
    //手机号
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 30.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"电话";
    label.font = font;
    
    self.phone_number_textField.leftView = label;
    self.phone_number_textField.leftViewMode = UITextFieldViewModeAlways;
    self.phone_number_textField.delegate = self;
    self.phone_number_textField.font = font;
    
    //名称
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 30.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"姓名";
    label.font = font;
    
    self.name_textField.leftView = label;
    self.name_textField.leftViewMode = UITextFieldViewModeAlways;
    self.name_textField.delegate = self;
    self.name_textField.font = font;
    self.name_textField.inputLimitMax = WMUserNameInputLimitMax;
    [self.name_textField addTextDidChangeNotification];
    
    //城市
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 30.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"城市";
    label.font = font;
    
    self.city_textField.leftView = label;
    self.city_textField.leftViewMode = UITextFieldViewModeAlways;
    self.city_textField.delegate = self;
    self.city_textField.font = font;
    self.city_textField.inputLimitMax = WMCityInputLimitMax;
    [self.city_textField addTextDidChangeNotification];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reconverKeyBord)];
    [self.view addGestureRecognizer:tap];
    
    self.top_imageView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopImageView:)];
    [self.top_imageView addGestureRecognizer:tap];
    
    [self.name_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phone_number_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.city_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self enableSubmit];
}

///回收键盘
- (void)reconverKeyBord
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

///提交数据
- (IBAction)submit:(id)sender
{
    [self reconverKeyBord];
    
    if(![self.phone_number_textField.text isMobileNumber])
    {
        [self alertMsg:@"请输入有效的手机号"];
        return;
    }
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    self.httpRequest.identifier = WMStoreToJoinIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMStoreOperation storeToJoinParamWithPhoneNumber:self.phone_number_textField.text name:self.name_textField.text city:self.city_textField.text]];
}

///是否可以提交
- (void)enableSubmit
{
    BOOL enable = YES;
    
    if([NSString isEmpty:self.phone_number_textField.text])
    {
        enable = NO;
    }
    
    if([NSString isEmpty:self.name_textField.text])
    {
        enable = NO;
    }
    
    if([NSString isEmpty:self.city_textField.text])
    {
        enable = NO;
    }
    
    self.submit_btn.enabled = enable;
    self.submit_btn.backgroundColor = enable ? WMButtonBackgroundColor : [UIColor colorWithWhite:0.85 alpha:1.0];
}

///点击顶部图片
- (void)tapTopImageView:(UITapGestureRecognizer*) tap
{
    UIViewController *vc = self.info.adInfo.viewController;
    if(vc)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMStoreToJoinInfoIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMStoreToJoinIdentifier])
    {
        self.requesting = NO;
        [self alerBadNetworkMsg:@"提交信息失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMStoreToJoinInfoIdentifier])
    {
        self.loading = NO;
        WMStoreToJoinInfo *info = [WMStoreOperation storeToJoinInfoFromData:data];
        [self.top_imageView sea_setImageWithURL:info.adInfo.imageURL];
        self.info = info;
        
        if(![NSString isEmpty:info.msg])
        {
            WeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[info.msg dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                   
                    weakSelf.msg_label.attributedText = attr;
                });
            });
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMStoreToJoinIdentifier])
    {
        self.requesting = NO;
        if([WMStoreOperation storeToJoinResultFromData:data])
        {
            NSString *title = @"请求已发送，请等待客服人员与您联系";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            self.name_textField.text = nil;
            self.phone_number_textField.text = nil;
            self.city_textField.text = nil;
        }
        
        return;
    }
}

- (void)reloadDataFromNetwork
{
    ///加载门店加盟信息
    self.loading = YES;
    self.httpRequest.identifier = WMStoreToJoinInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMStoreOperation storeToJoinInfoParams]];
}

#pragma mark- UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.phone_number_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMPhoneNumberInputLimitMax];
    }
    else if ([textField isEqual:self.name_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMUserNameInputLimitMax];
    }
    else if ([textField isEqual:self.city_textField])
    {
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMCityInputLimitMax];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    dispatch_after(_animatedDuration_, dispatch_get_main_queue(), ^(void){
        
        [self.scrollView setContentOffset:CGPointMake(0, MIN(self.scrollView.contentSize.height - (self.view.height - self.keyboardFrame.size.height), self.bg_view.top - 10.0)) animated:YES];
    });
}

///文本输入框改变
- (void)textFieldDidChange:(UITextField*) textField
{
    [self enableSubmit];
}


@end
