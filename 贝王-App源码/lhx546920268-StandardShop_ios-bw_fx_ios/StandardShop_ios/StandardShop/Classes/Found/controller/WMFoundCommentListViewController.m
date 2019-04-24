//
//  WMFoundCommentListViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/23.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentListViewController.h"
#import "WMFoundOperation.h"
#import "WMFoundCommentListCell.h"
#import "WMFoundCommentInfo.h"
#import "WMUserInfo.h"
#import "WMFoundCommentBottomView.h"
#import "WMFoundListInfo.h"
#import "WMFoundCommentHeaderView.h"
#import "WMFoundCommentViewController.h"
#import "WMShareActionSheet.h"

@interface WMFoundCommentListViewController ()<WMFoundCommentBottomViewDelegate,SeaNetworkQueueDelegate,WMFoundCommentListCellDelegate>

///网络请求
@property(nonatomic,strong) SeaNetworkQueue *queue;

///评论信息 数组元素是 WMFoundCommentInfo
@property(nonatomic,strong) NSMutableArray *infos;

///底部评论视图
@property(nonatomic,strong) WMFoundCommentBottomView *bottomView;

///发现信息
@property(nonatomic,strong) WMFoundListInfo *foundListInfo;

///表头
@property(nonatomic,strong) WMFoundCommentHeaderView *headerView;


@end

@implementation WMFoundCommentListViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (instancetype)initWithInfo:(WMFoundListInfo *)info
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.foundListInfo = [info copy];
        self.articleId = self.foundListInfo.Id;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    self.view.backgroundColor = [UIColor whiteColor];
    self.backItem = YES;
    
    if(self.foundListInfo)
    {
        self.title = self.foundListInfo.title;
    }
    
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStyleGrouped;
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMFoundCommentListCell" bundle:nil] forCellReuseIdentifier:@"WMFoundCommentListCell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.height -= WMFoundCommentBottomViewHeight;
    if (isIPhoneX) {
        self.tableView.height -= 35.0;
    }
    
    self.bottomView = [[WMFoundCommentBottomView alloc] init];
    self.bottomView.top = self.tableView.bottom;
    self.bottomView.info = self.foundListInfo;
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    self.enablePullUp = YES;
    
    [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
    
    self.headerView = [[WMFoundCommentHeaderView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.tableView.height / 3.0 * 2)];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.webView.delegate = self;
    
    [self.headerView.webView loadHTMLString:self.foundListInfo.foundHtml baseURL:nil];
}

#pragma mark- UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.height = 1;
    webView.height = webView.scrollView.contentSize.height;
    self.headerView.height = webView.height;
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.headerView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if(![url isEqualToString:@"about:blank"])
    {
        SeaWebViewController *web = [[SeaWebViewController alloc] initWithURL:url];
        web.backItem = YES;
        [self.navigationController pushViewController:web animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark- WMFoundCommentBottomView delegate

- (void)foundCommentBottomViewDidShare:(WMFoundCommentBottomView *)view
{
    WMShareActionSheet *share = [[WMShareActionSheet alloc] init];
    share.shareContentView.shareType = WMShareTypeFound;
    share.shareContentView.navigationController = self.navigationController;
    share.shareContentView.foundListInfo = self.foundListInfo;
    [share show];
}

- (void)foundCommentBottomViewDidPraise:(WMFoundCommentBottomView *)view
{
    if([AppDelegate instance].isLogin)
    {
        [self praise];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [self praise];
        }];
    }
}

- (void)foundCommentBottomViewDidComment:(WMFoundCommentBottomView *)view
{
    if([AppDelegate instance].isLogin)
    {
        [self comment];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [self comment];
        }];
    }
}

///点赞
- (void)praise
{
    self.foundListInfo.isPraised = !self.foundListInfo.isPraised;
    if(self.foundListInfo.isPraised)
    {
        self.foundListInfo.praisedCount ++;
    }
    else
    {
        self.foundListInfo.praisedCount --;
    }
    
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMFoundOperation foundPraiseParamWithInfo:self.foundListInfo] identifier:self.foundListInfo.Id];
    [self.queue startDownload];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMFoundDidPraiseNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.foundListInfo.Id, WMFoundListInfoIdKey, [NSNumber numberWithBool:self.foundListInfo.isPraised], WMFoundPraiseStatus, nil]];
    
    self.bottomView.praise_btn.selected = self.foundListInfo.isPraised;
    [self.bottomView.praise_btn setTitle:[NSString stringWithFormat:@" %d", self.foundListInfo.praisedCount] forState:UIControlStateNormal];
}

///评论
- (void)comment
{
    WMFoundCommentViewController *comment = [[WMFoundCommentViewController alloc] init];
    comment.info = self.foundListInfo;
    comment.commentCompletionHandler = ^(WMFoundCommentInfo *info){
        
        if(info)
        {
            [self.infos insertObject:info atIndex:0];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
        
        self.foundListInfo.commentCount ++;
        [self.bottomView.comment_btn setTitle:[NSString stringWithFormat:@" %d", self.foundListInfo.commentCount] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:WMFoundCommentDidAddNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.foundListInfo.Id, WMFoundListInfoIdKey, [NSNumber numberWithInt:self.foundListInfo.commentCount], WMFoundCommentCount, nil]];
    };
    
    [comment showInViewController:self];
}

#pragma mark- http

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
    if([identifier isEqualToString:WMFoundCommentListIdentifier])
    {
        if(self.loadMore)
        {
            [self endPullUpLoadingWithMoreInfo:YES];
            self.curPage --;
        }
        
        return;
    }
    
    if([identifier isEqualToString:WMFoundDetailIdentifier])
    {
        self.foundListInfo.foundHtml = nil;
        return;
    }
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    self.requesting = NO;
    
    if([identifier isEqualToString:WMFoundCommentListIdentifier])
    {
        long long totalSize = 0;
        NSArray *array = [WMFoundOperation foundCommentListFromData:data totalSize:&totalSize];
        if(array)
        {
            self.totalCount = totalSize;
            if(!self.infos)
            {
                self.infos = [NSMutableArray array];
            }
            [self.infos addObjectsFromArray:array];
            
            if(self.loadMore)
            {
                [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
            }
        }
        
        return;
    }
    
    if([identifier isEqualToString:WMFoundDetailIdentifier])
    {
        WMFoundListInfo *info = [WMFoundOperation foundDetailFromData:data];
        if(info)
        {
            if(self.foundListInfo)
            {
                self.foundListInfo.foundHtml = info.foundHtml;
                self.foundListInfo.URL = info.URL;
            }
            else
            {
                self.foundListInfo = info;
            }
            
            if(!self.title)
            {
                self.title = self.foundListInfo.title;
            }
        }
        return;
    }
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    if(self.infos && self.foundListInfo.foundHtml)
    {
        if(self.tableView)
        {
            [self.tableView reloadData];
        }
        else
        {
            [self initialization];
        }
    }
    else
    {
        [self failToLoadData];
    }
}

///加载评论列表
- (void)loadCommentList
{
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMFoundOperation foundCommentListParamWithArticleId:self.articleId pageIndex:self.curPage] identifier:WMFoundCommentListIdentifier];
    [self.queue startDownload];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadCommentList];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    self.infos = nil;
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMFoundOperation foundDetailWithArticleId:self.articleId] identifier:WMFoundDetailIdentifier];
    [self loadCommentList];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WMFoundCommentListCell rowHeightWithInfo:[self.infos objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMFoundCommentListCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark- WMFoundCommentListCell delegate

- (void)foundCommentListCellHeaderImageDidTap:(WMFoundCommentListCell *)cell
{
    
}

@end
