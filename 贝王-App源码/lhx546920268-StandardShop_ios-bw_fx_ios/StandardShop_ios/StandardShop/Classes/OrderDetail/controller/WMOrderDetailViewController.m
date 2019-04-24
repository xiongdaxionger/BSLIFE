//
//  WMOrderDetailViewController.m
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderDetailViewController.h"
#import "WMLogisticsViewController.h"
#import "WMPayInfoViewController.h"
#import "WMGoodCommentAddViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "WMShopCarViewController.h"

#import "XTableCellConfigExDelegate.h"
#import "XTableCellConfigEx.h"
#import "WMOrderDetailInfo.h"
#import "WMGoodInfo.h"
#import "WMOrderDetailOpeartion.h"

#import "WMOrderDetailIDViewCell.h"
#import "WMOrderCreateTimeViewCell.h"
#import "WMSelectMemberViewCell.h"
#import "ConfirmOrderAddeViewCell.h"
#import "WMOrderGoodViewCell.h"
#import "ConfirmOrderMoneyInfoViewCell.h"
#import "WMOrderDetailInfoViewCell.h"
#import "WMShopCarGoodPromotionViewCell.h"
#import "WMOrderDetailBarCodeViewCell.h"
#import "WMSinceCodeViewCell.h"
#import "WMSinceQRCodeView.h"

#import "WMMyOrderOperation.h"
#import "WMConfirmOrderOperation.h"
#import "WMOrderDetailBottomView.h"
#import "UBPicker.h"

@interface WMOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SeaHttpRequestDelegate,UIAlertViewDelegate,UBPickerDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**订单模型
 */
@property (strong,nonatomic) WMOrderDetailInfo *orderDetailInfo;
/**选择器
 */
@property (strong,nonatomic) UBPicker *picker;
@end

@implementation WMOrderDetailViewController

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
        
    self.backItem = YES;
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取订单详情
- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    
    self.request.identifier = WMOrderDetailIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMOrderDetailOpeartion returnOrderDetailWithOrderID:self.orderID]];
}

#pragma mark - 配置类初始化
- (void)cellConfigure{
    
    XTableCellConfigEx *idConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderDetailIDViewCell class] heightOfCell:WMOrderDetailIDViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *customerConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSelectMemberViewCell class] heightOfCell:WMSelectMemberViewCellHegiht tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *addrConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderAddeViewCell class] heightOfCell:kConfirmOrderAddrViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *goodConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderGoodViewCell class] heightOfCell:WMOrderGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *promotionConfig = [XTableCellConfigEx cellConfigWithClassName:[WMShopCarGoodPromotionViewCell class] heightOfCell:WMShopCarGoodPromotionViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *infoConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderDetailInfoViewCell class] heightOfCell:WMOrderDetailInfoViewCellHeight tableView:self.tableView isNib:YES];
        
    XTableCellConfigEx *priceConfig = [XTableCellConfigEx cellConfigWithClassName:[ConfirmOrderMoneyInfoViewCell class] heightOfCell:kConfirmOrderMoneyPayInfoViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderTimeConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderCreateTimeViewCell class] heightOfCell:[NSString isEmpty:self.orderDetailInfo.orderPayTime] ? WMOrderCreateTimeViewCellHeight : WMOrderPayTimeViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *barCodeConfig = [XTableCellConfigEx cellConfigWithClassName:[WMOrderDetailBarCodeViewCell class] heightOfCell:WMOrderDetailBarCodeViewCellHeight tableView:self.tableView isNib:YES];

    XTableCellConfigEx *sinceCodeConfig = [XTableCellConfigEx cellConfigWithClassName:[WMSinceCodeViewCell class] heightOfCell:WMSinceCodeViewCellHeight tableView:self.tableView isNib:YES];
    
    _configureArr = @[idConfig,addrConfig,goodConfig,promotionConfig,infoConfig,priceConfig,orderTimeConfig,customerConfig,barCodeConfig,sinceCodeConfig];
}
#pragma mark - 配置表格视图
- (void)configureTableView{
    
    WeakSelf(self);
    
    CGFloat bottom = 0.0;
    
    if (!(self.orderDetailInfo.isPrepare && self.orderDetailInfo.status == OrderStatusPartPay)) {
        
        if (self.orderDetailInfo.isPrepare) {
            
            if (self.orderDetailInfo.status == OrderStatusPartPay || self.orderDetailInfo.status == OrderStatusWaitPay) {
                
                bottom = WMOrderDetailBottomViewHeight;
            }
            else{
                
                bottom = CGFLOAT_MIN;
            }
        }
        else{
            
            if (self.orderDetailInfo.status == OrderStatusPartGoodRefund || self.orderDetailInfo.status == OrderStatusAllGoodRefund || self.orderDetailInfo.status == OrderStatusShipFinish) {
                
                bottom = [NSString isEmpty:self.orderDetailInfo.deliveryID] ? CGFLOAT_MIN : WMOrderDetailBottomViewHeight;
            }
            else if (self.orderDetailInfo.status == OrderStatusWaitSend){
                
                bottom = self.orderDetailInfo.isInitPointOrder ? CGFLOAT_MIN : WMOrderDetailBottomViewHeight;
            }
            else if (self.orderDetailInfo.status == OrderStatusPartMoneyRefund || self.orderDetailInfo.status == OrderStatusAllMoneyRefund){
                
                bottom = CGFLOAT_MIN;
            }
            else{
                
                bottom = WMOrderDetailBottomViewHeight;
            }
        }
    }
    else{
        
        bottom = CGFLOAT_MIN;
    }
    
    if (self.isRefundOrderDetail) {
        
        bottom = CGFLOAT_MIN;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight - bottom - (isIPhoneX ? 35.0 : 0.0)) style:UITableViewStyleGrouped];
    
    [self cellConfigure];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
        
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    [self.view addSubview:self.tableView];
    
    WMOrderDetailBottomView *bottomView = [[WMOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, WMOrderDetailBottomViewHeight) orderInfo:self.orderDetailInfo];
    
    [bottomView setCancelOrderButtonClick:^{
                
        [weakSelf getCancelOrderReasonRequest];
    }];
    
    [bottomView setDeleteOrderButtonClick:^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该订单吗?" delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定",nil];
        
        [alertView show];
    }];
    
    [bottomView setCheckSinceQRCodeClick:^{
        
        WMSinceQRCodeView *qrcodeView = [WMSinceQRCodeView new];
        
        qrcodeView.qrcodeImageView.image = [UIImage qrCodeImageWithString:weakSelf.orderDetailInfo.sinceCode correctionLevel:SeaQRCodeImageCorrectionLevelPercent30 size:CGSizeMake(220.0, 220.0) contentColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] logo:nil];
        
        [qrcodeView show];
    }];
    
    [bottomView setCheckExpressButtonClick:^{
        
        [weakSelf checkExpress];
    }];
    
    [bottomView setConfirmOrderButtonClick:^{
        
        if (weakSelf.orderDetailInfo.actionType == MainButtonActionTypeConfirmReceive) {
            
            [weakSelf confirmOrder];
        }
        else{
            
            [self alertMsg:weakSelf.orderDetailInfo.mainButtonTitle];
        }
    }];
    
    [bottomView setBuyAgainButtonClick:^{
        
        [weakSelf buyAgain];
    }];
    
    [bottomView setPayOrderButtonClick:^{
        
        if (weakSelf.orderDetailInfo.actionType == MainButtonActionTypePay) {
            
            [weakSelf pushToPayInfo];
        }
        else{
            
            [weakSelf alertMsg:weakSelf.orderDetailInfo.mainButtonTitle];
        }
    }];
    
    if (!(self.orderDetailInfo.isPrepare && self.orderDetailInfo.status == OrderStatusPartPay)) {
        
        if (!self.isRefundOrderDetail) {
            
            [self.view addSubview:bottomView];
        }
    }
}

#pragma mark - 警告框协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
            
        [self deleteOrder];
    }
}

#pragma mark - 获取取消订单理由
- (void)getCancelOrderReasonRequest{
    
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
    
    self.request.identifier = WMCancelOrderIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnCancelOrderParamWithOrderID:self.orderDetailInfo.orderID reasonType:[self.cancelOrderReasonsArr objectAtIndex:[[conditions numberForKey:@"index"] integerValue]]]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

#pragma mark - 删除订单
- (void)deleteOrder{
    
    self.request.identifier = WMDeleteOrderIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnDeleteOrderParamWithOrderID:self.orderDetailInfo.orderID]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

#pragma mark - 查看物流
- (void)checkExpress{
    
    WMLogisticsViewController *logisticsVC = [[WMLogisticsViewController alloc] init];
    
    logisticsVC.deliveryID = self.orderDetailInfo.deliveryID;
    
    logisticsVC.isOrder = NO;

    logisticsVC.title = [NSString stringWithFormat:@"%@物流详情",self.orderDetailInfo.deliveryType];
    
    [self.navigationController pushViewController:logisticsVC animated:YES];
}

#pragma mark - 再次购买
- (void)buyAgain{
    
    self.request.identifier = WMGoodBuyAgainIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnBuyAgainParamWithOrderID:self.orderDetailInfo.orderID]];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
}

#pragma mark - 确认收货
- (void)confirmOrder{
    
    if (self.orderDetailInfo.actionType == MainButtonActionTypeConfirmReceive){
        
        self.request.identifier = WMConfirmGetGoodIdentifier;
        
        [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMMyOrderOperation returnConfirmOrderParamWithOrderID:self.orderDetailInfo.orderID]];
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
    }
    else{
        
        [self alertMsg:self.orderDetailInfo.mainButtonTitle];
    }
}

#pragma mark - 网络请求回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMOrderDetailIdentifier]) {
        
        [self failToLoadData];
    }
    else{
        
        [self alertMsg:@"网络错误，请稍后再试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMOrderDetailIdentifier]){
        
        WMOrderDetailInfo *orderDetailInfo = [WMOrderDetailOpeartion returnOrderDetailInfoWithData:data];
        
        if (orderDetailInfo) {
            
            _orderDetailInfo = orderDetailInfo;
            
            [self configureTableView];
            
            [self cellConfigure];
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
        
        if ([WMMyOrderOperation orderActionWithData:data]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            
            NSString *alertMsg;
            
            if ([request.identifier isEqualToString:WMCancelOrderIdentifier]) {
                
                alertMsg = @"取消订单成功";
            }
            else if ([request.identifier isEqualToString:WMDeleteOrderIdentifier]){
                
                alertMsg = @"删除订单成功";
            }
            else{
                
                alertMsg = @"确认收货成功";
            }
            
            [self alertMsg:alertMsg];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
        }
    }
    else if ([request.identifier isEqualToString:WMGoodBuyAgainIdentifier]){
        
        if ([WMMyOrderOperation orderActionWithData:data]) {
            
            [self alertMsg:@"商品已重新加入购物车"];
            
            [self performSelector:@selector(buyAgainPush) withObject:nil afterDelay:0.8];
        }
    }
}

- (void)buyAgainPush{
    
    WMShopCarViewController *shopCarController = [WMShopCarViewController new];
    
    shopCarController.backItem = YES;
    
    [SeaPresentTransitionDelegate pushViewController:shopCarController useNavigationBar:YES parentedViewConttroller:self];
}

#pragma mark - 表格视图的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [WMOrderDetailOpeartion returnSectionRowNumberWithIndexPath:section orderModel:self.orderDetailInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [WMOrderDetailOpeartion returnSectionNumberWithInfo:self.orderDetailInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    if ([cell isKindOfClass:[WMOrderGoodViewCell class]]) {
        
        WMOrderGoodViewCell *goodCell = (WMOrderGoodViewCell *)cell;
        
        WeakSelf(self);
        
        [goodCell setCommentGood:^(UITableViewCell *cell) {
            
            NSIndexPath *selectIndex = [weakSelf.tableView indexPathForCell:cell];
            
            WMOrderDetailGoodInfo *detailGoodInfo = [weakSelf findModelWithIndexPath:indexPath];
            
            WMGoodInfo *goodInfo = [WMGoodInfo new];
            
            goodInfo.goodId = detailGoodInfo.goodID;
            
            goodInfo.productId = detailGoodInfo.productID;
            
            goodInfo.imageURL = detailGoodInfo.image;
            
            WMGoodCommentAddViewController *comment = [WMGoodCommentAddViewController new];
            
            comment.orderId = weakSelf.orderDetailInfo.orderID;
            
            comment.goodInfo = goodInfo;
            
            [comment setCommentDidFinsihHandler:^{
               
                detailGoodInfo.canGoodComment = NO;
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            }];
            
            [weakSelf.navigationController pushViewController:comment animated:YES];
        }];
    }
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    NSString *classNameString = NSStringFromClass(config.className);

    if ([classNameString isEqualToString:@"ConfirmOrderAddeViewCell"]) {
        
        return [self.orderDetailInfo returnAddrHeight];
    }
    else if ([classNameString isEqualToString:@"WMShopCarGoodPromotionViewCell"]){
        
        NSAttributedString *attrString = [self findModelWithIndexPath:indexPath];
        
        return MAX(WMShopCarGoodPromotionViewCellHeight, [attrString boundsWithConstraintWidth:_width_ - WMShopCarGoodPromotionViewCellExtraFloat].height + 23.0);
    }
    else if ([classNameString isEqualToString:@"ConfirmOrderMoneyInfoViewCell"]){
        
        return [self.orderDetailInfo returnPriceInfoHeight];
    }
    else if ([classNameString isEqualToString:@"WMOrderDetailIDViewCell"]){
        
        if (indexPath.row) {
            
            return MAX(21.0, [self.orderDetailInfo.orderStatusString stringSizeWithFont:[UIFont fontWithName:MainFontName size:14.0] contraintWith:_width_ - 2 * 8].height) + 26.0;
        }
        else{
            
            return config.heightOfCell;
        }
    }
    else if ([classNameString isEqualToString:@"WMOrderGoodViewCell"]){
        
        id model = [self findModelWithIndexPath:indexPath];
        
        if ([model isKindOfClass:[WMOrderDetailGoodInfo class]]) {
            
            WMOrderDetailGoodInfo *goodInfo = (WMOrderDetailGoodInfo *)model;
            
            return MAX(20.0, [goodInfo.specInfo stringSizeWithFont:[UIFont fontWithName:MainFontName size:12.0] contraintWith:_width_ - 90].height) + 81.0;
        }
    }
    
    return config.heightOfCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    NSString *classNameString = NSStringFromClass(config.className);
    
    if ([classNameString isEqualToString:@"WMOrderGoodViewCell"]) {
        
        WMOrderDetailGoodInfo *goodInfo = [self findModelWithIndexPath:indexPath];
        
        WMGoodDetailContainViewController *goodDetail = [[WMGoodDetailContainViewController alloc] init];
        
        goodDetail.productID = goodInfo.productID;
        
        [self.navigationController pushViewController:goodDetail animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [WMOrderDetailOpeartion returnOrderDetailTableFooterHeightWithIndex:section orderInfo:self.orderDetailInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (!section) {
        
        return 8.0;
    }
    
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - 返回配置类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    return [WMOrderDetailOpeartion returnConfigWithSection:indexPath configArr:self.configureArr orderInfo:self.orderDetailInfo];
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    return [WMOrderDetailOpeartion returnOrderModelWith:indexPath orderModel:self.orderDetailInfo];
}

#pragma mark - 进入支付
- (void)pushToPayInfo{

    WMPayInfoViewController *payInfoController = [WMPayInfoViewController new];
    
    payInfoController.orderID = self.orderID;
    
    payInfoController.canBack = YES;
    
    payInfoController.isOrderPay = YES;
    
    [self.navigationController pushViewController:payInfoController animated:YES];
}










@end
