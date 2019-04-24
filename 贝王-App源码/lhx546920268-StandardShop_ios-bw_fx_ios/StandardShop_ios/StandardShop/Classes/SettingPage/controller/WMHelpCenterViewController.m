//
//  WMHelpCenterViewController.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMHelpCenterViewController.h"
#import "WMSettingOperation.h"
#import "WMHelpCenterInfo.h"
#import "WMFoundCommentListViewController.h"

@interface WMHelpCenterViewController ()<SeaHttpRequestDelegate>

//网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

//帮助信息 数组元素是 WMHelpCenterInfo
@property(nonatomic,strong) NSMutableArray *infos;

@end

@implementation WMHelpCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.infos = [NSMutableArray array];

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
}



- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStyleGrouped;
    [super initialization];
    self.tableView.rowHeight = 50.0;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.enablePullUp = YES;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else
    {
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    long long totalSize = 0;
    NSArray *array = [WMSettingOperation helpCenterInfoFromData:data totalSize:&totalSize];

    if(array)
    {
        self.totalCount = totalSize;
        [self.infos addObjectsFromArray:array];
        if(self.tableView)
        {
            [self.tableView reloadData];
        }
        else
        {
            [self initialization];
        }

        [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
        return;
    }
    else
    {
        [self failToLoadData];
    }
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

///加载帮助中心信息
- (void)loadInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMSettingOperation helpCenterInfoParamsWithPageIndex:self.curPage]];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray"]];
    }

    WMHelpCenterInfo *info  = [_infos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMFoundCommentListViewController *detail = [[WMFoundCommentListViewController alloc] init];
    WMHelpCenterInfo *info = [self.infos objectAtIndex:indexPath.row];
    detail.articleId = info.Id;
    detail.title = info.title;

    [self.navigationController pushViewController:detail animated:YES];
}

@end
