//
//  WMMessageNoticeViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageNoticeViewController.h"
#import "WMMessageInfo.h"
#import "WMMessageNoticeListCell.h"
#import "WMFoundCommentListViewController.h"

@interface WMMessageNoticeViewController ()

@end

@implementation WMMessageNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageNoticeListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageNoticeListCell"];
    self.tableView.rowHeight = 55.0;
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageNoticeListCell" forIndexPath:indexPath];

    cell.info = [self.infos objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMMessageNoticeInfo *info = [self.infos objectAtIndex:indexPath.row];
    [self markReadMessageInfo:info];
    WMMessageNoticeListCell *cell = (WMMessageNoticeListCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.red_point.hidden = YES;
    
    WMFoundCommentListViewController *article = [[WMFoundCommentListViewController alloc] init];
    article.articleId = info.articleId;
    article.title = info.title;
    [self.navigationController pushViewController:article animated:YES];
}


@end
