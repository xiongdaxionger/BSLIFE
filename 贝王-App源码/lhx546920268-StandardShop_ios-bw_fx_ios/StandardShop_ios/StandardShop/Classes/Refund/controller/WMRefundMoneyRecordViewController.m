//
//  WMRefundMoneyRecordViewController.m
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundMoneyRecordViewController.h"
#import "WMOrderDetailViewController.h"

#import "WMRefundOperation.h"
#import "WMRefundMoneyRecordModel.h"

#import "WMOrderIDViewCell.h"
#import "WMOrderGoodViewCell.h"
#import "WMRefundInfoViewCell.h"
#import "WMRefundButtonViewCell.h"
#import "XTableCellConfigEx.h"

@interface WMRefundMoneyRecordViewController ()<SeaHttpRequestDelegate>

@end

@implementation WMRefundMoneyRecordViewController

#pragma mark - 控制器生命周期

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.orderListArray = [NSMutableArray new];
                
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginDropDownRefresh) name:@"commitMoneyRefundSuccess" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self reloadDataFromNetwork];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 下拉刷新&上拉加载
- (void)beginDropDownRefresh{
    
    self.curPage = 1;
    
    self.refreshing = YES;
    
    [self getRefundMoneyRecordRequest];
}

- (void)beginPullUpLoading{
    
    self.curPage ++;
    
    [self getRefundMoneyRecordRequest];
}

#pragma mark - 网络请求
- (void)getRefundMoneyRecordRequest{
    
    self.request.identifier = WMGetRefundRecordListIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnRefundRecordParamWithPageNumber:self.curPage type:@"refund"]];
}

#pragma mark - 网络协议
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    self.requesting = NO;
    
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    self.loading = NO;
    
    if ([request.identifier isEqualToString:WMGetRefundRecordListIdentifier]) {
        
        NSDictionary *infoDict = [WMRefundOperation returnRefundGoodRecordsArrWithData:data];
        
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
    
    [self getRefundMoneyRecordRequest];
}

#pragma mark - 配置单元格
- (void)configureCellConfig{
    
    XTableCellConfigEx *orderID = [XTableCellConfigEx cellConfigWithClassName:[WMOrderIDViewCell class] heightOfCell:WMOrderIDViewCellHegith tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *orderGood = [XTableCellConfigEx cellConfigWithClassName:[WMOrderGoodViewCell class] heightOfCell:WMOrderGoodViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *refundInfo = [XTableCellConfigEx cellConfigWithClassName:[WMRefundInfoViewCell class] heightOfCell:WMRefundInfoViewCellHeight tableView:self.tableView isNib:YES];
    
    XTableCellConfigEx *refundButton = [XTableCellConfigEx cellConfigWithClassName:[WMRefundButtonViewCell class] heightOfCell:WMRefundButtonViewCellHeight tableView:self.tableView isNib:YES];
    
    _configureArr = @[orderID,orderGood,refundInfo,refundButton];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView setBackgroundView:nil];
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.frame = CGRectMake(0, 0, _width_, self.contentHeight - _SeaMenuBarHeight_ - (isIPhoneX ? 35.0 : 0.0));
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmtpyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无退款记录";
}

#pragma mark - 表格视图协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _orderListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WMRefundMoneyRecordModel *moneyRecordModel = [self.orderListArray objectAtIndex:section];
    
    return [WMRefundOperation returnRefundMoneyRecordSectionNumber:moneyRecordModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMRefundMoneyRecordModel *moneyRecordModel = [_orderListArray objectAtIndex:indexPath.section];
    
    if (indexPath.row <= moneyRecordModel.goodsArr.count) {
        
        XTableCellConfigEx *config = [self findConfigWithIndexPath:indexPath];
        
        return config.heightOfCell;
    }
    else{
        
        return [WMRefundOperation returnRefundMoneyRecordCellHeightWithIndex:indexPath.row moneyRecordModel:moneyRecordModel];
    }
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
    
    [cell configureCellWithModel:model];
    
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMRefundMoneyRecordModel *moneyRecordModel = [_orderListArray objectAtIndex:indexPath.section];
    
    WMOrderDetailViewController *orderDetailController = [[WMOrderDetailViewController alloc] init];
    
    orderDetailController.orderID = moneyRecordModel.orderID;
    
    [self.navigationController pushViewController:orderDetailController animated:YES];
}

#pragma mark - 返回配置累类和模型
- (XTableCellConfigEx *)findConfigWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!_orderListArray.count) {
        
        return nil;
    }
    
    return [WMRefundOperation returnRefundMoneyRecordConfigWith:[_orderListArray objectAtIndex:indexPath.section] indexPath:indexPath.row configArr:_configureArr];
}

- (id)findModelWithIndexPath:(NSIndexPath *)indexPath{
    
    if (!_orderListArray.count) {
        
        return nil;
    }
    
    WMRefundMoneyRecordModel *moneyRecordModel = [_orderListArray objectAtIndex:indexPath.section];
    
    return [WMRefundOperation returnRefundMoneyRecordModelWithIndex:indexPath.row moneyRecordModel:moneyRecordModel];
}








@end
