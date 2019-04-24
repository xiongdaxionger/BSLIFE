//
//  WMArticleViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/8/17.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMArticleViewController.h"
#import "WMHomeOperation.h"
#import "WMArticleInfo.h"

@interface WMArticleViewController ()<SeaHttpRequestDelegate>

//网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

//文章信息
@property(nonatomic,strong) WMArticleInfo *info;

@end

@implementation WMArticleViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.adjustScreenWhenLoadHtmlString = YES;
        self.loadWebContentWhileViewDidLoad = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backItem = YES;
    
    if(![NSString isEmpty:self.title])
    {
        self.useWebTitle = NO;
    }
    
    if([NSString isEmpty:self.content])
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        [self reloadDataFromNetwork];
    }
    else
    {
        self.htmlString = self.content;
        [self loadWebContent];
    }
}

//加载用户协议
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMHomeOperation articleInfoParamWithArticleId:self.articleId]];
}


#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    self.info = [WMHomeOperation articleInfoResultFromData:data];
    self.htmlString = self.info.contentHtml;
    [self loadWebContent];
}

@end
