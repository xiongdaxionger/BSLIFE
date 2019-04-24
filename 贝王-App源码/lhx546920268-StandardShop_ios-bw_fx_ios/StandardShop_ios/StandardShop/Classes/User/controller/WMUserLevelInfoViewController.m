//
//  WMUserLevelInfoViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMUserLevelInfoViewController.h"
#import "WMUserLevelInfoCell.h"
#import "WMUserLevelInfoHeader.h"
#import "WMUserInfo.h"
#import "WMUserOperation.h"

@interface WMUserLevelInfoViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///头部
@property(nonatomic,strong) WMUserLevelInfoHeader *header;

///等级信息
@property(nonatomic,strong) WMUserLevelInfoCell *cell;

///会员等级说明html
@property(nonatomic,copy) NSString *levelInfoHtml;

///内容高度
@property(nonatomic,assign) CGFloat height;

@end

@implementation WMUserLevelInfoViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backItem = YES;
    self.title = @"会员";

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.header = [[WMUserLevelInfoHeader alloc] init];

    self.height = self.contentHeight - self.header.height;

    self.cell = [[WMUserLevelInfoCell alloc] init];

    WeakSelf(self);
    self.cell.webViewDidFinishLoadingHandler = ^(CGFloat height){

        weakSelf.height = height;
        [weakSelf.tableView reloadData];
    };


    [super initialization];

    ///头部背景视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -_height_ + 5.0, _width_, _height_)];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor colorFromHexadecimal:@"FF4444"];
    [self.tableView addSubview:view];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.header;
    [self.cell.webView loadHTMLString:self.levelInfoHtml baseURL:nil];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.levelInfoHtml = [WMUserOperation userLevelInfoFromData:data];
    if(self.levelInfoHtml)
    {
        [self initialization];
    }
    else
    {
        [self failToLoadData];
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation userLevelInfoParams]];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell;
}


@end
