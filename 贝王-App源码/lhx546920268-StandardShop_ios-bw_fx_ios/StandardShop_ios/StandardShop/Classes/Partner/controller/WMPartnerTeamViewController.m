//
//  WMPartnerTeamViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerTeamViewController.h"
#import "WMPartnerTeamCell.h"
#import "WMPartnerOperation.h"
#import "WMPartnerDetailViewController.h"

@interface WMPartnerTeamViewController ()<SeaHttpRequestDelegate>



@end

@implementation WMPartnerTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    [super initialization];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPartnerTeamCell" bundle:nil] forCellReuseIdentifier:@"WMPartnerTeamCell"];
    self.tableView.rowHeight = WMPartnerTeamCellHeight;
    
    self.enablePullUp = YES;
    
    [self setHasNoMsgViewHidden:self.infos.count != 0 msg:@"暂无团队信息"];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self loadInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
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
    NSArray *infos = [WMPartnerOperation partnerInfoListFromData:data totalSize:&totalSize hierarchy:nil];
    
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
    else if (self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else
    {
        [self failToLoadData];
    }
}

///加载会员信息
- (void)loadInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation partnerInfoListParamWithUserId:self.info.userInfo.userId pageIndex:self.curPage levelInfo:nil orderBy:WMPartnerListOrderByDefault keyword:nil]];
}

#pragma mark- UITableView delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPartnerTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPartnerTeamCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMPartnerDetailViewController *detail = [[WMPartnerDetailViewController alloc] initWithPartnerInfo:[self.infos objectAtIndex:indexPath.row]];
    detail.isSeeSecondReferral = YES;
    detail.hierarchy = self.hierarchy - 1;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
