//
//  AboutMePageController.m
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMAboutMePageController.h"
#import "WMShareOperation.h"
#import "WMShareActionSheet.h"
#import "WMSettingOperation.h"
#import "WMAboutMeInfo.h"

@interface WMAboutMePageController ()<SeaHttpRequestDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *httpRequest;

/**关于我们的数据信息
 */
@property (strong,nonatomic) WMAboutMeInfo *aboutMeInfo;

@end

@implementation WMAboutMePageController

#pragma mark - 控制器的生命周期

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"关于我们";
        self.loadWebContentWhileViewDidLoad = NO;
        self.adjustScreenWhenLoadHtmlString = YES;
        self.hidesBottomBarWhenPushed = YES;
        self.useWebTitle = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

#pragma mark - http

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    
    self.aboutMeInfo = [WMSettingOperation returnAboutDictResultWithData:data];
    
    if (self.aboutMeInfo) {
        
        self.htmlString = self.aboutMeInfo.html;
        [self loadWebContent];
    }
    else{
        
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
    self.loading = NO;
    
    [self failToLoadData];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMSettingOperation returnAboutDictParam]];
}

@end
