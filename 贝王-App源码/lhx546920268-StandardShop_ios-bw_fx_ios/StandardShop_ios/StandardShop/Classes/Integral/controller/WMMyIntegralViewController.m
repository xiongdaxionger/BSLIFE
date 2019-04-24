//
//  MYsoureViewController.m
//  WuMei
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMMyIntegralViewController.h"
#import "WMIntegralUseHistoryCell.h"
#import "WMIntegralRuleCell.h"
#import "WMIntegralInfo.h"
#import "WMIntegralOperation.h"
#import "WMUserInfo.h"
#import "WMMyIntegralTableHeader.h"

@interface WMMyIntegralViewController ()<UIWebViewDelegate,SeaMenuBarDelegate,SeaNetworkQueueDelegate>

///菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///积分使用记录信息 数组元素是WMIntegralInfo
@property(nonatomic,strong) NSMutableArray *infos;

///网络请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

///积分信息
@property(nonatomic,strong) WMIntegralInfo *integralInfo;

///积分规则是否已加载完成
@property(nonatomic,assign) BOOL isFinishLoad;

///积分规则高度
@property(nonatomic,assign) CGFloat htmlHeight;

///积分规则字符串
@property(nonatomic,copy) NSString *integralRuleHtmlString;

///是否是加载失败
@property(nonatomic,assign) BOOL isFailToLoad;

@end

@implementation WMMyIntegralViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark- life cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.iconTintColor = [UIColor whiteColor];
    [self setupNavigationBarWithBackgroundColor:WMRedColor titleColor:[UIColor whiteColor] titleFont:nil];
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageWithColor:WMRedColor size:CGSizeMake(1,1)];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    
    self.backItem = YES;
    self.title = @"我的积分";
    
    self.infos = [NSMutableArray array];
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;

    self.style = UITableViewStyleGrouped;

    self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:[NSArray arrayWithObjects:@"积分规则",@"积分记录",nil] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    _menuBar.selectedIndex = 0;
    _menuBar.delegate = self;

    ///表头
    WMMyIntegralTableHeader *header = [[WMMyIntegralTableHeader alloc] init];
    header.navigationController = self.navigationController;
    header.info = self.integralInfo;

    self.htmlHeight = self.contentHeight - header.height - _SeaMenuBarHeight_;

    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMIntegralUseHistoryCell" bundle:nil] forCellReuseIdentifier:@"WMIntegralUseHistoryCell"];
    [self.tableView registerClass:[WMIntegralRuleCell class] forCellReuseIdentifier:@"WMIntegralRuleCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -_height_, _width_, _height_)];
    view.backgroundColor = _appMainColor_;
    [self.tableView addSubview:view];
    self.tableView.tableHeaderView = header;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    if(self.infos.count < self.totalCount)
    {
         self.enablePullUp = YES;
        [self endPullUpLoadingWithMoreInfo:NO];
    }
    self.loadMoreControl.backgroundColor = self.view.backgroundColor;

    self.tableView.sea_emptyViewInsets = UIEdgeInsetsMake(self.menuBar.height, 0, 0, 0);
    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmptyDelegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    switch (self.menuBar.selectedIndex)
    {
        case 0 :
        {
            view.textLabel.text = @"暂无积分规则";
        }
            break;
        case 1 :
        {
            view.textLabel.text = @"暂无积分记录";
        }
            break;
        default:
            break;
    }
}


#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    if(!self.loadMore)
    {
        self.isFailToLoad = YES;
    }
    else
    {
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
}

- (void)networkQueue:(SeaNetworkQueue *)quque requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    if([identifier isEqualToString:WMIntegralRuleIdentifier])
    {
        self.integralRuleHtmlString = [WMIntegralOperation integralRuleResultFromData:data];
        return;
    }
    
    if([identifier isEqualToString:WMIntegralUseHistoryIdentifier])
    {
        WMIntegralInfo *info = nil;
        long long totalSize = 0;

        NSArray *array = [WMIntegralOperation integralUseHistoryFromData:data integralInfo:self.integralInfo == nil ? &info : nil totalSize:&totalSize];
        if(array)
        {
            if(!self.integralInfo)
                self.integralInfo = info;
            
            self.totalCount = totalSize;
            [self.infos addObjectsFromArray:array];
        }
        else if (self.loadMore)
        {
            self.curPage --;
        }
        else
        {
            [self failToLoadData];
        }
        
        return;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(!self.tableView)
    {
        [self initialization];
    }
    else
    {
        [self.tableView reloadData];
        [self endPullUpLoadingWithMoreInfo:self.menuBar.selectedIndex == 1 && self.infos.count < self.totalCount];
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    self.isFailToLoad = NO;
    [self loadInfo];
}

-(void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
}

///加载积分规则和积分使用记录
- (void)loadInfo
{
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMIntegralOperation integralUseHistoryParamWithPageIndex:self.curPage] identifier:WMIntegralUseHistoryIdentifier];
    if(!self.loadMore)
    {
        [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMIntegralOperation integralRuleParam] identifier:WMIntegralRuleIdentifier];
    }
    
    [self.queue startDownload];
    
}

#pragma mark- SeaMenuBar delegate

-(void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    [self.tableView reloadData];
    
    if(index == 0)
    {
        [self endPullUpLoadingWithMoreInfo:NO];
    }
    else
    {
        [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
    }
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_menuBar.selectedIndex == 0)
    {
        return self.htmlHeight;
    }
    else
    {
        return WMIntegralUseHistoryCellHeight;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _SeaMenuBarHeight_;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.menuBar;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_menuBar.selectedIndex == 0)
    {
        return 1;
    }
    else
    {
        return _infos.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(_menuBar.selectedIndex == 0)
   {
       WMIntegralRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMIntegralRuleCell" forIndexPath:indexPath];
       cell.webView.delegate = self;
       
       [cell.webView loadHTMLString:self.integralRuleHtmlString baseURL:nil];
       cell.webView.height = self.htmlHeight;
       
       return cell;
   }
    else
    {
        WMIntegralUseHistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMIntegralUseHistoryCell" forIndexPath:indexPath];
        cell.info = [_infos objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark- UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.htmlHeight != self.tableView.height - self.tableView.tableHeaderView.height - _SeaMenuBarHeight_)
        return;
    
    if(self.isFinishLoad)
        {
            webView.height = 1;
            
            webView.height = webView.scrollView.contentSize.height;

            webView.userInteractionEnabled = NO;
            self.htmlHeight = webView.height;

            if(self.htmlHeight <= 0)
            {
                self.htmlHeight = 1;
            }

            [self.tableView reloadData];
            return;
            
        }
    
    //获取实际要显示的html
    NSString *html = [webView htmlAdjustWithPageHtml:self.integralRuleHtmlString];
    
    self.integralRuleHtmlString = html;
    //设置为已经加载完成
    _isFinishLoad = YES;
    //加载实际要现实的html
    [webView loadHTMLString:html baseURL:nil];
}

@end
