//
//  WMPrivacyPolicyViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/11.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPrivacyPolicyViewController.h"
#import "WMUserOperation.h"

@interface WMPrivacyPolicyViewController ()<SeaHttpRequestDelegate>

//网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

//协议文本
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation WMPrivacyPolicyViewController

#pragma mark - 控制器的生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backItem = YES;

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    _webView.scrollView.bounces = NO;
    _webView.scalesPageToFit = NO;
    [self.view addSubview:_webView];
}

//加载用户协议
- (void)reloadDataFromNetwork
{
    self.loading = YES;

    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation privacyPolicyParams]];
}

#pragma mark- SeaHttpRequestDelegate
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{

    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    if(!self.webView)
    {
        [self initialization];
    }
    NSString *html = [WMUserOperation privacyPolicyFromData:data];

    [_webView loadHTMLString:html baseURL:nil];
}


@end
