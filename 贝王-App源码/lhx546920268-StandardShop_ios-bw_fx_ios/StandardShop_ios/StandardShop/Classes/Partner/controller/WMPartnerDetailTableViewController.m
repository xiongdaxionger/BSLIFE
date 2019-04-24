//
//  WMPartDetailTableViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerDetailTableViewController.h"
#import "WMPartnerInfo.h"

@interface WMPartnerDetailTableViewController ()<SeaHttpRequestDelegate>

@end

@implementation WMPartnerDetailTableViewController

/**构造方法
 *@param info 客户信息
 *@return 一个实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.info = info;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    self.loadingIndicator.frame = self.view.bounds;
    self.badNetworkRemindView.frame = self.view.bounds;
    self.hasNoMsgView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.style = UITableViewStyleGrouped;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.infos = [NSMutableArray arrayWithCapacity:5];
}

- (void)initialization
{
    [super initialization];
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = self.view.backgroundColor;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.infos.count > 0 ? 10.0 : CGFLOAT_MIN;
}

@end
