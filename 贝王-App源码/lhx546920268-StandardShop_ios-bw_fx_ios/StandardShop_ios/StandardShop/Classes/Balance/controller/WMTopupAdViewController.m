//
//  WMTopupAdViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMTopupAdViewController.h"
#import "WMBalanceOperation.h"
#import "WMTopupViewController.h"
#import "WMTopupActivityViewController.h"
#import "WMTopupInfo.h"

@interface WMTopupAdViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMTopupAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    WMTopupInfo *info = [WMBalanceOperation topupInfoFromData:data];
    
    if(info)
    {
        UIViewController *vc = nil;
        if(info.activitys.count > 0)
        {
            WMTopupActivityViewController *topup = [[WMTopupActivityViewController alloc] init];
            topup.topupInfo = info;
            vc = topup;
        }
        else
        {
            WMTopupViewController *topup = [[WMTopupViewController alloc] init];
            topup.topupInfo = info;
            vc = topup;
        }
        
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:vc];
        [self.navigationController setViewControllers:viewControllers];
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation topupInfoParams]];
}

@end
