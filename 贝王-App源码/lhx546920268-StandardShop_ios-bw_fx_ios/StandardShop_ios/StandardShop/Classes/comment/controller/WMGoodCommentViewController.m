//
//  WMGoodCommentViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentViewController.h"
#import "WMGoodCommentOverallInfo.h"
#import "WMGoodCommentListCell.h"
#import "WMGoodCommentHeaderView.h"
#import "WMGoodCommentInfo.h"
#import "WMGridImageView.h"
#import "WMCommentOperation.h"
#import "WMGoodCommentReplyViewController.h"

@interface WMGoodCommentViewController ()<SeaMenuBarDelegate,SeaHttpRequestDelegate,WMGoodCommentListCellDelegate>

///头部
@property(nonatomic,strong) WMGoodCommentHeaderView *header;

///评论菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///总评信息
@property(nonatomic,strong) WMGoodCommentOverallInfo *info;

///评论信息 数组元素是 WMGoodCommentInfo
@property(nonatomic,strong) NSMutableArray *infos;

///可见的视图，数组元素是 UIImageView 用来复用的
@property(nonatomic,strong) NSMutableSet *visibleCells;

///留在复用的视图，数组元素是 UIImageView 用来复用的
@property(nonatomic,strong) NSMutableSet *reusedCells;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///商品Id
@property(nonatomic,copy) NSString *goodId;

@end

@implementation WMGoodCommentViewController

/**构造方法
 *@param goodId 商品id
 *@return 一个实例
 */
- (instancetype)initWithGoodId:(NSString*) goodId
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.goodId = goodId;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.infos = [NSMutableArray array];
    self.visibleCells = [NSMutableSet set];
    self.reusedCells = [NSMutableSet set];

    self.title = @"商品评价";
    self.backItem = YES;

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    self.style = UITableViewStyleGrouped;

    [super initialization];

    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodCommentListCell" bundle:nil] forCellReuseIdentifier:@"WMGoodCommentListCell"];


    self.header = [[WMGoodCommentHeaderView alloc] init];
    self.header.info = self.info;
    self.tableView.tableHeaderView = self.header;

    self.tableView.backgroundColor = self.view.backgroundColor;
    self.enablePullUp = YES;
    self.tableView.sea_emptyViewInsets = UIEdgeInsetsMake(self.info.filterInfos.count > 0 ? 55.0 : 0, 0, 0, 0);
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无商品评价";
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
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
        self.requesting = NO;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    long long totalSize = 0;
    WMGoodCommentOverallInfo *info = nil;
    NSArray *infos = [WMCommentOperation goodCommentListFromData:data overallInfo:self.info == nil ? &info : nil totalSize:&totalSize];

    if(infos)
    {
        if(info)
        {
            self.info = info;
        }

        [self.infos addObjectsFromArray:infos];
        
        self.totalCount = totalSize;
        if(self.menuBar.selectedIndex < self.info.filterInfos.count)
        {
            WMGoodCommentFilterInfo *info = [self.info.filterInfos objectAtIndex:self.menuBar.selectedIndex];
            self.totalCount = info.count;
        }
        

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
    else
    {
        if(self.loadMore)
        {
            [self endPullUpLoadingWithMoreInfo:YES];
            self.curPage --;
        }
        else if(!self.tableView)
        {
            [self failToLoadData];
        }
    }
    
    self.tableView.sea_shouldShowEmptyView = YES;
}

///加载评价信息
- (void)loadInfo
{
    NSString *type = nil;
    if(self.menuBar.selectedIndex < self.info.filterInfos.count)
    {
        WMGoodCommentFilterInfo *info = [self.info.filterInfos objectAtIndex:self.menuBar.selectedIndex];
        type = info.value;
    }
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCommentOperation goodCommentListParamsWithGoodId:self.goodId pageIndex:self.curPage filter:type]];
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

#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    [self endPullUpLoadingWithMoreInfo:NO];
    self.tableView.sea_shouldShowEmptyView = NO;
    self.curPage = WMHttpPageIndexStartingValue;
    [self.infos removeAllObjects];
    [self.tableView reloadData];
    
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    [self loadInfo];
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.info.filterInfos.count > 0 ? 55.0 : CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.info.filterInfos.count > 0)
    {
        if(!self.menuBar)
        {
            NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.info.filterInfos.count];
            for(WMGoodCommentFilterInfo *info in self.info.filterInfos)
            {
                [titles addObject:[NSString stringWithFormat:@"%@\n(%lld)", info.name, info.count]];
            }

            self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, 55.0) titles:titles style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
            self.menuBar.delegate = self;
        }
        
        self.menuBar.separatorLine.hidden = self.infos.count > 0;
        
        return self.menuBar;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WMGoodCommentListCell rowHeightForInfo:[self.infos objectAtIndex:indexPath.row]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMGoodCommentListCell"];
    cell.grid_imageView.visibleCells = self.visibleCells;
    cell.grid_imageView.reusedCells = self.reusedCells;
    cell.info = [self.infos objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.reply_btn.hidden = !self.info.enableReply;

    return cell;
}

#pragma mark- WMGoodCommentListCell delegate

- (void)goodCommentListCellDidReply:(WMGoodCommentListCell *)cell
{
    ///评论回复
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if([AppDelegate instance].isLogin)
    {
        [self replyCommentForIndexPath:indexPath];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
           
            [self replyCommentForIndexPath:indexPath];
        }];
    }
}

- (void)goodCommentListCellExpandStateDidChange:(WMGoodCommentListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

///回复评价
- (void)replyCommentForIndexPath:(NSIndexPath*) indexPath
{
    WMGoodCommentReplyViewController *reply = [[WMGoodCommentReplyViewController alloc] init];
    reply.info = [self.infos objectAtIndex:indexPath.row];
    reply.codeURL = self.info.codeURL;
    
    WeakSelf(self);
    reply.replyCompletionHandler = ^(WMGoodCommentInfo *info){
        
        if(info)
        {
            info.expand = YES;
            [weakSelf.infos replaceObjectAtIndex:indexPath.row withObject:info];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView endUpdates];
        }
    };
    
    [reply showInViewController:self];
}

@end
