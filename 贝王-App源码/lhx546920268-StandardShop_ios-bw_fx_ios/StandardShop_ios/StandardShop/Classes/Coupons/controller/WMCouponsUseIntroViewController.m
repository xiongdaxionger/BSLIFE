//
//  WMCouponsUseIntroViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMCouponsUseIntroViewController.h"
#import "WMCouponsOperation.h"

@interface WMCouponsUseIntroViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMCouponsUseIntroViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.loadWebContentWhileViewDidLoad = NO;
        self.useWebTitle = NO;
        self.adjustScreenWhenLoadHtmlString = YES;
        self.title = @"优惠券使用说明";
    }
    return self;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;

    NSString *html = [WMCouponsOperation couponsUseIntroFromData:data];
    if(html)
    {
        self.htmlString = html;
        [self loadWebContent];
    }
}

#pragma mark- 加载视图

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    self.adjustScreenWhenLoadHtmlString = YES;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    [self reloadDataFromNetwork];
 
}

///加载学院详情
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation couponsUseIntroParams]];
}

@end
