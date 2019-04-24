//
//  ConfirmOrderPageController.m
//  WuMei
//
//  Created by SDA on 15-7-26.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderPageController.h"
#import "WMPayInfoViewController.h"
#import "WMShippingAddressListViewController.h"
#import "WMShippMethodViewController.h"
#import "WMCouponsListViewController.h"
#import "WMInvioceViewController.h"
#import "WMPartnerListViewController.h"
#import "WMStoreListViewController.h"

#import "XTableCellConfigExDelegate.h"
#import "XTableCellConfigEx.h"
#import "UBPicker.h"
#import "ConfirmOrderBottomView.h"
#import "WMShopCarGoodPromotionViewCell.h"
#import "WMConfirmOrderCustomerTableViewCell.h"

#import "WMShopCarInfo.h"
#import "WMShippingMethodInfo.h"
#import "WMConfirmOrderOperation.h"
#import "WMShopCarOperation.h"
#import "WMShippingOpeartion.h"
#import "WMUserInfo.h"
#import "WMConfirmOrderInfo.h"
#import "WMAddressInfo.h"
#import "WMUserOperation.h"
#import "WMDoPaymemtClient.h"
#import "WMCouponsInfo.h"
#import "WMTaxSettingInfo.h"
#import "WMPayMethodModel.h"
#import "WMPartnerInfo.h"
#import "WMLocationManager.h"
#import "WMStoreListInfo.h"
#import "WMStoreOperation.h"

@interface ConfirmOrderPageController ()<WMCouponsListViewControllerDelegate,SeaHttpRequestDelegate,UBPickerDelegate,UIAlertViewDelegate,SeaMenuBarDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**配送方式选择
 */
@property (strong,nonatomic) WMShippMethodViewController *shippingMethodController;
/**配送方式导航控制
 */
@property (strong,nonatomic) SeaNavigationController *shippingNavgation;
/**优惠券选择
 */
@property (strong,nonatomic) WMCouponsListViewController *couponListController;
/**发票
 */
@property (strong,nonatomic) WMInvioceViewController *invioceController;
/**门店列表
 */
@property (strong,nonatomic) WMStoreListViewController *storeListController;
/**选择器
 */
@property (strong,nonatomic) UBPicker *picker;
//填写完所有的信息，如地址、配送方式、发票、优惠券等信息时，如果此时开启代客下单，需要把地址信息重置、配送方式重置
/**菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *menuBar;
/**遮挡视图
 */
@property (strong,nonatomic) UIView *showView;

@end

@implementation ConfirmOrderPageController

#pragma mark - 控制器的生命周期
- (instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if(self){
        
        self.isChangeAddr = YES;
        
        self.backItem = YES;
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
        self.showView.backgroundColor = [UIColor clearColor];
        
        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
        
        self.title = @"确认订单";
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[WMLocationManager sharedInstance] startLocation];
    
    [self configureHeaderView];
    
    [self configureTableView];
    
    [self configureBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressDidClickOperation:) name:WMShippingAddressOperaionDidFinishNotification object:nil];
    
    [self updateTotalMoney];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.isReceiveAddrNotification) {
        
        if (self.orderInfo.orderDefaultShipping) {
            
            self.orderInfo.orderDefaultShipping = nil;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionShippingMethod] withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.orderInfo.orderDefaultAddr) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您变更了您的地址信息，请重新选择配送方式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alertView show];
            }
        }
        
        self.isChangeAddr = YES;
        
        self.isReceiveAddrNotification = NO;
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 键盘

- (void)keyboardWillHide:(NSNotification *)notification
{
    [super keyboardWillHide:notification];
    
    [self.showView removeFromSuperview];

}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [super keyboardWillShow:notification];
    
    [self.view addSubview:self.showView];
}

- (void)tapShowView{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - 配置表格视图
- (void)configureTableView{
    
    [super initialization];
    
    [self cellConfigure];
    
    self.tableView.frame = CGRectMake(0, _SeaMenuBarHeight_, _width_, self.contentHeight - ConfirmOrderBottomViewHeight - _SeaMenuBarHeight_ - (isIPhoneX ? 35.0 : 0.0));
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
}

- (void)configureHeaderView {
    
    self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:self.orderInfo.isStoreAuto ? @[@"快递配送",@"上门自提"] : @[@"快递配送"] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    
    self.menuBar.delegate = self;
    
    [self.view addSubview:self.menuBar];
}

#pragma mark - 配置底部视图
- (void)configureBottomView
{
    WeakSelf(self);
    
    _bottomView = [[ConfirmOrderBottomView alloc] initWithOrderPrice:_orderInfo.orderTotal frame:CGRectMake(0, self.tableView.bottom, _width_, ConfirmOrderBottomViewHeight)];
    
    [_bottomView setCreateOrderButtonClick:^(UIButton *button) {
        
        if (!weakSelf.orderInfo.needStoreAuto && weakSelf.orderInfo.orderDefaultAddr == nil) {
            
            [weakSelf singleActionAlertController:@"尚未填写收货信息哦,请前往页面顶部填写"];
            
            return;
        }
        
        if (!weakSelf.orderInfo.orderDefaultShipping) {
            
            [weakSelf singleActionAlertController:@"请先选择配送方式"];
            
            return;
        }
        
        if (weakSelf.orderInfo.canShippingTime && [NSString isEmpty:weakSelf.orderInfo.methodTime]) {
            
            [weakSelf singleActionAlertController:@"请选择配送时间"];
            
            return;
        }
        
        if (weakSelf.orderInfo.needStoreAuto) {
            
            if (weakSelf.orderInfo.selectStoreInfo == nil) {
                
                [weakSelf singleActionAlertController:@"请选择自提门店"];
                
                return;
            }
            
            if ([NSString isEmpty:weakSelf.orderInfo.selfStoreContactName] || [NSString isEmpty:weakSelf.orderInfo.selfStoreContactMobile]) {
                
                [weakSelf singleActionAlertController:@"请完善自提信息"];

                return;
            }
            
            if (![weakSelf.orderInfo.selfStoreContactMobile isMobileNumber]) {
                
                [weakSelf singleActionAlertController:@"请输入有效的手机号码"];
                
                return;
            }
        }
        
        [weakSelf createOrder];
    }];
    
    [self.view addSubview:_bottomView];
}

- (void)singleActionAlertController:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - SeaMenuBarDelegate
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index {
    
    self.orderInfo.needStoreAuto = index == 1;
    
    if (self.orderInfo.selectStoreInfo == nil) {
        
        [self getStoreListRequest];
    }
    
    self.isChangeAddr = YES;
    
    [self.tableView reloadData];
}

#pragma mark - 配置单元格
- (void)cellConfigure{
 
    self.configArr = [WMConfirmOrderOperation returnConfigureArrForOrderDetailWithTable:self.tableView];
}

#pragma mark - 表格视图代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        
    return self.orderInfo.orderGoodInfo.shopCarGoodsArr.count + self.configArr.count - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [WMConfirmOrderOperation returnConfirmOrderRowsOfSection:section confirmOrderInfo:self.orderInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
            
    XTableCellConfigEx *config = [self findConfigCellWithIndexPath:indexPath];
    
    NSString *classNameString = NSStringFromClass(config.className);

    if ([classNameString isEqualToString:@"ConfirmOrderNoAddrViewCell"] || [classNameString isEqualToString:@"ConfirmOrderAddeViewCell"]) {
        
        return [self.orderInfo returnAddrHeight];
    }
    else if ([classNameString isEqualToString:@"ConfirmOrderMoneyInfoViewCell"]){
        
        return [self.orderInfo returnPriceInfoHeight];
    }
    else if ([classNameString isEqualToString:@"WMShopCarGoodPromotionViewCell"]){
        
        NSAttributedString *attrString = [self findModelWithIndexPath:indexPath];
        
        return MAX(WMShopCarGoodPromotionViewCellHeight, [attrString boundsWithConstraintWidth:_width_ - WMShopCarGoodPromotionViewCellExtraFloat].height + 23.0);
    }
    else if ([classNameString isEqualToString:@"WMStoreSelectedViewCell"]){
        
        return MAX(19.0, [self.orderInfo.selectStoreInfo.completeAddress stringSizeWithFont:[UIFont fontWithName:MainFontName size:13.0] contraintWith:_width_ - 76.0].height) + 47.0 + 1.0;
    }
    else{
        
        return config.heightOfCell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XTableCellConfigEx *config = [self findConfigCellWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    if ([cell isKindOfClass:[WMConfirmOrderCustomerTableViewCell class]]) {
        
        WMConfirmOrderCustomerTableViewCell *customerCell = (WMConfirmOrderCustomerTableViewCell *)cell;
        
        [customerCell configureCellWithModel:model];
        
        WeakSelf(self);
        
        [customerCell setSwitchCallBack:^(BOOL isOn) {
            
            weakSelf.orderInfo.needSelectMember = isOn;
            
            weakSelf.orderInfo.orderDefaultShipping = nil;
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:ConfirmOrderSectionAddress] withRowAnimation:UITableViewRowAnimationNone];
            
            [weakSelf updateTotalMoney];
        }];
        
        return customerCell;
    }
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section > self.orderInfo.orderGoodInfo.shopCarGoodsArr.count) {
        
        section = section - self.orderInfo.orderGoodInfo.shopCarGoodsArr.count + 1;

        if (section == ConfirmOrderSectionPrice) {
            
            return 10.0;
        }
        else{
            
            return CGFLOAT_MIN;
        }
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section > self.orderInfo.orderGoodInfo.shopCarGoodsArr.count) {
        
        section = section - self.orderInfo.orderGoodInfo.shopCarGoodsArr.count + 1;
        
        if (section == ConfirmOrderSectionInvioce) {
            
            return self.orderInfo.orderTaxSettingInfo == nil ? CGFLOAT_MIN : 10.0;
        }
        else if (section == ConfirmOrderSectionPoint){
            
            if (self.orderInfo.orderPointSettingDict) {
                
                NSInteger canUseCount = [[self.orderInfo.orderPointSettingDict sea_stringForKey:@"max_discount_value_point"] integerValue];
                
                return canUseCount == 0 ? CGFLOAT_MIN : 10.0;
            }
            else{
                
                return CGFLOAT_MIN;
            }
        }
        else if (section == ConfirmOrderSectionCoupon){
            
            if (self.orderInfo.isPointOrder) {
                
                return CGFLOAT_MIN;
            }
            
            return self.orderInfo.isPrepareOrder ? CGFLOAT_MIN : 10.0;
        }
    }
    else if (section == ConfirmOrderSectionCustomer){
    
        return self.orderInfo.isPrepareOrder ? CGFLOAT_MIN : 10.0;
    }
    
    return 10.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (indexPath.section == ConfirmOrderSectionAddress) {
        
        if (self.orderInfo.needSelectMember) {
            
            if (self.orderInfo.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    [self pushMemberList];
                }
                else if (indexPath.row == 1) {
                    
                    [self pushStoreList];
                }
            }
            else {
                
                if (indexPath.row == 0) {
                    
                    [self pushMemberList];
                }
                else{
                    
                    [self pushAddressList];
                }
            }
        }
        else{
        
            if (self.orderInfo.needStoreAuto) {
                
                if (indexPath.row == 0) {
                    
                    [self pushStoreList];
                }
            }
            else {
                
                [self pushAddressList];
            }
        }
    }
    else if (indexPath.section == self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionShippingMethod) {
        
        if (!_orderInfo.orderDefaultAddr) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请先填写收货地址信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
        else{
            
            if (indexPath.row) {
                
                [self selectShippingMethodTime];
            }
            else{
                
                if (self.isChangeAddr) {
                    
                    [self downLoadShippingInfoArr];
                }
                else{
                    
                    [self.navigationController presentViewController:self.shippingNavgation animated:YES completion:nil];
                }
            }
        }
    }
    else if (indexPath.section == self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionCoupon){
        
        [self pushCouponListVC];
    }
    else if (indexPath.section == self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionInvioce){
        
        if (!self.invioceController) {
            
            WeakSelf(self);
            
            self.invioceController = [[WMInvioceViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            self.invioceController.invioceTypeArr = self.orderInfo.orderTaxSettingInfo.taxContentsArr;
            
            [self.invioceController setCommitButtonClick:^(NSString *header, NSString *content, BOOL isOpen,NSInteger selectIndex) {
                
                if (isOpen) {
                    
                    weakSelf.orderInfo.orderIsOpenInvioce = YES;
                    
                    weakSelf.orderInfo.orderInvioceContent = content;
                    
                    weakSelf.orderInfo.orderInvioceHeader = header;
                    
                    weakSelf.orderInfo.orderInvioceTypeDict = [weakSelf.orderInfo.orderTaxSettingInfo.taxTypesArr objectAtIndex:selectIndex];
                }
                else{
                    
                    weakSelf.orderInfo.orderIsOpenInvioce = NO;
                }
                
                [weakSelf updateTotalMoney];
                
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionInvioce] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        [self.navigationController pushViewController:self.invioceController animated:YES];
    }
}

- (void)pushAddressList{

    if (self.orderInfo.needSelectMember && self.orderInfo.selectMemberID == nil) {
        
        [self alertMsg:@"请选择会员"];
        
        return;
    }
    
    WMShippingAddressListViewController *addresListContrller = [[WMShippingAddressListViewController alloc] init];
    
    addresListContrller.wantSelectInfo = YES;
    
    addresListContrller.memberID = self.orderInfo.needSelectMember ? self.orderInfo.selectMemberID : [[WMUserInfo sharedUserInfo] userId];
    
    addresListContrller.selectedAddrInfo = [self.orderInfo.orderDefaultAddr createInfo];
    
    [self.navigationController pushViewController:addresListContrller animated:YES];
}

- (void)pushStoreList {
    
    if (!self.storeListController) {
        
        self.storeListController = [[WMStoreListViewController alloc] initWithStyle:UITableViewStyleGrouped];
     
        WeakSelf(self);
        
        [self.storeListController setSelectStoreAddrCallBack:^(WMStoreListInfo *info) {
            
            weakSelf.orderInfo.selectStoreInfo = info;
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.orderInfo.needSelectMember ? 1 : 0 inSection:ConfirmOrderSectionAddress]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    [self.navigationController pushViewController:self.storeListController animated:YES];
}

- (void)pushMemberList {
    
    WMPartnerListViewController *partentListController = [WMPartnerListViewController new];
    
    WeakSelf(self);
    
    [partentListController setSelectPartnerHandler:^(WMPartnerInfo *info) {
        
        weakSelf.orderInfo.selectMemberName = info.userInfo.name;
        
        weakSelf.orderInfo.selectMemberID = info.userInfo.userId;
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:ConfirmOrderSectionAddress]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.navigationController pushViewController:partentListController animated:YES];
}

#pragma mark - 积分使用的回调
- (void)usePointWithIsUse:(BOOL)isUsePoint{
    
    self.orderInfo.isUsePoint = isUsePoint;
    
    [self updateTotalMoney];
}

- (void)usePointRequest{
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMUsePointIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation returnUsePointParamWithPointSettingDict:self.orderInfo.orderPointSettingDict]];
}

#pragma mark - 网络请求回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    [self alertMsg:@"网络错误，请稍候再试"];
    
    if ([request.identifier isEqualToString:WMUsePointIdentifier]) {
        
        self.orderInfo.isUsePoint = NO;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionPoint] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMUpdateTotalMoenyIden]){
        
        NSDictionary *priceDict = [WMConfirmOrderOperation returnOrderTotalMoneyWithData:data];
        
        if (priceDict) {
            
            [_orderInfo changeOrderPriceWithDict:priceDict];
            
            [_bottomView changePrice:_orderInfo.orderTotal];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionShippingMethod] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionPrice] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if ([request.identifier isEqualToString:WMGetShippingMethodIdentifier]){
        
        NSArray *infoArr = [WMShippingOpeartion returnShippingMethodResultWithData:data];
        
        if (infoArr) {
            
            WeakSelf(self);
            
            self.isChangeAddr = NO;
            
            if (!self.shippingMethodController) {
                
                self.shippingMethodController = [[WMShippMethodViewController alloc] init];
                
                self.shippingMethodController.p_delegate = [[SeaPartialPresentTransitionDelegate alloc] init];
                
                [self.shippingMethodController setSelectShippingCallBack:^(WMShippingMethodInfo *shippingInfo,NSString *currency,WMPayMethodModel *payMethodModel) {
                                        
                    weakSelf.orderInfo.orderPayModel = payMethodModel;
                    
                    weakSelf.orderInfo.orderDefaultShipping = shippingInfo;
                    
                    weakSelf.orderInfo.orderCurrentCurrency = currency;
                    
                    [weakSelf updateTotalMoney];
                }];
            }
            
            self.shippingMethodController.shippingMethodArr = infoArr;
            
            [self.shippingMethodController.tableView reloadData];
            
            if (!self.shippingNavgation) {
                
                self.shippingNavgation = [[SeaNavigationController alloc] initWithRootViewController:self.shippingMethodController];
                
                self.shippingNavgation.view.frame = CGRectMake(0, 0, _width_, _height_ - 200.0);
                
                self.shippingNavgation.transitioningDelegate = self.shippingMethodController.p_delegate;
            }
            
            [self.navigationController presentViewController:self.shippingNavgation animated:YES completion:nil];
        }
        else{
            
            [self alertMsg:@"获取配送方式失败"];
        }
    }
    else if ([request.identifier isEqualToString:WMUsePointIdentifier]){
        
        if ([WMConfirmOrderOperation returnUsePointResultWithData:data]) {
            
            self.orderInfo.isUsePoint = YES;
            
            [self updateTotalMoney];
        }
        else{
            
            self.orderInfo.isUsePoint = NO;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionPoint] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if ([request.identifier isEqualToString:WMOrderCreateIdentifier]){
        
        NSDictionary *orderCreateDict = [WMConfirmOrderOperation returnOrderCreateResultWithData:data];
        
        if (orderCreateDict) {
            
            if ([self.isFastBuy isEqualToString:@"false"]) {
                
                NSInteger quantity = [self.orderInfo.orderGoodInfo returnCurrentShopCarQuantity];
                
                WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
                
                [WMShopCarOperation updateShopCarNumberQuantity:userInfo.shopcartCount - quantity needChange:YES];
            }
            
            NSMutableArray *controllers = [NSMutableArray new];
            
            for (UIViewController *controlelr in self.navigationController.viewControllers) {
                
                if (![controlelr isKindOfClass:[ConfirmOrderPageController class]]) {
                    
                    [controllers addObject:controlelr];
                }
            }
            
            self.orderInfo.orderID = [orderCreateDict sea_stringForKey:@"order_id"];
            
            WMPayInfoViewController *payInfoController = [[WMPayInfoViewController alloc] init];
            
            payInfoController.isPrepare = self.orderInfo.isPrepareOrder;
            
            payInfoController.isCommisionOrder = self.orderInfo.needSelectMember;
            
            payInfoController.orderID = self.orderInfo.orderID;
            
            payInfoController.canBack = NO;
            
            [controllers addObject:payInfoController];
                        
            [self.navigationController setViewControllers:controllers animated:YES];
        }
    }
    else if ([request.identifier isEqualToString:WMStoreListIdentifier]) {
        
        NSArray *storeInfosArr = [WMStoreOperation parseStoreAddressListWithData:data totalSize:0];
        
        if (storeInfosArr != nil && storeInfosArr.count != 0) {
            
            self.orderInfo.selectStoreInfo = [storeInfosArr firstObject];
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 返回单元格配置类
- (XTableCellConfigEx *)findConfigCellWithIndexPath:(NSIndexPath *)indexPath{
    
    return [WMConfirmOrderOperation returnCellConfigWithIndexPath:indexPath confirmOrderInfo:self.orderInfo cellConfigArr:self.configArr];
}

#pragma mark - 返回模型
- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    return [WMConfirmOrderOperation returnOrderModelWith:indexPath confirmOrderInfo:self.orderInfo controller:self];
}

#pragma mark - 跳转至优惠券
- (void)pushCouponListVC{
    
    if (!_couponListController) {
        
        _couponListController = [WMCouponsListViewController new];
        
        _couponListController.delegate = self;
        
        _couponListController.wantSelectInfo = YES;
        
        _couponListController.isFastBuy = [self.isFastBuy isEqualToString:@"true"] ? self.isFastBuy : nil;
    }
        
    _couponListController.selectedCouponsInfo = _orderInfo.orderSelectCouponInfo;

    [self.navigationController pushViewController:_couponListController animated:YES];
}

#pragma mark - 地址回调
- (void)addressDidClickOperation:(NSNotification *)notifi{
    
    WMShippingAddressInfo *selectInfo = [notifi.userInfo objectForKey:WMShippingAddressOperaionInfo];
    
    WMShippingAddressOperationStyle type = [[notifi.userInfo objectForKey:WMShippingAddressOperationType] integerValue];
    
    WMAddressInfo *addressSelectInfo = [WMAddressInfo createModelWithShipInfo:selectInfo];
    
    if (selectInfo == nil) {
        
        _orderInfo.orderDefaultAddr = nil;
    }
    switch (type)
    {
        case WMShippingAddressOperationDeleted :
        {
            
        }
            break;
        case WMShippingAddressOperationModified :
        {
            if (self.orderInfo.orderDefaultAddr.addressID.integerValue == selectInfo.Id && self.orderInfo.orderDefaultAddr.addressAreaID.integerValue != selectInfo.areaId.integerValue) {
                
                self.isReceiveAddrNotification = YES;

                self.orderInfo.orderDefaultAddr = addressSelectInfo;
            }
        }
            break;
        case WMShippingAddressOperationSelected :
        case WMShippingAddressOperationAdded :
        {
            
            if (self.orderInfo.orderDefaultAddr == nil) {
                                
                self.orderInfo.orderDefaultAddr = addressSelectInfo;
            }
            else{
                
                if (self.orderInfo.orderDefaultAddr.addressAreaID.integerValue != selectInfo.areaId.integerValue) {
                    
                    self.isReceiveAddrNotification = YES;
                }
                
                self.orderInfo.orderDefaultAddr = addressSelectInfo;
            }
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ConfirmOrderSectionAddress] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 优惠券代理
- (void)couponsListViewController:(WMCouponsListViewController *)view didSelectCouponsInfo:(NSDictionary *)info pointDict:(NSDictionary *)pointDict{
    
    NSDictionary *couponFinalDict = [[info arrayForKey:@"coupons"] firstObject];
    
    _orderInfo.orderSelectCouponInfo = [WMCouponsInfo infoFromUseInfoDict:couponFinalDict];
    
    _orderInfo.orderMD5Code = [info sea_stringForKey:@"md5_cart_info"];
    
    _orderInfo.orderPointSettingDict = pointDict;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionCoupon] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionPoint] withRowAnimation:UITableViewRowAnimationNone];

   [self performSelector:@selector(updateTotalMoney) withObject:nil afterDelay:0.8];
}

- (void)couponsListViewController:(WMCouponsListViewController *)view didDselectCouponsInfo:(NSString *)newMd5String pointDict:(NSDictionary *)pointDict{
    
    _orderInfo.orderMD5Code = newMd5String;
    
    _orderInfo.orderSelectCouponInfo = nil;
    
    _orderInfo.orderPointSettingDict = pointDict;
            
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionCoupon] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionPoint] withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSelector:@selector(updateTotalMoney) withObject:nil afterDelay:0.8];
}

#pragma mark - 更新订单金额
- (void)updateTotalMoney
{
    self.request.identifier = WMUpdateTotalMoenyIden;
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation orderUpdateTotalMoneyParamWithModel:_orderInfo isFastBuy:self.isFastBuy]];
}

#pragma mark - 获取门店
- (void)getStoreListRequest {
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMStoreListIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMStoreOperation storeListParamsWithLatitude:[WMLocationManager sharedInstance].coordinate.latitude longitude:[WMLocationManager sharedInstance].coordinate.longitude keyWord:nil page:WMHttpPageIndexStartingValue]];
}

#pragma mark - 获取配送方式
- (void)downLoadShippingInfoArr{
    
    if (self.orderInfo.needStoreAuto && self.orderInfo.selectStoreInfo == nil) {
        
        [self alertMsg:@"请先选择自提门店"];
        
        return;
    }
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    self.request.identifier = WMGetShippingMethodIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMShippingOpeartion returnShippingMethodParamWithAreaID:self.orderInfo.needStoreAuto ? self.orderInfo.selectStoreInfo.areaValueID : self.orderInfo.orderDefaultAddr.addressAreaID isFastBuy:self.isFastBuy isSelfAuto:self.orderInfo.needStoreAuto]];
}

#pragma mark - 选择配送时间/自提时间
- (void)selectShippingMethodTime{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if(!self.picker || self.picker.shippingTimeInfosArr.count == 0)
    {
        [self.picker removeFromSuperview];
        
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        self.picker = [[UBPicker alloc] initWithSuperView:delegate.window style:UBPickerStyleShippingTime];
        
        self.picker.shippingTimeInfosArr = self.orderInfo.shippingTimeInfosArr;
        
        self.picker.delegate = self;
    }
    
    [self.picker showWithAnimated:YES completion:nil];
}

#pragma mark - 选择器代理
- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions{
    
    NSString *type = [conditions sea_stringForKey:@"timeValue"];
    
    self.orderInfo.timeDict = conditions;
    
    if ([type isEqualToString:@"special"]) {
        
        _orderInfo.methodTime = [NSString stringWithFormat:@"%@%@",[conditions sea_stringForKey:@"time"],[conditions sea_stringForKey:@"timeZone"]];
    }
    else{
        
        _orderInfo.methodTime = [NSString stringWithFormat:@"%@%@",[conditions sea_stringForKey:@"timeValue"],[conditions sea_stringForKey:@"timeZone"]];
    }
    
//    _orderInfo.orderDefaultShipping.branchTime = [conditions sea_stringForKey:@"time"];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.orderInfo.orderGoodInfo.shopCarGoodsArr.count - 1 + ConfirmOrderSectionShippingMethod] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self downLoadShippingInfoArr];
}

#pragma mark - 订单创建
- (void)createOrder{
    
    self.request.identifier = WMOrderCreateIdentifier;
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMConfirmOrderOperation orderCreateParamWithModel:self.orderInfo fastBuyType:self.isFastBuy]];
}




@end
