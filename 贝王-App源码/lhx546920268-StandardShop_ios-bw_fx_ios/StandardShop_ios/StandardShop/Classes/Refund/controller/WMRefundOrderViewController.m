//
//  WMRefundOrderViewController.m
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundOrderViewController.h"
#import "WMOrderDetailViewController.h"
#import "WMRefundGoodDetailViewController.h"
#import "WMRefundMoneyDetailViewController.h"

#import "WMRefundOperation.h"
#import "WMMyOrderOperation.h"
#import "WMOrderInfo.h"

#import "WMOrderIDViewCell.h"
#import "WMOrderGoodViewCell.h"
#import "WMRefundButtonViewCell.h"
#import "XTableCellConfigEx.h"

@interface WMRefundOrderViewController ()<SeaHttpRequestDelegate>
/**选中的行
 */
@property (strong,nonatomic) NSIndexPath *selectIndexPath;
@end

@implementation WMRefundOrderViewController

#pragma mark - 控制器生命周期
- (instancetype)initWithType:(NSString *)type{
    
    self = [super init];
    
    if (self) {
        
        self.orderListArray = [NSMutableArray new];
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.refundType = type;
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self reloadDataFromNetwork];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)beginDropDownRefresh{
    
    self.curPage = 1;
    
    [self getRefundOrderRequest];
}

- (void)beginPullUpLoading{
    
    self.curPage ++;
    
    [self getRefundOrderRequest];
}

#pragma mark - 网络请求
- (void)getRefundOrderRequest{
    
    self.request.identifier = WMGetRefundOrderListIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnRefundOrderParamWithPage:self.curPage type:self.refundType]];
}

#pragma mark - 网络协议
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.showNetworkActivity = NO;
    
    self.requesting = NO;
    
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
        
    if ([request.identifier isEqualToString:WMGetRefundOrderListIdentifier]) {
        
        NSDictionary *infoDict = [WMMyOrderOperation returnMyOrderInfoResultWithData:data canComment:NO];
        
        if (infoDict) {
            
            if (!self.tableView) {
                
                [self initialization];
                
                [self configureCellConfig];
            }
            
            if (self.refreshing) {
                
                [self.orderListArray removeAllObjects];
            }
            
            [self.orderListArray addObjectsFromArray:[infoDict arrayForKey:@"info"]];
            
            [self.tableView reloadData];
            
            [self endPullUpLoadingWithMoreInfo:self.orderListArray.count < [[infoDict numberForKey:@"count"] integerValue]];
            
            [self endDropDownRefreshWithMsg:nil];
        }
        else{
            
            [self failToLoadData];
        }
    }
}

- (void)reloadDataFromNetwork{
    
    self.curPage = 1;
    
    [self getRefundOrderRequest];
}

#pragma mark - 配置单元格
- (void)configureCellConfig{
    
    XTableCellConfigEx *orderID = [XTableCellConfigEx cellConfigWithClassName:[WMOrderIDViewCell class] heightOfCell:WMOrderIDViewCellHegith tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderGood = [XTableCellConfigEx cellConfigWithClassName:[WMOrderGoodViewCell class] heightOfCell:WMOrderGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *refundButton = [XTableCellConfigEx cellConfigWithClassName:[WMRefundButtonViewCell class] heightOfCell:WMRefundButtonViewCellHeight tableView:self.tableView isNib:YES];
    
    _configureArr = @[orderID,orderGood,refundButton];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    self.tableView.height = _height_ - _SeaMenuBarHeight_ - self.navigationBarHeight - self.statusBarHeight - (isIPhoneX ? 35.0 : 0.0);
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;

    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmtpyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = [self.refundType isEqualToString:@"reship"] ? @"暂无退换货订单" : @"暂无退款订单";
}

#pragma mark - 表格视图协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _orderListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WMOrderInfo *orderViewModel = [self.orderListArray objectAtIndex:section];
    
    return orderViewModel.orderGoodsArr.count + 2;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMOrderInfo *orderViewModel = [_orderListArray objectAtIndex:indexPath.section];
    
    WMOrderDetailViewController *orderDetailController = [[WMOrderDetailViewController alloc] init];
    
    orderDetailController.orderID = orderViewModel.orderID;
    
    orderDetailController.isRefundOrderDetail = YES;
    
    [self.navigationController pushViewController:orderDetailController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
    
    id model = [self findModelWithIndexPath:indexPath];
    
    id<XTableCellConfigExDelegate> cell = [config cellOfCellConfigWithTableView:tableView indexPath:indexPath];
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

#pragma mark - 返回配置累类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!_orderListArray.count) {
        
        return nil;
    }
    
    WMOrderInfo *orderViewModel = [_orderListArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        
        return [_configureArr firstObject];
    }
    else if (indexPath.row >= 1 && indexPath.row <= orderViewModel.orderGoodsArr.count){
        
        return [_configureArr objectAtIndex:1];
    }
    else{
        
        return [_configureArr lastObject];
    }
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!_orderListArray.count) {
        
        return nil;
    }
    
    WMOrderInfo *orderViewModel = [_orderListArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        
        return orderViewModel;
    }
    else if (indexPath.row >= 1 && indexPath.row <= orderViewModel.orderGoodsArr.count){
        
        return [orderViewModel.orderGoodsArr objectAtIndex:indexPath.row - 1];
    }
    else{
        
        return @{kModelKey:orderViewModel,kControllerKey:self,@"isRecord":@(NO)};
    }
}

- (void)refundOrderWithOrderID:(NSString *)orderID cell:(UITableViewCell *)cell isGood:(BOOL)isGood{
    
    WeakSelf(self);
    
    _selectIndexPath = [self.tableView indexPathForCell:cell];
    
    if (isGood) {
        
        WMRefundGoodDetailViewController *goodDetailController = [[WMRefundGoodDetailViewController alloc] init];
        
        goodDetailController.orderID = orderID;
        
        [goodDetailController setActionCallBack:^{
            
            [weakSelf resetStatus];
        }];
        
        [self.navigationController pushViewController:goodDetailController animated:YES];
    }
    else{
        
        WMRefundMoneyDetailViewController *moneyDetailController = [[WMRefundMoneyDetailViewController alloc] init];
        
        moneyDetailController.orderID = orderID;
        
        [moneyDetailController setActionCallBack:^{
           
            [weakSelf resetStatus];
        }];
        
        [self.navigationController pushViewController:moneyDetailController animated:YES];
    }
    
}

- (void)resetStatus{
    
    WMOrderInfo *orderModel = [self.orderListArray objectAtIndex:self.selectIndexPath.section];
    
    orderModel.canOrderAffter = NO;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.selectIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}






@end
