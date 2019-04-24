//
//  WMMessageListViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageListViewController.h"
#import "WMMessageCenterInfo.h"
#import "WMMessageOperation.h"
#import "WMMessageInfo.h"

@interface WMMessageListViewController ()<SeaHttpRequestDelegate,SeaNetworkQueueDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

@end

@implementation WMMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.title = self.info.name;
    self.infos = [NSMutableArray array];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    [super initialization];
    self.tableView.height -= (isIPhoneX ? 35.0 : 0.0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.enablePullUp = YES;
}

///消息标记成已读
- (void)markReadMessageInfo:(WMMessageInfo*) info
{
    if(info.Id && !info.read)
    {
        info.read = YES;
        self.info.unreadMsgCount --;
        WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
        userInfo.personCenterInfo.unreadMessageCount --;
        
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMMessageOperation messageMarkReadParamsWithInfo:info] identifier:info.Id];
        [self.queue startDownload];
    }
}

#pragma mark- queue

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(self.loadMore)
    {
        [self endPullUpLoadingWithMoreInfo:YES];
        self.curPage --;
    }
    else if(!self.tableView)
    {
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    long long totalSize = 0;
    NSArray *infos = [WMMessageOperation messageListFromData:data info:self.info totalSize:&totalSize];
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
        
        [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
    }
    else if (self.loadMore)
    {
        [self endPullUpLoadingWithMoreInfo:YES];
        self.curPage --;
    }
    else if(!self.tableView)
    {
        [self initialization];
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

///加载信息
- (void)loadInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMMessageOperation messageListParamsWithInfo:self.info pageIndex:self.curPage]];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = [NSString stringWithFormat:@"暂无%@", self.info.name];
}

@end
