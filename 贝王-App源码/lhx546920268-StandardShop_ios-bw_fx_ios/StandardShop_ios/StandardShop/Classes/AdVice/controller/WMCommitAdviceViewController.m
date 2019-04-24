//
//  WMCommitAdviceViewController.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCommitAdviceViewController.h"

#import "WMAdviceTypeInfo.h"
#import "WMAdviceOperation.h"
#import "WMAdviceQuestionInfo.h"
#import "WMAdviceSettingInfo.h"

#import "WMImageVerificationCodeView.h"
#import "WMFeedBackTypeCell.h"

@interface WMCommitAdviceViewController ()<SeaHttpRequestDelegate,UITextViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**验证码视图
 */
@property (strong,nonatomic) WMImageVerificationCodeView *codeView;
/**类型集合视图
 */
@property (strong,nonatomic) UICollectionView *collectionView;
@end

@implementation WMCommitAdviceViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"发表咨询";
    
    self.backItem = YES;
    
    self.selectIndex = 0;
        
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    
    CGFloat margin = 10.0;
    
    UIFont *font = [UIFont fontWithName:MainFontName size:13.0];
    
    UIColor *textColor = MainGrayColor;
    
    _intPutView = [[SeaTextView alloc] initWithFrame:CGRectMake(margin, margin, _width_ - margin * 2, 150.0)];
    
    _intPutView.delegate = self;
    
    _intPutView.maxCount = 100.0;
    
    _intPutView.backgroundColor = [UIColor whiteColor];
    
    _intPutView.limitable = YES;
    
    _intPutView.textColor = textColor;
    
    _intPutView.font = font;
    
    _intPutView.placeholderFont = font;
        
    _intPutView.placeholder = @"请输入咨询内容100字以内";
    
    _intPutView.returnKeyType = UIReturnKeyDone;
    
    [_scrollView addSubview:_intPutView];
    
    CGFloat bottom = 0.0;
    
    if ([NSString isEmpty:_settingInfo.askVerifyCode]) {
        
        bottom = _intPutView.bottom + margin;
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
        
        codeView.codeURL = _settingInfo.askVerifyCode;
        
        [_scrollView addSubview:codeView];
        
        _codeView = codeView;
        
        bottom = _codeView.bottom + margin;
    }
    
    CGFloat titleWidth = 60.0;
    
    margin = 20.0;
    
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin / 2.0, bottom, titleWidth, 21.0)];
    
    typeTitleLabel.text = @"咨询类型";
    
    typeTitleLabel.textColor = MainGrayColor;
    
    typeTitleLabel.backgroundColor = [UIColor clearColor];
    
    typeTitleLabel.font = font;
    
    [_scrollView addSubview:typeTitleLabel];
    
    margin = 10.0;
    
    for (NSInteger i = 0; i < _adviceTypeInfoArr.count; i++) {
        
        WMAdviceTypeInfo *info = [_adviceTypeInfoArr objectAtIndex:i];
        
        if (info.adviceTypeIsSelect) {
            
            _selectIndex = i;
            
            break;
        }
    }
    
    UICollectionViewFlowLayout *layOut = [UICollectionViewFlowLayout new];
    
    layOut.itemSize = CGSizeMake((_width_ - 4.0 * margin) / 3.0, 33.0);
    
    layOut.minimumLineSpacing = margin;
    
    layOut.minimumInteritemSpacing = margin;
    
    layOut.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UINib *nib = [UINib nibWithNibName:@"WMFeedBackTypeCell" bundle:nil];
    
    NSInteger count = 0;
    
    if (_adviceTypeInfoArr.count % 3 == 0) {
        
        count = _adviceTypeInfoArr.count / 3;
    }
    else{
        
        count = _adviceTypeInfoArr.count / 3 + 1;
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, typeTitleLabel.bottom + margin / 2.0, _width_, count * 33.0 + (count - 1) * margin) collectionViewLayout:layOut];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kTypeCollectionViewCellIden];
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:self.collectionView];
    
    margin = 20.0;
    
    UILabel *hiddenNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin / 2.0, self.collectionView.bottom + margin / 2.0 + 8.0, titleWidth, 21.0)];
    
    hiddenNameTitleLabel.text = @"匿名咨询";
    
    hiddenNameTitleLabel.textColor = MainGrayColor;
    
    hiddenNameTitleLabel.backgroundColor = [UIColor clearColor];
    
    hiddenNameTitleLabel.font = font;
    
    margin = 10.0;
    
    [_scrollView addSubview:hiddenNameTitleLabel];
    
    UISwitch *hiddenNameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(hiddenNameTitleLabel.right + margin, 0, 100, 100)];
    
    hiddenNameSwitch.centerY = hiddenNameTitleLabel.centerY;
    
    [hiddenNameSwitch setOn:NO];
    
    [hiddenNameSwitch addTarget:self action:@selector(hiddenNameSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [_scrollView addSubview:hiddenNameSwitch];
    
    NSString *string = [NSString stringWithFormat:@"%@:%@",self.settingInfo.adviceQuestionTip,self.settingInfo.adviceServicePhone];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainGrayColor} range:NSMakeRange(0, attrString.string.length)];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(1.0)} range:[string rangeOfString:self.settingInfo.adviceServicePhone]];
    
    UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, hiddenNameTitleLabel.bottom + margin, _width_ - margin * 2, 21.0)];
    
    callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [callButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    [callButton addTarget:self action:@selector(callButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (![NSString isEmpty:self.settingInfo.adviceServicePhone]) {
        
        [_scrollView addSubview:callButton];
    }
    
    margin = 10.0;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont fontWithName:MainFontName size:MainFontSize56];
    
    [btn setBackgroundColor:WMRedColor];
    
    [btn setFrame:CGRectMake(margin, self.contentHeight - margin - WMLongButtonHeight, _width_ - 2 * margin, WMLongButtonHeight)];
    
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

#pragma mark - 发布咨询
- (void)upload
{
    if([NSString isEmpty:_intPutView.text])
    {
        [self alertMsg:@"请输入咨询内容"];
        
        return;
    }
    
    if (![NSString isEmpty:_settingInfo.askVerifyCode] && [NSString isEmpty:_codeView.textField.text]) {
        
        [self alertMsg:@"请输入验证码"];
        
        return;
    }
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMCommitAdviceIdentifier;
    
    WMAdviceTypeInfo *info = [_adviceTypeInfoArr objectAtIndex:self.selectIndex];
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMAdviceOperation returnCommitAdviceWithGoodID:self.goodID isHiddenName:self.isHiddenName content:self.intPutView.text adviceTypeID:info.adviceTypeID askverifyCode:_codeView.textField.text]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _adviceTypeInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMFeedBackTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTypeCollectionViewCellIden forIndexPath:indexPath];
    
    WMAdviceTypeInfo *info = [_adviceTypeInfoArr objectAtIndex:indexPath.row];
    
    [cell configureWithInfo:@{@"name":info.adviceTypeName} select:self.selectIndex == indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectIndex == indexPath.row) {
        
        return;
    }
    else{
        
        self.selectIndex = indexPath.row;
        
        [self.collectionView reloadData];
    }
}

#pragma mark - 匿名发布
- (void)hiddenNameSwitchAction:(UISwitch *)view{
    
    self.isHiddenName = view.isOn;
}

#pragma mark - 拨打电话
- (void)callButtonAction{
    
    makePhoneCall(self.settingInfo.adviceServicePhone, YES);
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
    
    if ([request.identifier isEqualToString:WMCommitAdviceIdentifier]) {
        
        if ([WMAdviceOperation returnCommitAdviceResultWithData:data]) {
            
            [self alertMsg:self.settingInfo.commitAdviceSuccessTip];
            
            WMAdviceTypeInfo *info = [self.adviceTypeInfoArr objectAtIndex:self.selectIndex];
            
            NSDictionary *commentsDict = [[[NSJSONSerialization JSONDictionaryWithData:data] dictionaryForKey:WMHttpData] dictionaryForKey:@"comments"];
            
            if (!self.settingInfo.needAdminVerify && ([self.listSelectAdviceTypeID isEqualToString:@"0"] || [self.listSelectAdviceTypeID isEqualToString:info.adviceTypeID])) {
                
                NSDictionary *listDict = [commentsDict dictionaryForKey:@"list"];
                
                NSDictionary *newAdviceDict = [[listDict arrayForKey:@"ask"] firstObject];
                
                if (self.changeAdviceCount) {
                    
                    self.changeAdviceCount([WMAdviceOperation returnAdviceCommitSuccessTitlesArrWithDict:commentsDict]);
                }
                
                if (self.commitAdviceSuccess) {
                    
                    self.commitAdviceSuccess([WMAdviceQuestionInfo returnAdviceContentInfoWithDict:newAdviceDict]);
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WMCommitAdviceSuccessNotification object:nil];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
        else{
            
            self.requesting = NO;
        }
    }
}
















@end
