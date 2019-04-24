//
//  WMMessageSystemViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageSystemViewController.h"
#import "WMMessageInfo.h"
#import "WMMessageOperation.h"
#import "WMMessageSystemGoodListCell.h"
#import "WMGoodCommentListCell.h"
#import "WMGoodDetailContainViewController.h"
#import "WMMessageCenterInfo.h"
#import "WMMessageOperation.h"
#import "WMMessageSystemReplyListCell.h"
#import "WMMessageConsultHeaderViewCell.h"
#import "WMMessageConsultQuestionViewCell.h"
#import "WMAdviceContentViewCell.h"
#import "WMAdviceReplyViewCell.h"
#import "WMMoreAdviceViewCell.h"
#import "WMUserInfo.h"

@interface WMMessageSystemViewController ()<WMGoodCommentListCellDelegate,SeaMenuBarDelegate,SeaHttpRequestDelegate,SeaNetworkQueueDelegate>
{
    ///消息 数组元素是 WMMessageInfo 或其子类
    NSMutableArray *_infos;
}
///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///消息 数组元素是 WMMessageInfo 或其子类
@property(nonatomic,strong) NSMutableArray *infos;

///菜单栏
@property(nonatomic,strong) SeaMenuBar *menuBar;

///请求队列
@property(nonatomic,strong) SeaNetworkQueue *queue;

@end

@implementation WMMessageSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.title = self.info.name;
    
    self.queue = [[SeaNetworkQueue alloc] initWithDelegate:self];
    
    ///清除旧的消息
    for(WMMessageCenterSubInfo *info in self.info.subMessages)
    {
        info.infos = nil;
    }
    
    self.info.selectedSubInfo = [self.info.subMessages firstObject];
    
    if(self.info.subMessages.count < 2)
    {
        self.infos = [NSMutableArray array];
    }
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    self.style = UITableViewStyleGrouped;
    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodCommentListCell" bundle:nil] forCellReuseIdentifier:@"WMGoodCommentListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageSystemReplyListCell" bundle:nil]forCellReuseIdentifier:@"WMMessageSystemReplyListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageSystemGoodListCell" bundle:nil] forCellReuseIdentifier:@"WMMessageSystemGoodListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageConsultHeaderViewCell" bundle:nil] forCellReuseIdentifier:@"WMMessageConsultHeaderViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMessageConsultQuestionViewCell" bundle:nil] forCellReuseIdentifier:@"WMMessageConsultQuestionViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAdviceContentViewCell" bundle:nil] forCellReuseIdentifier:WMAdviceContentViewCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAdviceReplyViewCell" bundle:nil] forCellReuseIdentifier:WMAdviceReplyViewCellIden];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMMoreAdviceViewCell" bundle:nil] forCellReuseIdentifier:WMMoreAdviceViewCellIdentifier];
    
    
    ///菜单
    if(self.info.subMessages.count > 1)
    {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.info.subMessages.count];
        for(WMMessageCenterSubInfo *info in self.info.subMessages)
        {
            [titles addObject:info.name];
        }
        
        self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titles style:self.info.subMessages.count > 4 ? SeaMenuBarStyleItemWithRelateTitle : SeaMenuBarStyleItemWithRelateTitleInFullScreen];
        self.menuBar.delegate = self;
        [self.view addSubview:self.menuBar];
        
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.menuBar.bottom;
        frame.size.height -= self.menuBar.bottom;
        if (isIPhoneX) {
            frame.size.height -= 35.0;
        }
        self.tableView.frame = frame;
    }
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.enablePullUp = YES;
}

- (void)setInfos:(NSMutableArray *)infos
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        
        info.infos = infos;
    }
    else
    {
        _infos = infos;
    }
}

- (long long)totalCount
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        return info.count;
    }
    
    return [super totalCount];
}

- (void)setTotalCount:(long long)totalCount
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        info.count = totalCount;
    }
    else
    {
        [super setTotalCount:totalCount];
    }
}

- (NSMutableArray*)infos
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];

        return info.infos;
    }
    
    return _infos;
}

- (int)curPage
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        return info.curPage;
    }
    else
    {
       return [super curPage];
    }
}

- (void)setCurPage:(int)curPage
{
    if(self.info.subMessages.count > 0)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        info.curPage = curPage;
    }
    else
    {
        [super setCurPage:curPage];
    }
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    NSString *msg = nil;
    if(self.menuBar.selectedIndex < self.info.subMessages.count)
    {
        WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:self.menuBar.selectedIndex];
        msg = info.name;
    }
    
    if(!msg)
    {
        msg = @"消息";
    }
    
    view.textLabel.text = [NSString stringWithFormat:@"暂无%@", msg];
}

#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    self.info.selectedSubInfo.offset = self.tableView.contentOffset;
    WMMessageCenterSubInfo *info = [self.info.subMessages objectAtIndex:index];
    self.info.selectedSubInfo = info;
    
    [self.tableView reloadData];
    
    if(!info.infos)
    {
        [self endPullUpLoadingWithMoreInfo:NO];
        self.tableView.sea_shouldShowEmptyView = NO;
        self.showNetworkActivity = YES;
        self.requesting = YES;
        [self loadInfo];
    }
    else
    {
        self.tableView.contentOffset = self.info.selectedSubInfo.offset;
        [self endPullUpLoadingWithMoreInfo:self.infos.count < self.totalCount];
    }
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    if(self.loadMore)
    {
        [self endPullUpLoadingWithMoreInfo:YES];
        self.curPage --;
    }
    else if(!self.tableView)
    {
        [self failToLoadData];
    }
    else
    {
        self.tableView.sea_shouldShowEmptyView = YES;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    
    long long totalSize = 0;
    
    NSArray *infos = [WMMessageOperation messageListFromData:data info:self.info totalSize:&totalSize];
    if(infos)
    {
        self.totalCount = totalSize;
        
        if(!self.infos)
        {
            self.infos = [NSMutableArray array];
        }
        
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

    self.tableView.sea_shouldShowEmptyView = YES;
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

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 10.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WMMessageSystemInfo *info = [self.infos objectAtIndex:section];

    return info.numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageSystemInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    switch (indexPath.row)
    {
        case 0 :
        {
            if (info.subtype == WMMessageSystemInfoConsult) {
                
                return WMMessageConsultHeaderViewCellHeight;
            }
            else{
                
                if(info.goodInfo)
                {
                    return WMMessageSystemGoodListCellHeight;
                }
            }
        }
        default:
        {
            switch (info.subtype)
            {
                case WMMessageSubtypeSystem :
                {
                    return [WMMessageSystemReplyListCell rowHeightForInfo:info];
                }
                    break;
                case WMMessageSystemInfoConsult :
                {
                    if (indexPath.row == 1) {
                        
                        return WMMessageSystemGoodListCellHeight;
                    }
                    else if(indexPath.row == 2){
                        
                        return [info.adviceQuestionInfo returnContentHeightCanReply:NO];
                    }
                    else{
                        
                        NSInteger maxCount = 0;
                        
                        if (info.adviceQuestionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
                            
                            if (info.adviceQuestionInfo.isShowMoreOpen) {
                                
                                maxCount = info.adviceQuestionInfo.adviceAnswerInfoArr.count;
                            }
                            else{
                                
                                maxCount = WMShowMoreInfoMaxCount;
                            }
                        }
                        else{
                            
                            maxCount = info.adviceQuestionInfo.adviceAnswerInfoArr.count;
                        }
                        
                        if(indexPath.row > 2 && indexPath.row < maxCount + 3){
                            
                            WMAdviceContentInfo *answerInfo = [info.adviceQuestionInfo.adviceAnswerInfoArr objectAtIndex:indexPath.row - 3];
                            
                            return [answerInfo returnContentHeight];
                        }
                        else{
                            
                            return WMMoreAdviceViewCellHeight;
                        }
                    }
                }
                    break;
                case WMMessageSystemInfoGoodComment :
                {
                    return [WMGoodCommentListCell rowHeightForInfo:info.goodCommentInfo];
                }
                    break;
                default:
                    break;
            }
        }
            break;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageSystemInfo *info = [self.infos objectAtIndex:indexPath.section];

    UITableViewCell *tmp;
    
    switch (indexPath.row)
    {
        case 0 :
        {
            if (info.subtype == WMMessageSystemInfoConsult) {
                
                WMMessageConsultHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageConsultHeaderViewCell" forIndexPath:indexPath];
                
                [cell configureWithTypeString:info.adviceQuestionInfo.adviceID timeString:info.adviceQuestionInfo.adviceTime];
                
                tmp = cell;
                
                break;
            }
            else{
                
                if(info.goodInfo)
                {
                    WMMessageSystemGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageSystemGoodListCell" forIndexPath:indexPath];
                    cell.info = info.goodInfo;
                    tmp = cell;
                    break;
                }
            }
        }
        default:
        {
            switch (info.subtype)
            {
                case WMMessageSystemInfoGoodComment :
                {
                    WMGoodCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMGoodCommentListCell" forIndexPath:indexPath];
                    cell.info = info.goodCommentInfo;
                    cell.delegate = self;
                    cell.reply_btn.hidden = YES;

                    tmp = cell;
                }
                    break;
                case WMMessageSystemInfoConsult :
                {
                    if (indexPath.row == 1) {
                        
                        WMMessageSystemGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageSystemGoodListCell" forIndexPath:indexPath];
                        
                        cell.info = info.goodInfo;
                        
                        tmp = cell;
                    }
                    else if(indexPath.row == 2){
                        
                        WMMessageConsultQuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageConsultQuestionViewCell" forIndexPath:indexPath];
                        
                        [cell configureWithContentString:info.adviceQuestionInfo.adviceContent];
                        
                        tmp = cell;
                    }
                    else{
                        
                        NSInteger maxCount = 0;
                        
                        if (info.adviceQuestionInfo.adviceAnswerInfoArr.count > WMShowMoreInfoMaxCount) {
                            
                            if (info.adviceQuestionInfo.isShowMoreOpen) {
                                
                                maxCount = info.adviceQuestionInfo.adviceAnswerInfoArr.count;
                            }
                            else{
                                
                                maxCount = WMShowMoreInfoMaxCount;
                            }
                        }
                        else{
                            
                            maxCount = info.adviceQuestionInfo.adviceAnswerInfoArr.count;
                        }
                        
                        if(indexPath.row > 2 && indexPath.row < maxCount + 3){
                            
                            WMAdviceContentInfo *answerInfo = [info.adviceQuestionInfo.adviceAnswerInfoArr objectAtIndex:indexPath.row - 3];
                            
                            WMAdviceReplyViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:WMAdviceReplyViewCellIden forIndexPath:indexPath];
                            
                            [contentCell configureCellWithModel:answerInfo];
                            
                            tmp = contentCell;
                        }
                        else{
                            
                            WeakSelf(self);
                            
                            WMMoreAdviceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WMMoreAdviceViewCellIdentifier forIndexPath:indexPath];
                            
                            [cell setCallBack:^(UITableViewCell *moreCell) {
                               
                                NSIndexPath *selectIndexPath = [weakSelf.tableView indexPathForCell:moreCell];
                                
                                WMMessageSystemInfo *info = [weakSelf.infos objectAtIndex:selectIndexPath.section];
                                
                                info.adviceQuestionInfo.isShowMoreOpen = !info.adviceQuestionInfo.isShowMoreOpen;

                                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                            }];
                            
                            [cell configureCellWithModel:info.adviceQuestionInfo];
                            
                            tmp = cell;
                        }
                    }
                }
                    break;
                case WMMessageSubtypeSystem :
                {
                    WMMessageSystemReplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMMessageSystemReplyListCell" forIndexPath:indexPath];
                    cell.info = info;
                    tmp = cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
    }

    return tmp;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageSystemInfo *info = [self.infos objectAtIndex:indexPath.section];
    [self markReadMessageInfo:info];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMMessageSystemInfo *info = [self.infos objectAtIndex:indexPath.section];

    NSInteger index = 0;
    
    if (info.subtype == WMMessageSystemInfoConsult) {
        
        index = 1;
    }
    else{
        
        index = 0;
    }
    
    if (index == indexPath.row) {
        
        if (info.goodInfo) {
            
            WMGoodDetailContainViewController *container = [[WMGoodDetailContainViewController alloc] init];
            container.productID = info.goodInfo.productId;
            container.goodID = info.goodInfo.goodId;
            [self.navigationController pushViewController:container animated:YES];
        }
    }
}

#pragma mark- WMGoodCommentListCell delegate

- (void)goodCommentListCellDidReply:(WMGoodCommentListCell *)cell
{
   
}

- (void)goodCommentListCellExpandStateDidChange:(WMGoodCommentListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
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

@end
