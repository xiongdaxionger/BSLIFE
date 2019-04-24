//
//  WMRefundReadViewController.m
//  StandardShop
//
//  Created by mac on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundReadViewController.h"

#import "WMRefundOperation.h"

@interface WMRefundReadViewController ()<SeaHttpRequestDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *httpRequest;
@end

@implementation WMRefundReadViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        self.loadWebContentWhileViewDidLoad = NO;
        
        self.useWebTitle = NO;
        
        self.title = @"售后须知";
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
    
    NSString *html = [WMRefundOperation returnRefundReadMessageResult:data];
    
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

#pragma mark - 获取售后内容
- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMRefundOperation returnRefundReadMessageParam]];
}







@end
