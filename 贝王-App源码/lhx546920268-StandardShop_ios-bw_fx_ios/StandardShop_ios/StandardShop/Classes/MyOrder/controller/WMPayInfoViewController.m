//
//  WMPayInfoViewController.m
//  WestMailDutyFee
//
//  Created by qsit on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPayInfoViewController.h"
#import "WMPayPassWordController.h"
#import "WMTabBarController.h"
#import "WMOrderCenterViewController.h"
#import "WMOrderManagerController.h"
#import "WMShopCarViewController.h"

#import "WMShopCarOperation.h"
#import "WMPayMethodModel.h"
#import "WMUserInfo.h"
#import "UIView+Screen.h"
#import "WMImageInitialization.h"
#import "WMMyOrderOperation.h"
#import "WMConfirmOrderOperation.h"
#import "WMDoPaymemtClient.h"
#import "WMShippingMethodInfo.h"
#import "WMPayMessageInfo.h"
#import "WXApi.h"

#import "WMPayInfoPriceViewCell.h"
#import "ConfirmOrderPayInfoViewCell.h"
#import "WMTradePasswordInputView.h"
#import "WMPayPageBottomView.h"
#import "XTableCellConfigExDelegate.h"
#import "XTableCellConfigEx.h"
#import "WMBindPhoneNumberViewController.h"

@interface WMPayInfoViewController ()<SeaHttpRequestDelegate,UITableViewDataSource,UITableViewDelegate,WMTradePasswordInputViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
/**单元格的配置,装有XTableCellConfigEx
 */
@property (strong,nonatomic) NSArray *configArr;
/**底部视图
 */
@property (strong,nonatomic) WMPayPageBottomView *bottomView;
/**组合支付控制器
 */
@property (strong,nonatomic) WMPayInfoViewController *combinationPayController;
@end

@implementation WMPayInfoViewController

#pragma mark - 初始化
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;
        
        self.isCommisionOrder = NO;
        
        self.canInputPassWordAgain = YES;
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.title = @"订单支付";
    }
    return self;
}
#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.isCombinationPay) {
        
        WMPayMethodModel *combinationPayMethod = [self.payMessageInfo.paymentsArr firstObject];
        
        combinationPayMethod.payIsSelect = YES;
        
        self.combinationPayMethod = combinationPayMethod;
        
        [self combinationSelectPayMethodRequestAppID:combinationPayMethod.payInfoID];
        
        self.lastSelectRow = 0;
    }
    else{
        
        [self getPayInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDoPayCallBack:) name:OrderDoPayCallBackResultNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
        
    if (self.tableView) {
        
        if (self.combinationPayController) {
            
            [self changePayMethodRequestWithNewPayAppID:WMDepositID];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDoPayCallBack:) name:OrderDoPayCallBackResultNotification object:nil];
        }
        else{
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 支付的回调
- (void)orderDoPayCallBack:(NSNotification *)notifi{
    
    NSNumber *resultStatus = [notifi.userInfo objectForKey:OrderDoPayStatusKey];

    NSString *errorMsg = [notifi.userInfo objectForKey:@"errorMsg"];
    
    if (!notifi) {
        
        resultStatus = [NSNumber numberWithInteger:DoPayCallBackTypeCancel];
        
        errorMsg = @"支付取消";
    }
    else{
        
        switch (resultStatus.integerValue) {
            case DoPayCallBackTypeCancel:
                errorMsg = @"支付取消";
                break;
            case DoPayCallBackTypeFail:
                errorMsg = @"支付失败";
                break;
            case DoPayCallBackTypeSuccess:
                errorMsg = @"支付成功";
            default:
                break;
        }
    }
    
    if (self.isOrderPay) {
        
        [self alertMsg:errorMsg];

        if ([errorMsg isEqualToString:@"支付成功"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            
            [self performSelector:@selector(popCenter) withObject:nil afterDelay:0.8];
        }
    }
    else{
        
        NSInteger index = 0;
        
        if (resultStatus.integerValue == DoPayCallBackTypeSuccess) {
            
            index = 2;
            
            [self alertMsg:@"支付成功"];
        }
        else if (resultStatus.integerValue == DoPayCallBackTypeCancel){
            
            index = self.isCombinationPay ? 0 : 1;
            
            [self alertMsg:@"支付取消"];
        }
        else if (resultStatus.integerValue == DoPayCallBackTypeFail){
            
            index = self.isCombinationPay ? 0 : 1;
            
            [self alertMsg:@"支付失败"];
        }
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        
        //if (self.isPrepare && resultStatus.integerValue == DoPayCallBackTypeSuccess) {
        if (self.isPrepare) {

            WMOrderCenterViewController *order = [[WMOrderCenterViewController alloc] init];
            
            order.hidesBottomBarWhenPushed = YES;
            
            order.isSinglePrepare = YES;
            
            if (self.isCombinationPay) {
                
                [viewControllers removeLastObject];
            }
            
            [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:order];
            
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
        else{
            
            WMOrderManagerController *orderManagerController = [[WMOrderManagerController alloc] init];
            
            orderManagerController.seaMenuBarIndex = index;
            
            orderManagerController.hidesBottomBarWhenPushed = YES;
            
            orderManagerController.segementIndex = self.isCommisionOrder ? 1 : 0;
            
            if (self.isCombinationPay) {
                
                [viewControllers removeLastObject];
            }
            
            [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:orderManagerController];
            
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
}

- (void)popCenter{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[WMOrderCenterViewController class]]) {
            
            WMOrderCenterViewController *orderCenterController = (WMOrderCenterViewController *)controller;
            
            [orderCenterController.orderTypeMenuBar setSelectedIndex:2];
            
            [orderCenterController menuBar:orderCenterController.orderTypeMenuBar didSelectItemAtIndex:2];
            
            break;
        }
    }
        
    if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[WMShopCarViewController class]]) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
        return;
    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject] animated:YES];
}

#pragma mark - 网络请求
- (void)getPayInfo{
    
    self.request.identifier = WMGetPayInfoMethodIdentifier;
    
    self.requesting = YES;
    
    self.loading = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation getOrderPayInfoWithOrderID:self.orderID]];
}

- (void)combinationSelectPayMethodRequestAppID:(NSString *)appID{
    
    self.request.identifier = WMCombinationPayChangePayMethodIdentifer;
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnCombinationPayChangePayMethodParamWithPayAppID:appID currencyMoney:self.payMessageInfo.userDepositInfo.firstCombinationMoeny depositMoney:self.payMessageInfo.userDepositInfo.depositMoeny]];
}

#pragma mark - 网络请求的回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    [self dismissNetWorkActivity];
    
    if ([request.identifier isEqualToString:WMGetPayInfoMethodIdentifier]) {
        
        [self failToLoadData];
    }
    else {
        
        [self alertMsg:@"网络错误，请重试"];
    }
}
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    [self dismissNetWorkActivity];
    
    if ([request.identifier isEqualToString:WMGetPayInfoMethodIdentifier]) {
        
        id info = [WMConfirmOrderOperation returnPayMessageInfoWithData:data];
        
        if (info) {
            
            if ([info isKindOfClass:[WMPayMessageInfo class]]) {
                
                _payMessageInfo = info;
                
                if (!self.tableView) {
                    
                    [self configureTableView];
                    
                    [self configureBottomView];
                    
                    [self configureCellConfig];
                }
                
                for (WMPayMethodModel *payViewModel in _payMessageInfo.paymentsArr) {
                    
                    if (payViewModel.payIsSelect) {
                        
                        _lastSelectRow = [_payMessageInfo.paymentsArr indexOfObject:payViewModel];
                        
                        break;
                    }
                }
                
                [self.tableView reloadData];
            }
            else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(DoPayCallBackTypeSuccess),@"msg":@"支付成功"}];
            }
        }
    }
    else if ([request.identifier isEqualToString:WMSelectPayMethodIdentifier]){
        
        WMPayMessageInfo *info = [WMConfirmOrderOperation returnPayMessageInfoWithData:data];
        
        if (info) {
                
            self.payMessageInfo = info;
            
            [self.bottomView updateButtonTitleStatusWithTitle:self.payMessageInfo.payButtonTitle isCombinationPay:self.payMessageInfo.canCombinationPay];
            
            [self.tableView reloadData];
            
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else if ([request.identifier isEqualToString:WMCallDoPayMentIdentifier]){
        
        NSDictionary *payResultDict = [WMConfirmOrderOperation returnCallDoPaymentResultWithData:data];
        
        if (payResultDict) {
            
            if ([NSString isEmpty:[payResultDict sea_stringForKey:@"code"]]) {
                
                if ([self.payMessageInfo.selectPayID isEqualToString:WMUnionPayID]) {
                    
                    WMUnionPayClient *unionPayClient = [[WMUnionPayClient alloc] init];
                    
                    unionPayClient.controller = self;
                    
                    [unionPayClient callClientToPayOrderWithPayMemtDict:payResultDict];
                }
                else{
                    
                    WMDoPaymemtClient *paymemtClient = [[WMDoPaymemtClient alloc] initWithPaymemtDict:payResultDict payAppID:self.isCombinationPay ? self.combinationPayMethod.payInfoID : self.payMessageInfo.selectPayID];
                    
                    [paymemtClient callClientToPay];
                }
            }
            else{
                
                NSString *code = [payResultDict sea_stringForKey:@"code"];
                
                NSString *msg = [payResultDict sea_stringForKey:@"msg"];
                
                if ([code isEqualToString:@"pay_password_error"]) {
                    
                    NSNumber *limit = [[payResultDict dictionaryForKey:WMHttpData] numberForKey:@"limit"];
                                        
                    if (limit.integerValue != 0) {
                        
                        self.canInputPassWordAgain = YES;
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"忘记密码",@"再次输入", nil];
                        
                        alertView.tag = 1002;
                        
                        [alertView show];
                    }
                    else{
                        
                        self.canInputPassWordAgain = NO;
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"忘记密码", @"取消",nil];
                        
                        alertView.tag = 1003;
                        
                        [alertView show];
                    }
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    [alertView show];
                }
            }
        }
    }
    else if ([request.identifier isEqualToString:WMCombinationPayChangePayMethodIdentifer]){
        
        NSDictionary *newPriceDict = [WMConfirmOrderOperation returnCombinationPayResultWithData:data];
        
        if (newPriceDict) {
            
            if (!self.tableView) {
                
                [self configureTableView];
                
                [self configureBottomView];
                
                [self configureCellConfig];
            }
            
            self.payMessageInfo.userDepositInfo.formatCombinationMoney = [newPriceDict sea_stringForKey:@"cur_money"];
            
            self.payMessageInfo.userDepositInfo.combinationMoney = [newPriceDict sea_stringForKey:@"cur_money_val"];
            
            self.payMessageInfo.userDepositInfo.formatDepostiMoney = [newPriceDict sea_stringForKey:@"deposit_money"];

            self.payMessageInfo.userDepositInfo.depositMoeny = [newPriceDict sea_stringForKey:@"deposit_money_value"];
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 网络请求指示图去掉
- (void)dismissNetWorkActivity{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
}

#pragma mark - 网络重载
- (void)reloadDataFromNetwork{
    
    [self getPayInfo];
}

#pragma mark - 配置表格视图
- (void)configureTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
        
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - 配置单元格
- (void)configureCellConfig{
    
    XTableCellConfigEx *priceConfig = [XTableCellConfigEx cellConfigWithClassName:[WMPayInfoPriceViewCell class] heightOfCell:WMPayInfoPriceViewCellHeight tableView:_tableView isNib:YES];
    
    XTableCellConfigEx *payInfoConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderPayInfoViewCell class] heightOfCell:kConfirmOrderPayInfoViewCellHeight tableView:_tableView isNib:YES];
    
    _configArr = @[priceConfig,payInfoConfig];
}

#pragma mark - 返回数据模型和单元配置

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (id)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    return [_configArr objectAtIndex:indexPath.section];
}
- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {
        
        WMPayMethodModel *payMethodModel = [_payMessageInfo.paymentsArr objectAtIndex:indexPath.row];
        
        return [payMethodModel.payInfoID isEqualToString:WMDepositID] ? @{@"depositMoney":_payMessageInfo.userDepositInfo.formatDepostiMoney,@"model":payMethodModel} : payMethodModel;
    }
    else{
            
        NSString *infoString;
        
        if (self.isCombinationPay) {
            
            infoString = indexPath.row ? _payMessageInfo.userDepositInfo.formatCombinationMoney : _payMessageInfo.userDepositInfo.formatDepostiMoney;
        }
        else{
            
            infoString = indexPath.row ? _payMessageInfo.formatTotalMoney : self.orderID;
        }
        
        return @{@"content":infoString,@"is_orderID":@(indexPath.row),@"isCombination":@(self.isCombinationPay)};
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    return section ? _payMessageInfo.paymentsArr.count : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    return config.heightOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section) {
        
        return 15.0;
    }
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {
        
        [self selectPayMethod:indexPath tableView:tableView];
    }
}
#pragma mark - 切换支付方式
- (void)selectPayMethod:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    if (self.lastSelectRow == indexPath.row) {
        
        return;
    }
    else{
        
        [self selectPayMethod:tableView indexPath:indexPath iamge:[WMImageInitialization tickingIcon] isSelect:YES didSelect:YES];
        
        [self selectPayMethod:tableView indexPath:[NSIndexPath indexPathForRow:self.lastSelectRow inSection:indexPath.section] iamge:[WMImageInitialization untickIcon] isSelect:NO didSelect:NO];
        
        self.lastSelectRow = indexPath.row;
    }
}

- (void)selectPayMethod:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath iamge:(UIImage *)image isSelect:(BOOL)isSelect didSelect:(BOOL)didSelect{
    
    WMPayMethodModel *infoModel = _payMessageInfo.paymentsArr[indexPath.row];
    
    ConfirmOrderPayInfoViewCell *cell = (ConfirmOrderPayInfoViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell.orderPaySelect setBackgroundImage:image forState:UIControlStateDisabled];
    
    infoModel.payIsSelect = isSelect;
    
    if (didSelect) {
        
        if (self.isCombinationPay) {
            
            [self combinationSelectPayMethodRequestAppID:infoModel.payInfoID];
            
            self.combinationPayMethod = infoModel;
        }
        else{
            
            [self changePayMethodRequestWithNewPayAppID:infoModel.payInfoID];
        }
    }
}

#pragma mark - WMTradePasswordInputView delegate
- (void)tradePasswordInputView:(WMTradePasswordInputView *)view didFinishInputPasswd:(NSString *)passwd
{
    [self callDoPayMemtWithPayPassWord:passwd];
}

#pragma mark - 调用支付
- (void)callDoPayMemtWithPayPassWord:(NSString *)payPassWord{
    
    if (self.combinationPayController) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.combinationPayController name:OrderDoPayCallBackResultNotification object:nil];
    }
        
    self.request.identifier = WMCallDoPayMentIdentifier;
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
        
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnCallDoPaymentParamOrderID:self.orderID totalMoney:self.isCombinationPay ? self.payMessageInfo.userDepositInfo.depositMoeny : self.payMessageInfo.totalMoney payAppID:self.payMessageInfo.selectPayID isCombinationPay:self.isCombinationPay combinationPayMoney:self.payMessageInfo.userDepositInfo.combinationMoney combinationPayMethod:self.combinationPayMethod.payInfoID payPassWord:payPassWord]];
}

#pragma mark - 底部视图
- (void)configureBottomView{
    
    WeakSelf(self);
    
    _bottomView = [[WMPayPageBottomView alloc] initWithFrame:CGRectMake(0, 0, _width_, WMLongButtonHeight + WMBottomTopMargin * 2) titleString:_payMessageInfo.payButtonTitle isCombinationPay:self.payMessageInfo.canCombinationPay];
    
    [_bottomView setPayButtonClick:^{
        
        [weakSelf nextStepButtonClick];
    }];
    
    self.tableView .tableFooterView = _bottomView;
}

- (void)nextStepButtonClick{
    
    if ([self.payMessageInfo.selectPayID isEqualToString:WMDepositID]) {
        
        if (self.payMessageInfo.canCombinationPay) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前预存款不足，是否使用组合支付" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"使用组合支付",nil];
            
            alertView.tag = 1001;
            
            [alertView show];
            
            return;
        }
        
        if ([[WMUserInfo sharedUserInfo] has_pay_password]) {
            
            if (self.canInputPassWordAgain) {
                
                [self showTradePasswordInputView];
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您输入支付密码的错误次数超过限制次数，请重设支付密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"忘记密码", @"取消",nil];
                
                alertView.tag = 1003;
                
                [alertView show];
            }
        }
        else{
            
            WeakSelf(self);
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                [self bindPhoneWithClass:^(void){
                    WMPayPassWordController *payPassController = [WMPayPassWordController new];
                    payPassController.isSetPayPass = YES;
                    [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {
                        
                        [weakSelf callDoPayMemtWithPayPassWord:payPass];
                    }];
                    return payPassController;
                }];
                return;
            }
            

            WMPayPassWordController *payPassController = [WMPayPassWordController new];
            
            payPassController.isSetPayPass = YES;
            
            [payPassController setSetPayPassWordSuccess:^(NSString *payPass) {

                [weakSelf callDoPayMemtWithPayPassWord:payPass];
            }];
            
            [self.navigationController pushViewController:payPassController animated:YES];
        }
        
        return;
    }
    else{
        
        if ([self.payMessageInfo.selectPayID isEqualToString:WMWxPayID]) {
            
            if (![WXApi isWXAppInstalled]) {
                
                [[AppDelegate instance] alertMsg:@"没有安装微信客户端，请切换支付方式"];
                
                return;
            }
        }
        
        [self callDoPayMemtWithPayPassWord:nil];
    }
}

//绑定手机号
- (void)bindPhoneWithClass:(UIViewController* (^)(void)) obtainViewController
{
    WeakSelf(self);
    WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
    __weak WMBindPhoneNumberViewController *weakBind = bind;
    bind.shouldBackAfterBindCompletion = NO;
    bind.bindCompletionHandler = ^(void){
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
        
        NSInteger index = [viewControllers indexOfObject:weakBind];
        [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
        [viewControllers addObject:obtainViewController()];
        [weakSelf.navigationController setViewControllers:viewControllers animated:YES];
    };
    [self.navigationController pushViewController:bind animated:YES];
}

#pragma mark - 切换支付方式请求
- (void)changePayMethodRequestWithNewPayAppID:(NSString *)newPayID{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMSelectPayMethodIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnSelectPayMethodWithCurrency:self.payMessageInfo.currency orderID:self.orderID payAppID:newPayID]];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        if (alertView.tag == 1001) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:OrderDoPayCallBackResultNotification object:nil];
            
            if (!self.combinationPayController) {
                
                self.combinationPayController = [WMPayInfoViewController new];
                
                self.combinationPayController.orderID = self.orderID;
                
                self.combinationPayController.isCombinationPay = YES;
                
                self.combinationPayController.canBack = YES;
                
                self.combinationPayController.isPrepare = self.isPrepare;
                
                self.combinationPayController.isOrderPay = self.isOrderPay;
                
                WMPayMessageInfo *newInfo = [WMPayMessageInfo new];
                
                newInfo.userDepositInfo = self.payMessageInfo.userDepositInfo;
                
                newInfo.paymentsArr = self.payMessageInfo.combinationPaymentsArr;
                
                newInfo.orderID = self.payMessageInfo.orderID;
                
                newInfo.totalMoney = self.payMessageInfo.totalMoney;
                
                newInfo.payButtonTitle = @"确认组合支付";
                
                newInfo.currency = self.payMessageInfo.currency;
                
                newInfo.selectPayID = self.payMessageInfo.selectPayID;
                
                self.combinationPayController.payMessageInfo = newInfo;
            }
            
            [self.navigationController pushViewController:self.combinationPayController animated:YES];
        }
        else if (alertView.tag == 1002 || alertView.tag == 1003){
            
            [[UIApplication sharedApplication].keyWindow endEditing:NO];
        }
        else{
            
            if (self.combinationPayController) {
                
                [[NSNotificationCenter defaultCenter] removeObserver:self.combinationPayController name:OrderDoPayCallBackResultNotification object:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(DoPayCallBackTypeFail),@"msg":@"支付取消"}];
        }
    }
    else{
        
        if (alertView.tag == 1002 || alertView.tag == 1003) {
            
            [[UIApplication sharedApplication].keyWindow endEditing:NO];
            
            if([WMUserInfo sharedUserInfo].isSocailLogin && [WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
            {
                [self bindPhoneWithClass:^(void){
                    WMPayPassWordController *payPassController = [WMPayPassWordController new];
                    payPassController.isChangePayPass = NO;
                    payPassController.isSetPayPass = NO;
                    return payPassController;
                }];
                return;
            }
            WMPayPassWordController *payPassController = [WMPayPassWordController new];
            
            payPassController.isChangePayPass = NO;
            
            payPassController.isSetPayPass = NO;
            
            [self.navigationController pushViewController:payPassController animated:YES];
        }
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1002 && buttonIndex) {
        
        [self showTradePasswordInputView];
    }
}

- (void)showTradePasswordInputView{
    
    WMTradePasswordInputView *trade = [[WMTradePasswordInputView alloc] initWithType:0 price:self.isCombinationPay ? self.payMessageInfo.userDepositInfo.depositMoeny : self.payMessageInfo.formatTotalMoney];
    
    trade.delegate = self;
    
    [trade show];
}

- (void)back{
    
    if (self.canBack) {
        
        [super back];
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消支付吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
        
        alertView.tag = 1004;
        
        [alertView show];
    }
}






@end
