//
//  WMPartnerOrderListViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerOrderListViewController.h"
#import "WMOrderDetailViewController.h"
#import "WMPartnerOrderListCell.h"
#import "WMPartnerOrderTimeHeader.h"
#import "WMPartnerOperation.h"

#import "WMOrderInfo.h"
///订单每页数量
#define WMOrderPageSize 20

@interface WMPartnerOrderListViewController ()<SeaHttpRequestDelegate>

@end

@implementation WMPartnerOrderListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    [super initialization];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPartnerOrderTimeHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"WMPartnerOrderTimeHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPartnerOrderListCell" bundle:nil] forCellReuseIdentifier:@"WMPartnerOrderListCell"];
    self.tableView.rowHeight = WMPartnerOrderListCellHeight;
    
    self.enablePullUp = YES;
    
    [self setHasNoMsgViewHidden:self.infos.count != 0 msg:@"暂无订单信息"];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self loadOrderInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadOrderInfo];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.loading = NO;
    self.requesting = NO;
    
    if(!self.loadMore)
    {
        [self failToLoadData];
    }
    else
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    self.requesting = NO;
    
    long long totalSize = 0;
    NSArray *infos = [WMPartnerOperation partnerOrderListFromData:data totalSize:&totalSize];
    
    if(infos)
    {
        self.totalCount = totalSize;
        [self.infos addObjectsFromArray:infos];
        
        if(!self.tableView)
        {
            [self initialization];
        }
        else
        {
            [self.tableView reloadData];
        }
        
        [self endPullUpLoadingWithMoreInfo:infos.count < self.totalCount];
    }
    else if(self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else
    {
        [self failToLoadData];
    }
}


///加载销售订单
- (void)loadOrderInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation partnerOrderListParamWithPartnerInfo:self.info pageIndex:self.curPage]];
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    WMOrderInfo *info = [self.infos objectAtIndex:section];
    
    return info.orderGoodsArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPartnerOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPartnerOrderListCell" forIndexPath:indexPath];
    
    WMOrderInfo *info = [self.infos objectAtIndex:indexPath.section];

    cell.info = [info.orderGoodsArr objectAtIndex:indexPath.row];
    
    if(self.isSeeSecondReferral)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WMPartnerOrderTimeHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMPartnerOrderTimeHeader"];
    
    [header configureWithOrderInfo:[self.infos objectAtIndex:section]];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.isSeeSecondReferral)
    {
//        WMOrderListModel *info = [self.infos objectAtIndex:indexPath.row];
//        
//        WMOrderDetailViewController *orderDetailController = [[WMOrderDetailViewController alloc] init];
//        
//        orderDetailController.orderID = info.orderListID;
//        
//        orderDetailController.isShowBottomView = NO;
//        
//        orderDetailController.orderType = OrderListTypeSalesOrder;
//                
//        [self.navigationController pushViewController:orderDetailController animated:YES];
    }
}


@end
