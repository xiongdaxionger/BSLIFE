//
//  WMMessageOrderViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageOrderViewController.h"
#import "WMMessageInfo.h"
#import "WMMessageOrderListCell.h"
#import "WMMessageOperation.h"
#import "WMMessageTimeSectionHeader.h"
#import "WMLogisticsViewController.h"
#import "WMOrderDetailViewController.h"

@interface WMMessageOrderViewController ()

@end

@implementation WMMessageOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageOrderListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageOrderListCell"];
    [self.tableView registerClass:[WMMessageTimeSectionHeader class] forHeaderFooterViewReuseIdentifier:@"WMMessageTimeSectionHeader"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = WMMessageOrderListCellHeight;
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WMMessageTimeSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.infos.count - 1 ? WMMessageOrderListCellMargin : CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WMMessageTimeSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMMessageTimeSectionHeader"];

    WMMessageOrderInfo *info = [self.infos objectAtIndex:section];
    header.timeLabel.text = info.time;

    return header;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageOrderListCell" forIndexPath:indexPath];

    cell.info = [self.infos objectAtIndex:indexPath.section];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMMessageOrderInfo *info = [self.infos objectAtIndex:indexPath.section];
    [self markReadMessageInfo:info];
    
    if(info.delvieryId)
    {
        WMLogisticsViewController *logistics = [[WMLogisticsViewController alloc] init];
        logistics.deliveryID = info.delvieryId;
        logistics.isOrder = NO;
        logistics.title = @"物流详情";
        [self.navigationController pushViewController:logistics animated:YES];
    }
    else
    {
        WMOrderDetailViewController *detail = [[WMOrderDetailViewController alloc] init];
        detail.orderID = info.orderId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
