//
//  WMWithDrawAccountViewController.m
//  StandardFenXiao
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMWithDrawAccountViewController.h"
#import "WMAddWithDrawAccountViewController.h"
#import "WMWithDrawAccountViewCell.h"
#import "WMWithDrawAccountInfo.h"
#import "WMBalanceOperation.h"
#import "WMUserInfo.h"
#import "WMBindPhoneNumberViewController.h"

@interface WMWithDrawAccountViewController ()<SeaHttpRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**账户数组
 */
@property (strong,nonatomic) NSMutableArray *accountInfos;
/**选中的模型
 */
@property (strong,nonatomic) WMWithDrawAccountInfo *selectInfo;
/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
/**图形验证码
 */
@property (copy,nonatomic) NSString *codeURL;
@end

@implementation WMWithDrawAccountViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"提现账号";
    
    self.backItem = YES;
    
    self.accountInfos = [[NSMutableArray alloc] init];
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self getAccountInfosList];
    
    [self initialization];
    
    [self configureUI];
    
    self.loading = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAccountInfosList) name:@"AddAccountSuccess" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化表格视图
- (void)initialization{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight - (isIPhoneX ? 35.0 : 0.0)) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = WMWithDrawAccountViewCellHeight;
    
   // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 配置UI
- (void)configureUI{
    
    UINib *nib = [UINib nibWithNibName:@"WMWithDrawAccountViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:WMWithDrawAccountViewCellIden];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 44.0)];
    
    footerView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UIButton *addAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, 0, _width_ + _separatorLineWidth_ * 2, footerView.height)];
    
    addAccountButton.backgroundColor = [UIColor whiteColor];
    
    [addAccountButton setTitle:@"添加账号" forState:UIControlStateNormal];
    
    [addAccountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [addAccountButton setImage:[UIImage imageNamed:@"add_button_image"] forState:UIControlStateNormal];
    
    [addAccountButton addTarget:self action:@selector(addAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    addAccountButton.layer.borderColor = _separatorLineColor_.CGColor;
    addAccountButton.layer.borderWidth = _separatorLineWidth_;
    [footerView addSubview:addAccountButton];
    
    self.tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 控件的点击事件
- (void)addAccountAction:(UIButton *)button{
    
    if([WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
    {
        WeakSelf(self);
        WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
        __weak WMBindPhoneNumberViewController *weakBind = bind;
        bind.shouldBackAfterBindCompletion = NO;
        bind.bindCompletionHandler = ^(void){
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
            
            NSInteger index = [viewControllers indexOfObject:weakBind];
            [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
            WMAddWithDrawAccountViewController *add = [[WMAddWithDrawAccountViewController alloc] init];
            add.codeURL = self.codeURL;
            [viewControllers addObject:add];
            [weakSelf.navigationController setViewControllers:viewControllers animated:YES];
        };
        
        return;
    }
    WMAddWithDrawAccountViewController *addAccountController = [[WMAddWithDrawAccountViewController alloc] init];
    
    addAccountController.codeURL = self.codeURL;
    
    [self.navigationController pushViewController:addAccountController animated:YES];
}
#pragma mark - 网络请求
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGetDrawAccountInfoIden]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMDeleteAccountInfoIden]){
        
        [self alertMsg:@"网络不佳，请重试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGetDrawAccountInfoIden]) {
        
        NSDictionary *dict = [WMBalanceOperation returnAccountInfosListResultWithData:data];
        
        if (dict) {
            
            self.accountInfos = [NSMutableArray arrayWithArray:[dict arrayForKey:@"info"]];
            
            self.codeURL = [dict sea_stringForKey:@"code"];
            
            [self.tableView reloadData];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMDeleteAccountInfoIden]){
        
        if ([WMBalanceOperation returnDeleteAccountResultWithData:data]) {
            
            [self alertMsg:@"删除账号成功"];
            
            [self.accountInfos removeObjectAtIndex:_selectIndex.section];
            
            [self.tableView beginUpdates];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:_selectIndex.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView endUpdates];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteAccountSuccess" object:nil userInfo:@{@"accountID":_selectInfo.accountID}];
        }
    }
}

#pragma mark - 表格视图的协议

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _accountInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMWithDrawAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WMWithDrawAccountViewCellIden forIndexPath:indexPath];
    
    WMWithDrawAccountInfo *info = [_accountInfos objectAtIndex:indexPath.section];
    
    [cell confirmWithAccountInfo:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == _accountInfos.count - 1)
    {
        return 15.0;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectInfo = [self.accountInfos objectAtIndex:indexPath.section];
    
    if (self.selectAccountCallBakc) {
        
        NSString *accountInfo;
        
        if (_selectInfo.type == WithDrawAccountTypeBlank) {
            
            accountInfo = [NSString stringWithFormat:@"%@ 尾号%@ %@",_selectInfo.blankName,_selectInfo.lastNumber,_selectInfo.blankCardPerson];
        }
        else{
            
            accountInfo = [NSString stringWithFormat:@"%@ 账号%@ %@",_selectInfo.blankName,_selectInfo.blankNumber,_selectInfo.blankCardPerson];
        }
        
        self.selectAccountCallBakc(accountInfo,_selectInfo.accountID);
    }
    
    [self back];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        
        _selectInfo = [self.accountInfos objectAtIndex:indexPath.section];
        
        _selectIndex = indexPath;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该提现账号吗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
        
        [alert show];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

#pragma mark - 网络请求
- (void)getAccountInfosList{
    
    self.request.identifier = WMGetDrawAccountInfoIden;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnAccountInfosListParam]];
}

- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    
    [self getAccountInfosList];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (!buttonIndex) {
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
        
        self.request.identifier = WMDeleteAccountInfoIden;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation returnDeleteAccountParamWithAccountID:_selectInfo.accountID]];
    }
}

@end
