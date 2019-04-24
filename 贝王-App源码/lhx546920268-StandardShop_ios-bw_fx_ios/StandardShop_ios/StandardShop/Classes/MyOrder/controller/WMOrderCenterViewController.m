//
//  WMOrderCenterViewController.m
//  StandardShop
//
//  Created by mac on 16/7/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderCenterViewController.h"
#import "WMOrderDetailViewController.h"
#import "WMPayInfoViewController.h"
#import "WMLogisticsViewController.h"
#import "WMGoodCommentAddViewController.h"
#import "WMShopCarViewController.h"

#import "WMMyOrderOperation.h"
#import "WMGoodInfo.h"
#import "WMOrderInfo.h"
#import "WMUserInfo.h"

#import "WMOrderIDViewCell.h"
#import "WMOrderGoodViewCell.h"
#import "WMOrderPriceViewCell.h"
#import "WMOrderWaitPayViewCell.h"
#import "WMOrderWaitReceiveViewCell.h"
#import "WMOrderBuyAgainViewCell.h"
#import "WMOrderDeadViewCell.h"
#import "WMPrepareTimeViewCell.h"
#import "XTableCellConfigEx.h"
#import "UBPicker.h"
#import "WMSinceQRCodeView.h"

@interface WMOrderCenterViewController ()<SeaHttpRequestDelegate,UIAlertViewDelegate,UBPickerDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**选择器
 */
@property (strong,nonatomic) UBPicker *picker;
@end

@implementation WMOrderCenterViewController

#pragma mark - 控制器生命周期
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.orderInfosArr  = [[NSMutableArray alloc] init];
                
        self.backItem = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginDropDownRefresh) name:@"refreshTable" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.loading = YES;
        
    if (self.isSinglePrepare) {
        
        [self myOrderNetWorkWithIndex:-1 needRequesting:NO];
        
        self.title = @"预售订单";
    }
    else{
        self.title = @"我的订单";

        [self configureSeaMenuBar];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 配置表格视图
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;
    
    CGFloat margin = self.isSinglePrepare ? CGFLOAT_MIN : _SeaMenuBarHeight_;
    
    self.tableView.frame = CGRectMake(0, margin, _width_, self.contentHeight - margin - (isIPhoneX ? 35.0 : 0.0));
    
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = [NSString stringWithFormat:@"暂无%@订单",[WMMyOrderOperation returnOrderTypeWithIndex:self.orderStatusSelectIndex]];
}

#pragma mark - 配置单元格
- (void)configureCellConfig{
    
    XTableCellConfigEx *orderIDConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderIDViewCell class] heightOfCell:WMOrderIDViewCellHegith tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderGoodConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderGoodViewCell class] heightOfCell:WMOrderGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderPriceConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderPriceViewCell class] heightOfCell:WMOrderPriceViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderWaitPayConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderWaitPayViewCell class] heightOfCell:WMOrderWaitPayViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderWaitReceiveConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderWaitReceiveViewCell class] heightOfCell:WMOrderWaitReceiveViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderBuyAgain = [XTableCellConfigEx cellConfigWithClassName:[WMOrderBuyAgainViewCell class] heightOfCell:WMOrderBuyAgainViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderDead = [XTableCellConfigEx cellConfigWithClassName:[WMOrderDeadViewCell class] heightOfCell:WMOrderDeadViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *prepareTime = [XTableCellConfigEx cellConfigWithClassName:[WMPrepareTimeViewCell class] heightOfCell:WMPrepareTimeViewCellHeight tableView:self.tableView isNib:YES];
    
    _configureArr = @[orderIDConfig,orderGoodConfig,orderPriceConfig,orderWaitPayConfig,orderWaitReceiveConfig,orderBuyAgain,orderDead,prepareTime];
}

#pragma mark - 下拉刷新 & 上拉加载
- (void)beginDropDownRefresh{
    
    self.refreshing = YES;
    
    self.curPage = 1;
    
    if (self.isSinglePrepare) {
        
        [self myOrderNetWorkWithIndex:-1 needRequesting:NO];
    }
    else{
        
        [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:NO];
    }
}

- (void)beginPullUpLoading{
    
    self.curPage ++;
    
    if (self.isSinglePrepare) {
        
        [self myOrderNetWorkWithIndex:-1 needRequesting:NO];
    }
    else{
        
        [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:NO];
    }
}

#pragma mark - 配置菜单栏
- (void)configureSeaMenuBar{
    
    NSArray *titlesArr;
    
    titlesArr = self.isCommisionOrder ? @[@"全部",WMWaitPayTitle,WMWaitSendTitle,WMWaitReceiveTitle] : @[@"全部",WMWaitPayTitle,WMWaitSendTitle,WMWaitReceiveTitle, WMWaitCommentTitle];
    
    SeaMenuBar *menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titlesArr style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    
    menu.delegate = self;
    
    menu.topSeparatorLine.hidden = YES;
    
    menu.callDelegateWhenSetSelectedIndex = NO;
    
    [menu setSelectedIndex:_orderStatusSelectIndex];
    
    self.orderTypeMenuBar = menu;
    
    [self.view addSubview:self.orderTypeMenuBar];
    
    [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:NO];
}

#pragma mark - SeaMenuBarDelegate
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    self.curPage = 1;
    
    self.orderStatusSelectIndex = index;
    
    self.tableView.loadMoreControl.hidden = YES;
    
    self.refreshing = YES;
    
    [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:YES];
}

#pragma mark - 获取我的订单网络请求
- (void)myOrderNetWorkWithIndex:(NSInteger)index needRequesting:(BOOL)isNeed{
    
    self.request.identifier = WMGetOrderListIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnMyOrderParamWithOrderType:index pageIndex:self.curPage memberID:[[WMUserInfo sharedUserInfo] userId] isCommision:self.isCommisionOrder]];
    
    if (isNeed) {
        
        self.requesting = YES;
        
        [self setShowNetworkActivityWithMsg:WMHttpRequestWaiting];
    }
}

#pragma mark - 网络请求的回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMGetOrderListIdentifier]) {
        
        [self failToLoadData];
    }
    else{
        
        [self alertMsg:@"网络错误，请重试"];
    }
    
    self.loadMoreControl.hidden = YES;
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMGetOrderListIdentifier]){
        
        NSDictionary *infoDict = [WMMyOrderOperation returnMyOrderInfoResultWithData:data canComment:YES];
        
        if (infoDict != nil) {
            
            if (!self.tableView) {
                
                [self initialization];
                
                [self configureCellConfig];
            }
            else{
                
                if (!self.loadMore) {
                    
                    self.tableView.contentOffset = CGPointMake(0, 0);
                }
            }
            
            if (self.refreshing) {
                
                [self.orderInfosArr removeAllObjects];
            }
            
            [self.orderInfosArr addObjectsFromArray:[infoDict arrayForKey:@"info"]];
            
            [self.tableView reloadData];
            
            [self endPullUpLoadingWithMoreInfo:self.orderInfosArr.count < [[infoDict numberForKey:@"count"] integerValue]];
            
            [self endDropDownRefreshWithMsg:nil];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMGetOrderCancelReasonIdentifier]){
        
        NSArray *reasonsArr = [WMMyOrderOperation returnCancelOrderReasonArrsWithData:data];
        
        if (reasonsArr) {
            
            self.cancelOrderReasonsArr = reasonsArr;
            
            [self selectCancelReasonType];
        }
    }
    else if ([request.identifier isEqualToString:WMCancelOrderIdentifier] || [request.identifier isEqualToString:WMConfirmGetGoodIdentifier] || [request.identifier isEqualToString:WMDeleteOrderIdentifier]){
        
        [self orderActionNeedRefresh:YES data:data];
    }
    else if ([request.identifier isEqualToString:WMGoodBuyAgainIdentifier]){
        
        [self orderActionNeedRefresh:NO data:data];
        
        [self performSelector:@selector(buyAgainPush) withObject:nil afterDelay:0.8];
    }
}

- (void)buyAgainPush{
    
    WMShopCarViewController *shopCarController = [WMShopCarViewController new];
    
    shopCarController.backItem = YES;
    
    [SeaPresentTransitionDelegate pushViewController:shopCarController useNavigationBar:YES parentedViewConttroller:self];
}

#pragma mark - 网络重载
- (void)reloadDataFromNetwork{
    
    [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:NO];
}

#pragma mark - 返回配置累类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.orderInfosArr.count) {
        
        return nil;
    }
    
    WMOrderInfo *orderInfo = [self.orderInfosArr objectAtIndex:indexPath.section];
    
    return [WMMyOrderOperation returnConfigureWithModel:orderInfo configArr:self.configureArr indexPath:indexPath];
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.orderInfosArr.count) {
        
        return nil;
    }
    
    WMOrderInfo *orderInfo = [self.orderInfosArr objectAtIndex:indexPath.section];
    
    if(indexPath.row == 0 || indexPath.row == orderInfo.orderGoodsArr.count + 1){
        
        return orderInfo;
    }
    else if (indexPath.row >= 1 && indexPath.row <= orderInfo.orderGoodsArr.count){
        
        return [orderInfo.orderGoodsArr objectAtIndex:indexPath.row - 1];
    }
    else{
        
        return @{kControllerKey:self,kModelKey:orderInfo};
    }
}

#pragma mark - 表格视图的协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderInfosArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [WMMyOrderOperation returnOrderSectionRowNumberWith:[self.orderInfosArr objectAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    return config.heightOfCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    if ([cell isKindOfClass:[WMOrderGoodViewCell class]]) {
        
        WMOrderGoodViewCell *goodCell = (WMOrderGoodViewCell *)cell;
        
        WeakSelf(self);
        
        [goodCell setCommentGood:^(UITableViewCell *cell) {
           
            weakSelf.selectCellIndexPath = [weakSelf.tableView indexPathForCell:cell];
            
            WMOrderInfo *orderInfo = [weakSelf.orderInfosArr objectAtIndex:indexPath.section];

            WMOrderGoodInfo *orderGoodInfo = [orderInfo.orderGoodsArr objectAtIndex:indexPath.row - 1];
            
            WMGoodInfo *goodInfo = [WMGoodInfo new];
            
            goodInfo.goodId = orderGoodInfo.goodID;
            
            goodInfo.productId = orderGoodInfo.productID;
            
            goodInfo.imageURL = orderGoodInfo.image;
            
            WMGoodCommentAddViewController *comment = [WMGoodCommentAddViewController new];
            
            comment.orderId = orderInfo.orderID;
            
            comment.goodInfo = goodInfo;
            
            [comment setCommentDidFinsihHandler:^{
                
                orderGoodInfo.canGoodComment = NO;
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.selectCellIndexPath] withRowAnimation:YES];
            }];
            
            [weakSelf.navigationController pushViewController:comment animated:YES];
        }];
    }
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMOrderInfo *orderInfo = [self.orderInfosArr objectAtIndex:indexPath.section];
    
    WMOrderDetailViewController *orderDetailController = [[WMOrderDetailViewController alloc] init];
    
    orderDetailController.orderID = orderInfo.orderID;
    
    orderDetailController.cancelOrderReasonsArr = self.cancelOrderReasonsArr;
            
    [self.navigationController pushViewController:orderDetailController animated:YES];
}

#pragma mark - 订单操作/删除/查看物流/确认收货等
- (void)confirmOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    if (info.actionType == MainButtonActionTypeConfirmReceive){
        
        self.selectCellIndexPath = [self.tableView indexPathForCell:cell];
        
        self.request.identifier = WMConfirmGetGoodIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnConfirmOrderParamWithOrderID:info.orderID]];
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
    }
    else{
        
        [self alertMsg:info.mainButtonTitle];
    }
}

- (void)deleteOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    self.selectCellIndexPath = [self.tableView indexPathForCell:cell];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该订单吗?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
    
    [alertView show];
}

- (void)buyAgainWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    self.selectCellIndexPath = [self.tableView indexPathForCell:cell];

    self.request.identifier = WMGoodBuyAgainIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnBuyAgainParamWithOrderID:info.orderID]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

- (void)showSinceQRCodeWithSinceCode:(NSString *)code {
    
    WMSinceQRCodeView *qrcodeView = [WMSinceQRCodeView new];
    
    qrcodeView.qrcodeImageView.image = [UIImage qrCodeImageWithString:code correctionLevel:SeaQRCodeImageCorrectionLevelPercent30 size:CGSizeMake(220.0, 220.0) contentColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] logo:nil];
    
    [qrcodeView show];
}

- (void)cancelOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    self.selectCellIndexPath = [self.tableView indexPathForCell:cell];
    
    if (self.cancelOrderReasonsArr) {
        
        [self selectCancelReasonType];
    }
    else{
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
        
        self.request.identifier = WMGetOrderCancelReasonIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnCancelOrderReasonParam]];
    }
}

- (void)payOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    if (info.actionType == MainButtonActionTypePay) {
        
        self.selectCellIndexPath = [self.tableView indexPathForCell:cell];
        
        WMPayInfoViewController *payInfoController = [WMPayInfoViewController new];
        
        payInfoController.orderID = info.orderID;
        
        payInfoController.isOrderPay = YES;
        
        payInfoController.canBack = YES;
        
        [self.navigationController pushViewController:payInfoController animated:YES];
    }
    else if (info.actionType == MainButtonActionTypeWaitPayCallBack || info.actionType == MainButtonActionTypeOverTime){
        
        [self alertMsg:info.mainButtonTitle];
    }
}

- (void)checkOrderExpressWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell{
    
    self.selectCellIndexPath = [self.tableView indexPathForCell:cell];
    
    WMLogisticsViewController *logisticsController = [WMLogisticsViewController new];
    
    logisticsController.deliveryID = info.orderID;
    
    logisticsController.isOrder = YES;
    
    logisticsController.title = @"发货物流详情";
    
    [self.navigationController pushViewController:logisticsController animated:YES];
}

#pragma mark - 选择退款理由
- (void)selectCancelReasonType{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if(!self.picker || self.picker.infos.count == 0)
    {
        [self.picker removeFromSuperview];
        
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        self.picker = [[UBPicker alloc] initWithSuperView:delegate.window style:UBPickerStyleOrderCancelReason];
        
        NSMutableArray *reasonsArr = [NSMutableArray arrayWithCapacity:self.cancelOrderReasonsArr.count];
        
        for (NSDictionary *dict in self.cancelOrderReasonsArr) {
            
            [reasonsArr addObject:[dict sea_stringForKey:@"name"]];
        }
        
        self.picker.infos = reasonsArr;
        
        self.picker.delegate = self;
    }
    
    [self.picker showWithAnimated:YES completion:nil];
}

#pragma mark - 选择器代理
- (void)picker:(UBPicker *)picker didFinisedWithConditions:(NSDictionary *)conditions{
    
    WMOrderInfo *info = [self.orderInfosArr objectAtIndex:self.selectCellIndexPath.section];
    
    self.request.identifier = WMCancelOrderIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnCancelOrderParamWithOrderID:info.orderID reasonType:[self.cancelOrderReasonsArr objectAtIndex:[[conditions numberForKey:@"index"] integerValue]]]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

#pragma mark - 订单相关操作
- (void)orderActionNeedRefresh:(BOOL)needRefresh data:(NSData *)data{
    
    if ([WMMyOrderOperation orderActionWithData:data]) {
        
        needRefresh ? [self refreshTableView] : [self alertMsg:@"商品已重新加入购物车"];
    }
}

- (void)refreshTableView{
    
    if (self.orderStatusSelectIndex) {
        
        [self.orderInfosArr removeObjectAtIndex:self.selectCellIndexPath.section];
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.selectCellIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
    }
    else{
        
        self.refreshing = YES;
        
        [self myOrderNetWorkWithIndex:self.orderStatusSelectIndex needRequesting:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        WMOrderInfo *info = [self.orderInfosArr objectAtIndex:self.selectCellIndexPath.section];
        
        self.request.identifier = WMDeleteOrderIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnDeleteOrderParamWithOrderID:info.orderID]];
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
    }
}






@end
