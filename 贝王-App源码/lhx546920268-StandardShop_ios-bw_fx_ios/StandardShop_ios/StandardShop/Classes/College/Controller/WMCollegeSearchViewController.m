//
//  WMCollegeSearchViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMCollegeSearchViewController.h"
#import "WMCollegeOperation.h"
#import "WMCollegeInfo.h"
#import "WMCollegeTableViewCell.h"
#import "WMCollegeDetailViewController.h"

@interface WMCollegeSearchViewController ()

@end

@implementation WMCollegeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.searchBar.placeholder = @"请输入名称";
}

- (void)didSearchWithText:(NSString *)text
{
    [self loadCollegeInfo];
}

- (void)initialization
{
    [super initialization];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCollegeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.enablePullUp = YES;
    [self hasMsg];
}

#pragma mark - SeaHttpRequestDelegate

/**请求失败
 */
- (void)httpRequest:(SeaHttpRequest*) request didFailed:(NSInteger) error
{
    if(self.loadMore)
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else
    {
        [self failToLoadData];
        [self.infos removeAllObjects];
        [self.tableView reloadData];
        [self setHasNoMsgViewHidden:YES msg:nil];
    }
    
    return;
}

/**请求完成
 */
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData*) data
{
    self.showNetworkActivity = NO;
    self.requesting = NO;
 
    if([request.identifier isEqualToString:WMCollegeListIdentifier])
    {
        NSArray *array = [WMCollegeOperation collegeListFromData:data];
        if(!self.loadMore)
        {
            self.curPage = WMHttpPageIndexStartingValue;
            [self.infos removeAllObjects];
        }
        
        [self.infos addObjectsFromArray:array];
        
        if(self.tableView)
        {
            [self.tableView reloadData];
            [self hasMsg];
        }
        else
        {
            [self initialization];
        }
        
        
        [self endPullUpLoadingWithMoreInfo:array.count >= WMCollegePageSize];
    }
}

- (void)reloadDataFromNetwork
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    [self loadCollegeInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadCollegeInfo];
}

///获取学院信息
- (void)loadCollegeInfo
{
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    self.httpRequest.identifier = WMCollegeListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCollegeOperation collegeListParamsWithCategoryId:self.categoryInfo.Id keyword:self.searchBar.text pageIndex:self.curPage pageSize:WMCollegePageSize]];
}

///判断是否有学院信息
- (void)hasMsg
{
    [self setHasNoMsgViewHidden:self.infos.count > 0 msg:[NSString stringWithFormat:@"暂无学院信息"]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMCollegeInfo *college = self.infos[indexPath.row];
    
    CGFloat height = [WMCollegeTableViewCell rowHeightForInfo:college];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    WMCollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.info = [self.infos objectAtIndex:indexPath.row];
    // cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMCollegeInfo *college = self.infos[indexPath.row];
    
    WMCollegeDetailViewController *detail = [[WMCollegeDetailViewController alloc] initWithInfo:college];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
