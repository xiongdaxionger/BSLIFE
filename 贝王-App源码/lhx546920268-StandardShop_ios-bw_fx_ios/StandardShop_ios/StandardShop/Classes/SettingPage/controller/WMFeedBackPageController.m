//
//  FeedBackPageController.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMFeedBackPageController.h"

#import "WMSettingOperation.h"

#import "WMFeedBackTypeCell.h"

#import "UITextView+Utilities.h"

@interface WMFeedBackPageController ()<UIAlertViewDelegate,SeaHttpRequestDelegate,UITextViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/**配置数组
 */
@property (strong,nonatomic) NSArray *configArr;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**意见反馈类型数组,元素是NSDictionary
 */
@property (strong,nonatomic) NSArray *suggestArr;
/**客服电话
 */
@property (copy,nonatomic) NSString *mobile;
/**选择的下标
 */
@property (assign,nonatomic) NSInteger selectIndex;
/**键盘是否显示
 */
@property (assign,nonatomic) BOOL keyboardHidden;
/**滚动视图
 */
@property (strong,nonatomic) UIScrollView *scrollView;
/**输入内容
 */
@property (strong,nonatomic) SeaTextView *inPutView;
/**反馈标题
 */
@property (strong,nonatomic) UITextField *titleInput;
/**联系方式
 */
@property (strong,nonatomic) UITextField *contactInput;
/**类型选择集合视图
 */
@property (strong,nonatomic) UICollectionView *collectionView;
/**遮挡视图
 */
@property (strong,nonatomic) UIView *showView;

@end

@implementation WMFeedBackPageController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
        self.showView.backgroundColor = [UIColor clearColor];
        
        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
        
        self.backItem = YES;
        
        self.title = @"意见反馈";
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.selectIndex = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.loading = YES;
    
    [self reloadDataFromNetwork];
}

- (void)viewDidLayoutSubviews{
    
    if (self.scrollView) {
        
        [self.scrollView setContentSize:CGSizeMake(_width_, self.contentHeight)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
            self.scrollView.contentOffset = CGPointMake(0, _inPutView.frame.origin.y - 10.0);
        }
    }];
    
    self.scrollView.contentSize = CGSizeMake(_width_, self.contentHeight);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [_showView removeFromSuperview];
    
    self.keyboardHidden = YES;
    
    [self keyboardWillChangeFrame:notification];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view addSubview:_showView];
    
    self.keyboardHidden = NO;
    
    [self keyboardWillChangeFrame:notification];
}

- (void)reconverKeyboard
{
    [_inPutView resignFirstResponder];
    
    [_contactInput resignFirstResponder];
    
    [_titleInput resignFirstResponder];
}

- (void)tapShowView{
    
    [self reconverKeyboard];
}

#pragma mark - 网络请求
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGetFeedBackTypeIden]) {
        
        NSDictionary *typesDict = [WMSettingOperation returnFeedBackTypeResult:data];
        
        if (typesDict) {
            
            self.suggestArr = [typesDict arrayForKey:@"type"];
            
            self.mobile = [typesDict sea_stringForKey:@"phone"];
            
            [self configureUI];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMCommitFeedBackIden]){
        
        if ([WMSettingOperation returnFeedBackResultWithData:data]) {
            
            [self alertMsg:@"您的宝贵意见我们已经接受，我们会尽快给您回复，谢谢"];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
    }
}

- (void)failToLoadData{
    
    [self reloadDataFromNetwork];
}

#pragma mark - 获取意见反馈类型
- (void)reloadDataFromNetwork{
    
    self.request.identifier = WMGetFeedBackTypeIden;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMSettingOperation returnFeedBackTypeParam]];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    CGFloat margin = 10.0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight - WMLongButtonHeight - margin - (isIPhoneX ? 35.0 : 0.0))];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    
    UIFont *font = [UIFont fontWithName:MainFontName size:14.0];
    
    UIColor *textColor = MainGrayColor;
    
    UIColor *backgroundColor = [UIColor whiteColor];
    
    _titleInput = [[UITextField alloc] initWithFrame:CGRectMake(margin, margin, _width_ - 2 * margin, 40.0)];
    
    _titleInput.placeholder = @"  请输入反馈标题";
    
    _titleInput.delegate = self;
    
    _titleInput.textColor = textColor;
    
    _titleInput.font = font;
    
    _titleInput.backgroundColor = backgroundColor;
    
    _titleInput.returnKeyType = UIReturnKeyDone;
    
    [self.scrollView addSubview:_titleInput];
    
    _inPutView = [[SeaTextView alloc] initWithFrame:CGRectMake(margin, _titleInput.bottom + margin, _width_ - margin * 2, 160.0)];
    
    _inPutView.delegate = self;
    
    _inPutView.maxCount = 150.0;
    
    _inPutView.backgroundColor = [UIColor whiteColor];
    
    _inPutView.limitable = YES;
    
    _inPutView.textColor = textColor;
    
    _inPutView.font = font;
    
    _inPutView.placeholderFont = font;
    
    _inPutView.placeholder = @"请尽量详细描述反馈，我们会第一时间帮您解决";
    
    _inPutView.returnKeyType = UIReturnKeyNext;
    
    [self.scrollView addSubview:_inPutView];
    
    _contactInput = [[UITextField alloc] initWithFrame:CGRectMake(margin, _inPutView.bottom + margin, _width_ - 2 * margin, 40.0)];
    
    _contactInput.placeholder = @"  请留下您的邮箱、QQ或手机号";
    
    _contactInput.delegate = self;
    
    _contactInput.textColor = textColor;
    
    _contactInput.backgroundColor = backgroundColor;
    
    _contactInput.font = font;
    
    _contactInput.returnKeyType = UIReturnKeyDone;
    
    [self.scrollView addSubview:_contactInput];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _contactInput.bottom + margin / 2.0, _width_, 25.0)];
    
    label.textColor = textColor;
    
    label.text = @"  意见反馈类型";
    
    label.font = font;
    
    [self.scrollView addSubview:label];
    
    UICollectionViewFlowLayout *layOut = [UICollectionViewFlowLayout new];
    
    layOut.itemSize = CGSizeMake((_width_ - 4.0 * margin) / 3.0, 33.0);
    
    layOut.minimumLineSpacing = margin;
    
    layOut.minimumInteritemSpacing = margin;
    
    layOut.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    NSInteger count = 0;
    
    if (self.suggestArr.count % 3 == 0) {
        
        count = self.suggestArr.count / 3;
    }
    else{
        
        count = self.suggestArr.count / 3 + 1;
    }
    
    UINib *nib = [UINib nibWithNibName:@"WMFeedBackTypeCell" bundle:nil];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, label.bottom + margin / 2.0, _width_, count * 33.0 + (count - 1) * margin) collectionViewLayout:layOut];
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kTypeCollectionViewCellIden];
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:self.collectionView];
    
    NSString *string = [NSString stringWithFormat:@"客服电话:%@",self.mobile];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MainGrayColor} range:NSMakeRange(0, attrString.string.length)];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(1.0)} range:[string rangeOfString:self.mobile]];
    
    UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, self.collectionView.bottom + margin, _width_ - margin * 2, 21.0)];
    
    callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [callButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    [callButton addTarget:self action:@selector(callButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (![NSString isEmpty:self.mobile]) {
        
        [_scrollView addSubview:callButton];
    }
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, self.scrollView.bottom, _width_ - 2 * margin, WMLongButtonHeight)];
    
    commitButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    commitButton.backgroundColor = WMRedColor;
    
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitButton];
}

- (void)commitButtonClick{
    
    if ([NSString isEmpty:self.titleInput.text]) {
        
        [self alertMsg:@"请输入反馈标题"];
        
        return;
    }
    
    if ([NSString isEmpty:self.inPutView.text]) {
        
        [self alertMsg:@"请输入反馈内容"];
        
        return;
    }
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMCommitFeedBackIden;
    
    NSDictionary *dict = [self.suggestArr objectAtIndex:self.selectIndex];
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMSettingOperation returnFeedBackParamWith:[dict sea_stringForKey:@"type_id"] content:self.inPutView.text contact:self.contactInput.text title:self.titleInput.text receive:@"管理员"]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.suggestArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMFeedBackTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTypeCollectionViewCellIden forIndexPath:indexPath];
    
    [cell configureWithInfo:[self.suggestArr objectAtIndex:indexPath.row] select:self.selectIndex == indexPath.row];
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.titleInput]) {
        
        return [textField textShouldChangeCharactersInRange:range replacementString:string limitedCount:WMConsigneeInputLimitMax];
    }
    else{
        
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self reconverKeyboard];
    
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return [self.inPutView shouldChangeTextInRange:range replacementText:text];
}

#pragma mark - 拨打电话
- (void)callButtonAction{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.mobile];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}










@end
