//
//  WMMessageActivityViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageActivityViewController.h"
#import "WMMessageInfo.h"
#import "WMMessageActivityListCell.h"
#import "WMMessageOperation.h"
#import "WMMessageTimeSectionHeader.h"

@interface WMMessageActivityViewController ()

@end

@implementation WMMessageActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageActivityListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageActivityListCell"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WMMessageTimeSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.infos.count - 1 ? WMMessageActivityListCellMargin : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WMMessageActivityListCell rowHeightForInfo:[self.infos objectAtIndex:indexPath.section]];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WMMessageTimeSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WMMessageTimeSectionHeader"];

    WMMessageActivityInfo *info = [self.infos objectAtIndex:section];
    header.timeLabel.text = info.time;

    return header;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageActivityListCell" forIndexPath:indexPath];

    cell.info = [self.infos objectAtIndex:indexPath.section];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMMessageActivityInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    [self markReadMessageInfo:info];
    
    SeaWebViewController *web = [[SeaWebViewController alloc] initWithURL:info.activityURL];
    web.useWebTitle = NO;
    [self.navigationController pushViewController:web animated:YES];
    web.title = info.title;
    web.backItem = YES;
}

@end
