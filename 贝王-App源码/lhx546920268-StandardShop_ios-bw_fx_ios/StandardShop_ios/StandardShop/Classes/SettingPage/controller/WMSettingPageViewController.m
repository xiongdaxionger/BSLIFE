//
//  SettingPageViewController.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kTitleKey @"titleKey"
#define kContentKey @"contentKey"

#import "WMSettingPageViewController.h"
#import "WMModifyLoginPasswordViewController.h"
#import "WMPayPassWordController.h"
#import "WMLoginViewController.h"
#import "WMFeedBackPageController.h"
#import "WMAboutMePageController.h"
#import "WMHelpCenterViewController.h"

#import "WMSettingPageCell.h"

#import "XTableCellConfigExDelegate.h"
#import "XTableCellConfigEx.h"
#import "WMUserOperation.h"
#import "WMShopCarOperation.h"
#import "WMUserInfo.h"
#import "WMTabBarController.h"
#import "WMBindPhoneNumberViewController.h"

@interface WMSettingPageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SeaHttpRequestDelegate>
/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
/**标题数组
 */
@property (strong,nonatomic) NSArray *titleArr;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configArr;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**图片缓存数据
 */
@property (copy,nonatomic) NSString *cacheString;
@end

@implementation WMSettingPageViewController

- (instancetype)init{
    
    self = [super init];
    
    if (self) {

        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    WeakSelf(self);
    
    self.backItem = YES;
    
    self.title = @"设置";
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    self.titleArr = [self returnTitlesArr];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    [self configureTableView];
    
    [self cellConfig];
    
    if ([AppDelegate instance].isLogin) {
        
        [self addLogOutButton];
    }
    
    [[SeaImageCacheTool sharedInstance] caculateCacheSizeWithCompletion:^(unsigned long long size) {
        
        weakSelf.cacheString = [SeaImageCacheTool formatBytes:size];
        
        [weakSelf.tableView reloadData];
    }];
}

- (NSArray *)returnTitlesArr{
    
    NSDictionary *changeLogInDict = @{@"type":@(SettingTypeChangeLogIn),@"title":@"修改登录密码"};
    
    NSDictionary *changePayPassDict = @{@"type":@(SettingTypeChangePayPass),@"title":@"修改支付密码"};
    
    NSDictionary *forgetPayPassDict = @{@"type":@(SettingTypeForgetPayPass),@"title":@"忘记支付密码"};
    
    NSDictionary *helpCenterDict = @{@"type":@(SettingTypeHelpCenter),@"title":@"帮助中心"};
    
    NSDictionary *clearCacheDict = @{@"type":@(SettingTypeClearCache),@"title":@"清除缓存"};
    
    NSDictionary *setPayPassDict = @{@"type":@(SettingTypeSetPayPass),@"title":@"设置支付密码"};
    
    NSDictionary *aboutMeDict = @{@"type":@(SettingTypeAboutMe),@"title":@"关于我们"};
    
    if ([AppDelegate instance].isLogin) {
        
        if ([WMUserInfo sharedUserInfo].has_pay_password) {
            
            return @[changeLogInDict,changePayPassDict,forgetPayPassDict,helpCenterDict,aboutMeDict,clearCacheDict];
        }
        else{
            
            return @[changeLogInDict,setPayPassDict,helpCenterDict,aboutMeDict,clearCacheDict];
        }
    }
    else{
        
        return @[helpCenterDict,aboutMeDict,clearCacheDict];
    }
}

#pragma mark - 退出按钮
- (void)addLogOutButton{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, WMLongButtonHeight)];
    
    backView.backgroundColor = [UIColor clearColor];
    
    UIButton *layOutButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, 0, _width_ - 8.0 * 2, WMLongButtonHeight)];
    
    [layOutButton addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [layOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    
    layOutButton.titleLabel.font = WMLongButtonTitleFont;
    
    layOutButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    layOutButton.backgroundColor = WMButtonBackgroundColor;
    
    [layOutButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    [backView addSubview:layOutButton];
    
    self.tableView.tableFooterView = backView;
}

- (void)logOutAction{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
    
    [alert show];
}

#pragma - mark 警告框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (!buttonIndex) {
        
        [self accountLogOut];
    }
}

#pragma mark - 退出登录
- (void)accountLogOut{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMLogoutIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation logoutParams]];
}

#pragma mark - 配置单元格
- (void)cellConfig{
    
    XTableCellConfigEx *customConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSettingPageCell class] heightOfCell:kSettingPageCustomViewHeight tableView:_tableView isNib:YES];
    
    _configArr = @[customConfig];
}

#pragma mark - 配置表格视图
- (void)configureTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight) style:UITableViewStyleGrouped];
    
    _tableView.rowHeight = kSettingPageCustomViewHeight;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10.0);
    
    _tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
}

#pragma mark - 返回模型和配置类
- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_titleArr objectAtIndex:indexPath.row];
    
    NSString *title = [dict sea_stringForKey:@"title"];
    
    SettingType type = [[dict sea_stringForKey:@"type"] integerValue];
    
    if (type == SettingTypeClearCache) {
        
        return @{kTitleKey:title,kContentKey:[NSString isEmpty:self.cacheString] ? @"正在获取" : self.cacheString};
    }

    
    return @{kTitleKey:title,kContentKey:@(type)};
}

- (id)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    return [self.configArr firstObject];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    UITableViewCell *cell1 = (UITableViewCell *)cell;
    
    cell1.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell1;
}

#pragma mark - UITableViewDelegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.titleArr objectAtIndex:indexPath.row];
    
    NSNumber *type = [dict numberForKey:@"type"];
    
    WeakSelf(self);
    
    switch (type.integerValue) {
        case SettingTypeClearCache:
        {
            self.requesting = YES;
            
            self.showNetworkActivity = YES;
            
            [[SeaImageCacheTool sharedInstance] clearCacheImageWithCompletion:^{
                
                weakSelf.requesting = NO;
                
                weakSelf.showNetworkActivity = NO;
                
                weakSelf.cacheString = @"0.0K";
                
                NSInteger refreshRow = 0;
                
                if ([AppDelegate instance].isLogin) {
                    
                    if ([WMUserInfo sharedUserInfo].has_pay_password) {
                        
                        refreshRow = 5;
                    }
                    else{
                        
                        refreshRow = 4;
                    }
                }
                else{
                    
                    refreshRow = 2;
                }
                
                [weakSelf.tableView beginUpdates];
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:refreshRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [weakSelf.tableView endUpdates];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"缓存清除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alert show];
            }];
        }
            break;
        case SettingTypeHelpCenter:
        {
            [self.navigationController pushViewController:[WMHelpCenterViewController new] animated:YES];
        }
            break;
        case SettingTypeChangeLogIn:
        {
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                [self bindPhoneWithClass:nil];
                return;
            }
            [self.navigationController pushViewController:[WMModifyLoginPasswordViewController new] animated:YES];
        }
            break;
        case SettingTypeAboutMe:
        {
            [self.navigationController pushViewController:[WMAboutMePageController new] animated:YES];
        }
            break;
        case SettingTypeSetPayPass:
        {
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                WMPayPassWordController *payPassController = [WMPayPassWordController new];
                payPassController.isSetPayPass = YES;
                payPassController.isChangePayPass = NO;
                [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {
                    
                    weakSelf.titleArr = [weakSelf returnTitlesArr];
                    
                    [weakSelf.tableView reloadData];
                }];
                
                [self bindPhoneWithClass:^(void){
                    return payPassController;
                }];
                return;
            }
            WeakSelf(self);
            
            WMPayPassWordController *payPassController = [WMPayPassWordController new];
            
            payPassController.isSetPayPass = YES;
            
            payPassController.isChangePayPass = NO;
            
            [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {
                
                weakSelf.titleArr = [weakSelf returnTitlesArr];
                
                [weakSelf.tableView reloadData];
            }];
            
            [self.navigationController pushViewController:payPassController animated:YES];
        }
            break;
        case SettingTypeChangePayPass:
        {
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                [self bindPhoneWithClass:^(void){
                    WMPayPassWordController *payPassController = [WMPayPassWordController new];
                    payPassController.isSetPayPass = NO;
                    payPassController.isChangePayPass = YES;
                    
                    return payPassController;
                }];
                return;
            }
            WMPayPassWordController *payPassController = [WMPayPassWordController new];
            
            payPassController.isSetPayPass = NO;
            
            payPassController.isChangePayPass = YES;
            
            [self.navigationController pushViewController:payPassController animated:YES];
        }
            break;
        case SettingTypeForgetPayPass:
        {
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                
                [self bindPhoneWithClass:^(void){
                    WMPayPassWordController *payPassController = [WMPayPassWordController new];
                    payPassController.isSetPayPass = NO;
                    payPassController.isChangePayPass = NO;
                    return payPassController;
                }];
                return;
            }
            WMPayPassWordController *payPassController = [WMPayPassWordController new];
    
            payPassController.isSetPayPass = NO;
            
            payPassController.isChangePayPass = NO;
            
            [self.navigationController pushViewController:payPassController animated:YES];
        }
            break;
        default:
            break;
    }
}

//绑定手机号
- (void)bindPhoneWithClass:(UIViewController* (^)(void)) obtainViewController
{
    WeakSelf(self);
    WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
    __weak WMBindPhoneNumberViewController *weakBind = bind;
    
    if(obtainViewController != nil){
        bind.shouldBackAfterBindCompletion = NO;
        bind.bindCompletionHandler = ^(void){
            UIViewController *viewController = obtainViewController();
            
            if(viewController != nil){
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
                
                NSInteger index = [viewControllers indexOfObject:weakBind];
                [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
                [viewControllers addObject:viewController];
                [weakSelf.navigationController setViewControllers:viewControllers animated:YES];
            }else{
                [weakBind back];
            }
        };
    }
    [self.navigationController pushViewController:bind animated:YES];
}

#pragma mark - 网络回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    [self alertMsg:@"网络错误，请重试"];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMLogoutIdentifier]) {
        
        if ([WMUserOperation logoutResultFromData:data]) {
            
            [WMUserInfo logout];
                                    
            [[NSNotificationCenter defaultCenter] postNotificationName:WMUserDidLogoutNotification object:nil];
            
            [self backToRootViewControllerWithAnimated:NO];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:nil];
            });
        }
    }
}









@end
