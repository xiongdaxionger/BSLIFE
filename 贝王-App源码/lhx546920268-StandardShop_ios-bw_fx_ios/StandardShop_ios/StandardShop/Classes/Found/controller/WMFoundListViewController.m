//
//  WMFoundListViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/4/1.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundListViewController.h"
#import "WMFoundViewController.h"
#import "WMFoundListInfo.h"
#import "WMFoundSingleImageCell.h"
#import "WMFoundFooterView.h"
#import "WMFoundHeaderView.h"
#import "WMFoundOperation.h"
#import "WMFoundCategoryInfo.h"
#import "WMQRCodeScanViewController.h"
#import "WMFoundCommentListViewController.h"

@interface WMFoundListViewController ()<SeaNetworkQueueDelegate,SeaHttpRequestDelegate,WMFoundFooterViewDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

@end

@implementation WMFoundListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.categorInfo.Id)
    {
        self.categorInfo = [[WMFoundCategoryInfo alloc] init];
        self.title = @"靓贴推荐";
        self.backItem = YES;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    if(self.categorInfo.infos)
    {
        self.categorInfo.infos = nil;
    }
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMFoundSingleImageCell" bundle:nil] forCellReuseIdentifier:@"WMFoundSingleImageCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = WMFoundBaseCellHeight;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    CGRect frame = self.tableView.frame;
    frame.size.height = _height_ - self.statusBarHeight - self.navigationBarHeight - (isIPhoneX ? 35.0 : 0.0);
    if(self.categorInfo.Id)
    {
        frame.size.height -= _SeaMenuBarHeight_;
    }
    self.tableView.frame = frame;
    
    self.enableDropDown = YES;
    self.enablePullUp = YES;
    
    ///添加评论监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundCommentDidAdd:) name:WMFoundCommentDidAddNotification object:nil];
    
    ///添加点赞监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundDidPraise:) name:WMFoundDidPraiseNotification object:nil];
    
    self.tableView.sea_shouldShowEmptyView = YES;
}

- (void)setLoading:(BOOL)loading
{
    [super setLoading:loading];
    
    if(self.categorInfo.Id)
    {
        self.loadingIndicator.height = _height_ - self.statusBarHeight - self.navigationBarHeight - _SeaMenuBarHeight_;
    }
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无信息";
}
#pragma mark- 通知

///添加评论
- (void)foundCommentDidAdd:(NSNotification*) notification
{
    NSString *Id = [[notification userInfo] objectForKey:WMFoundListInfoIdKey];
    int count = [[[notification userInfo] objectForKey:WMFoundCommentCount] intValue];
    
    if(Id)
    {
        if(self.infos)
        {
            for(WMFoundCategoryInfo *categoryInfo in self.infos)
            {
                for(WMFoundListInfo *info in categoryInfo.infos)
                {
                    if([info.Id isEqualToString:Id])
                    {
                        info.commentCount = count;
                    }
                }
            }
        }
        else
        {
            for(WMFoundListInfo *info in self.categorInfo.infos)
            {
                if([info.Id isEqualToString:Id])
                {
                    info.commentCount = count;
                }
            }
        }
        
        [self.tableView reloadData];
    }
}

///点赞
- (void)foundDidPraise:(NSNotification*) notification
{
    if(notification.object == self)
        return;
    NSString *Id = [[notification userInfo] objectForKey:WMFoundListInfoIdKey];
    BOOL praise = [[[notification userInfo] objectForKey:WMFoundPraiseStatus] boolValue];
    
    if(Id)
    {
        if(self.infos)
        {
            for(WMFoundCategoryInfo *categoryInfo in self.infos)
            {
                for(WMFoundListInfo *info in categoryInfo.infos)
                {
                    if([info.Id isEqualToString:Id] && info.isPraised != praise)
                    {
                        info.isPraised = praise;
                        if(info.isPraised)
                        {
                            info.praisedCount ++;
                        }
                        else
                        {
                            info.praisedCount --;
                        }
                    }
                }
            }
        }
        else
        {
            for(WMFoundListInfo *info in self.categorInfo.infos)
            {
                if([info.Id isEqualToString:Id] && info.isPraised != praise)
                {
                    info.isPraised = praise;
                    if(info.isPraised)
                    {
                        info.praisedCount ++;
                    }
                    else
                    {
                        info.praisedCount --;
                    }
                    break;
                }
            }
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMFoundListIdentifier])
    {
        if(self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
        }
        else if(self.loadMore)
        {
            [self endPullUpLoadingWithMoreInfo:YES];
            self.curPage --;
        }
        else
        {
            [self failToLoadData];
        }
        
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMFoundListIdentifier])
    {
        long long totalSize = 0;
        NSArray *infos = [WMFoundOperation foundListFromData:data totalSize:&totalSize];
        
        if(infos)
        {
            self.totalCount = totalSize;
            if(self.refreshing)
            {
                [self.categorInfo.infos removeAllObjects];
            }
            
            if(!self.categorInfo.infos)
            {
                self.categorInfo.infos = [NSMutableArray array];
            }
            
            [self.categorInfo.infos addObjectsFromArray:infos];
            
            if(self.tableView)
            {
                [self.tableView reloadData];
            }
            else
            {
                [self initialization];
            }
            
            if(self.refreshing)
            {
                self.curPage = WMHttpPageIndexStartingValue;
                [self endDropDownRefreshWithMsg:nil];
            }
            
            [self endPullUpLoadingWithMoreInfo:self.categorInfo.infos.count < self.totalCount];
        }
        else
        {
            if(self.refreshing)
            {
                [self endDropDownRefreshWithMsg:nil];
            }
            else if (self.loadMore)
            {
                [self endPullUpLoadingWithMoreInfo:YES];
                self.curPage --;
            }
            else
            {
                [self failToLoadData];
            }
        }

        
        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadFoundList];
}

- (void)beginDropDownRefresh
{
    [self loadFoundList];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadFoundList];
}

///加载发现列表
- (void)loadFoundList
{
    self.httpRequest.identifier = WMFoundListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMFoundOperation foundListParamWithCategoryInfo:self.categorInfo pageIndex:self.refreshing ? WMHttpPageIndexStartingValue : self.curPage]];
}

#pragma mark- queue

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFailWithError:(NSInteger)error identifier:(NSString *)identifier
{
    
}

- (void)networkQueue:(SeaNetworkQueue *)queue requestDidFinishWithData:(NSData *)data identifier:(NSString *)identifier
{
    
}

- (void)networkQueueDidFinish:(SeaNetworkQueue *)queue
{
    
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? WMFoundBaseCellMargin * 2 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return WMFoundFooterViewHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *footerIdentifier = @"footer";
    WMFoundFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    
    if(footer == nil)
    {
        footer = [[WMFoundFooterView alloc] initWithReuseIdentifier:footerIdentifier];
        footer.delegate = self;
    }
    
    WMFoundListInfo *info = [self.categorInfo.infos objectAtIndex:section];
    footer.info = info;
    footer.section = section;
    
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categorInfo.infos.count == 0 ? 0 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categorInfo.infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundListInfo *info = [self.categorInfo.infos objectAtIndex:indexPath.section];

    WMFoundBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMFoundSingleImageCell"forIndexPath:indexPath];

    cell.info = info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMFoundListInfo *info = [self.categorInfo.infos objectAtIndex:indexPath.section];
    WMFoundCommentListViewController *comment = [[WMFoundCommentListViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark- WMFoundFooterView delegate

- (void)foundFooterViewDidComment:(WMFoundFooterView *)view
{
    [self commentView:view];
}

- (void)foundFooterViewDidPraise:(WMFoundFooterView *)view
{
    if([AppDelegate instance].isLogin)
    {
        [self praiseView:view];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [self praiseView:view];
        }];
    }
}

///评论
- (void)commentView:(WMFoundFooterView*) view
{
    WMFoundListInfo *info = view.info;
    WMFoundCommentListViewController *comment = [[WMFoundCommentListViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:comment animated:YES];
}

///点赞
- (void)praiseView:(WMFoundFooterView*) view
{
    WMFoundListInfo *info = view.info;
    info.isPraised = !info.isPraised;
    if(info.isPraised)
    {
        info.praisedCount ++;
    }
    else
    {
        info.praisedCount --;
    }
    
    ///把其他列表中相同的信息点赞改成一致
    for(WMFoundCategoryInfo *categoryInfo in self.infos)
    {
        if([categoryInfo.Id isEqualToString:self.categorInfo.Id])
            continue;
        
        for(WMFoundListInfo *tmpInfo in categoryInfo.infos)
        {
            if([tmpInfo.Id isEqualToString:info.Id])
            {
                tmpInfo.praisedCount = info.praisedCount;
                tmpInfo.isPraised = info.isPraised;
                break;
            }
        }
    }
    
    view.footerContentView.praise_btn.selected = info.isPraised;
    [view.footerContentView.praise_btn setTitle:[NSString stringWithFormat:@" %d", info.praisedCount] forState:UIControlStateNormal];
    
    ///点赞
    [self.queue addRequestWithURL:SeaNetworkRequestURL param:[WMFoundOperation foundPraiseParamWithInfo:info] identifier:info.Id];
    [self.queue startDownload];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMFoundDidPraiseNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:info.Id, WMFoundListInfoIdKey, [NSNumber numberWithBool:info.isPraised], WMFoundPraiseStatus, nil]];
}

@end

