//
//  WMInvioceViewController.m
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInvioceViewController.h"

#import "XTableCellConfigEx.h"
#import "WMInvioceTypeSelectViewCell.h"
#import "WMInvioceInputViewCell.h"

#import "UBPicker.h"

@interface WMInvioceViewController ()<SeaHttpRequestDelegate,UBPickerDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**选择器
 */
@property (strong,nonatomic) UBPicker *picker;
@end

@implementation WMInvioceViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.backItem = YES;
        
        self.title = @"发票信息";
        
        self.selectStatus = @{@"un_invioce":@(YES),@"person":@(NO),@"company":@(NO)};
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.invioceContent = [NSString new];
        
        self.invioceHeader = [NSString new];
        
        self.selectIndex = 0;
    }
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialization];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 键盘

- (void)keyboardWillHide:(NSNotification *)notification
{
    [super keyboardWillHide:notification];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [super keyboardWillShow:notification];
}

#pragma mark - 初始化
- (void)initialization{
    
    [super initialization];
    
    [self configureCellArr];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    UIView *commitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 49.0)];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, _width_ - 20, 49.0)];
    
    commitButton.backgroundColor = WMButtonBackgroundColor;
    
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    commitButton.layer.cornerRadius = 3.0;
    
    [commitButton addTarget:self action:@selector(commitButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [commitView addSubview:commitButton];
    
    self.tableView.tableFooterView = commitView;
}

- (void)configureCellArr{
    
    XTableCellConfigEx *invioceType = [XTableCellConfigEx cellConfigWithClassName:[WMInvioceTypeSelectViewCell class] heightOfCell:WMInvioceTypeSelectViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *invioceInput = [XTableCellConfigEx cellConfigWithClassName:[WMInvioceInputViewCell class] heightOfCell:WMInvioceInputViewCellHeight tableView:self.tableView isNib:YES];
    
    _configArr = @[invioceType,invioceInput];
}

#pragma mark - 网络请求
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
}

#pragma mark - 表格视图代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isOpenInvioce) {
        
        return 3;
    }
    else{
        
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfig:indexPath];
    
    id model = [self findModel:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfig:indexPath];
    
    return config.heightOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.isOpenInvioce) {
        
        if (section == 2) {
            
            return 20.0;
        }
    }
    else{
        
        return 20.0;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 返回订单配置和模型
- (XTableCellConfigEx *)findConfig:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return [_configArr firstObject];
    }
    else{
        
        return [_configArr lastObject];
    }
}

- (id)findModel:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return @{kControllerKey:self,@"is_content":@(NO),@"title":@"发票抬头",@"placeholder":@"可输入个人或单位名称",@"content":self.invioceHeader};
    }
    else if (indexPath.section == 2){
        
        return @{kControllerKey:self,@"is_content":@(YES),@"title":@"发票内容",@"placeholder":@"请选择发票内容",@"content":self.invioceContent};
    }
    
    return @{kControllerKey:self,kModelKey:self.selectStatus};
}

#pragma mark - 保存
- (void)commitButtonClickAction{
    
    if (self.isOpenInvioce) {
        
        if ([NSString isEmpty:self.invioceHeader]) {
            
            [self alertMsg:@"请填写发票抬头"];
            
            return;
        }
        
        if ([NSString isEmpty:self.invioceContent]) {
            
            [self alertMsg:@"请选择发票内容"];
            
            return;
        }
        
        if (self.commitButtonClick) {
            
            self.commitButtonClick(self.invioceHeader,self.invioceContent,YES,self.selectIndex);
        }
    }
    else{
        
        if (self.commitButtonClick) {
            
            self.commitButtonClick(nil,nil,NO,self.selectIndex);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back{
        
    [super back];
}

#pragma mark - 选择发票内容
- (void)selectInvioceType{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if(!self.picker || self.picker.infos.count == 0)
    {
        [self.picker removeFromSuperview];
        
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        self.picker = [[UBPicker alloc] initWithSuperView:delegate.window style:UBPickerStyleInvioce];
                
        self.picker.infos = [NSArray arrayWithArray:self.invioceTypeArr];
        
        self.picker.delegate = self;
    }
    
    [self.picker showWithAnimated:YES completion:nil];
}

#pragma mark - 银行卡选择器代理
- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions{
    
    self.invioceContent = [conditions sea_stringForKey:@"content"];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}









@end
