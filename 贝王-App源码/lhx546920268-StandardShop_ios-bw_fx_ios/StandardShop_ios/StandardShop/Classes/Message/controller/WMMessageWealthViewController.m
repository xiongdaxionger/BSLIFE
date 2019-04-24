//
//  WMMessageWealthViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageWealthViewController.h"
#import "WMMessageInfo.h"
#import "WMMessageWealthEarningsListCell.h"
#import "WMMessageWealthCouponsListCell.h"
#import "WMCouponsListViewController.h"
#import "WMBalanceViewController.h"
#import "WMMessageTimeSectionHeader.h"

@interface WMMessageWealthViewController ()

@end

@implementation WMMessageWealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageWealthEarningsListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageWealthEarningsListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageWealthCouponsListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageWealthCouponsListCell"];
    [self.tableView registerClass:[WMMessageTimeSectionHeader class] forHeaderFooterViewReuseIdentifier:@"WMMessageTimeSectionHeader"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageInfo *info = [self.infos objectAtIndex:indexPath.section];

    if(info.subtype == WMMessageSubtypeCoupons)
    {
        return WMMessageWealthCouponsListCellHeight;
    }
    else
    {
        return [WMMessageWealthEarningsListCell rowHeightForInfo:info];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WMMessageTimeSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.infos.count - 1 ? WMMessageWealthEarningsListCellMargin : CGFLOAT_MIN;
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
    WMMessageInfo *info = [self.infos objectAtIndex:indexPath.section];

    if(info.subtype == WMMessageSubtypeEarnings)
    {
        WMMessageWealthEarningsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageWealthEarningsListCell" forIndexPath:indexPath];

        cell.info = info;

        return cell;
    }
    else
    {
        WMMessageWealthCouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageWealthCouponsListCell" forIndexPath:indexPath];

        cell.info = (WMMessageCouponsInfo*)info;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMMessageInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    [self markReadMessageInfo:info];

    switch (info.subtype)
    {
        case WMMessageSubtypeCoupons :
        {
            WMCouponsListViewController *coupons = [[WMCouponsListViewController alloc] init];
            [self.navigationController pushViewController:coupons animated:YES];
        }
            break;
        case WMMessageSubtypeEarnings :
        {
            WMBalanceViewController *balance = [[WMBalanceViewController alloc] init];
            UINavigationController *nav = [balance createdInNavigationController];

            SeaPresentTransitionDelegate *delegate = [[SeaPresentTransitionDelegate alloc] init];
            nav.sea_transitioningDelegate = delegate;
            [self presentViewController:nav animated:YES completion:^(void){

                [delegate addInteractiveTransitionToViewController:balance];
            }];
        }
            break;
        default:
            break;
    }

}


@end
