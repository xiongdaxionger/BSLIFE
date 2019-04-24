//
//  WMCollegeTableViewController.m
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/29.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollegeTableViewController.h"
#import "WMCollegeOperation.h"
#import "WMCollegeInfo.h"
#import "WMCollegeTableViewCell.h"
#import "WMCollegeDetailViewController.h"
#import "WMCollegeSearchViewController.h"

@interface WMCollegeTableViewController ()<SeaHttpRequestDelegate,WMCollegeCellDelegate,SeaMenuBarDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpReqeust;

/**学院分类信息，数组元素是 WMCollegeCategory
 */
@property(nonatomic,strong) NSArray *infos;

/**滑动菜单
 */
@property(nonatomic,strong) SeaMenuBar *menuBar;

///上一个选中的
@property(nonatomic,assign) NSInteger selectedIndex;

@end

@implementation WMCollegeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    [self setBackItem:YES];
    
    self.httpReqeust = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self reloadDataFromNetwork];
    
    self.title = @"学院";
}

- (void)reloadDataFromNetwork
{
    if(self.infos)
    {
        [self loadCollegeInfo];
    }
    else
    {
        self.loading = YES;
        ///获取学院分类列表
        self.httpReqeust.identifier = WMCollegeCategoryIdentifier;
        [self.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMCollegeOperation collegeCategoryListParams]];
    }
}

///获取学院信息
- (void)loadCollegeInfo
{
    if(!self.refreshing && !self.loadMore && !self.loading)
    {
        self.requesting = YES;
        self.showNetworkActivity = YES;
    }
    
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    self.httpReqeust.identifier = WMCollegeListIdentifier;
    [self.httpReqeust downloadWithURL:SeaNetworkRequestURL dic:[WMCollegeOperation collegeListParamsWithCategoryId:info.Id keyword:nil pageIndex:self.refreshing ? WMHttpPageIndexStartingValue : info.curPage pageSize:WMCollegePageSize]];
}

- (void)initialization
{
  //  [self setBarItemsWithTitle:nil icon:[UIImage imageNamed:@"search_nav_icon"] action:@selector(search:) position:SeaNavigationItemPositionRight];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.infos.count];
    for(WMCollegeCategoryInfo *info in self.infos)
    {
        [titles addObject:info.name];
    }
    
    _menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titles style:SeaMenuBarStyleItemWithRelateTitle];
    _menuBar.buttonInterval = 20.0;
    _menuBar.contentInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    _menuBar.topSeparatorLine.hidden = YES;
    _menuBar.selectedColor = [UIColor blackColor];
    _menuBar.titleFont = [UIFont fontWithName:MainFontName size:15.0];
    _menuBar.delegate = self;
    [self.view addSubview:_menuBar];
    
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCollegeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    CGRect frame = self.tableView.frame;
    frame.origin.y = _menuBar.bottom;
    frame.size.height = self.contentHeight - _menuBar.bottom;
    self.tableView.frame = frame;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.enableDropDown = YES;
    self.enablePullUp = YES;
    
    self.tableView.sea_shouldShowEmptyView = YES;
}

///搜索
- (void)search:(id) sender
{
    WMCollegeSearchViewController *search = [[WMCollegeSearchViewController alloc] init];
    search.categoryInfo = [self.infos firstObject];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    if(self.infos.count > 0)
    {
        WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
        view.textLabel.text = [NSString stringWithFormat:@"暂无%@信息", info.name];
    }
    else
    {
        view.textLabel.text = [NSString stringWithFormat:@"暂无%@信息", self.title];
    }
}

- (void)failToLoadData
{
    [super failToLoadData];
    
    self.badNetworkRemindView.frame = CGRectMake(0, self.menuBar.bottom, _width_, self.contentHeight - self.menuBar.height);
}

- (void)beginDropDownRefresh
{
    [self loadCollegeInfo];
}

- (void)beginPullUpLoading
{
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    info.curPage ++;
    [self loadCollegeInfo];
}


#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    
    if(self.refreshing)
    {
        [self endDropDownRefreshWithMsg:nil];
    }
    else if (self.loadMore)
    {
        info = [self.infos objectAtIndex:self.selectedIndex];
        info.curPage --;
    }
    
    [self.tableView reloadData];
    if(info.infos)
    {
        [self endPullUpLoadingWithMoreInfo:info.infos.count != 0 && info.infos.count % WMCollegePageSize == 0];
    }
    else
    {
        self.tableView.sea_shouldShowEmptyView = NO;
        [self endPullUpLoadingWithMoreInfo:NO];
        [self loadCollegeInfo];
    }
    
    self.selectedIndex = self.menuBar.selectedIndex;
}

#pragma mark - SeaHttpRequestDelegate

/**请求失败
 */
- (void)httpRequest:(SeaHttpRequest*) request didFailed:(NSInteger) error
{
    if([request.identifier isEqualToString:WMCollegeCategoryIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMCollegeListIdentifier])
    {
        self.showNetworkActivity = NO;
        self.requesting = NO;
        
        if(!self.loadMore)
        {
            [self failToLoadData];
        }
        else
        {
            WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
            info.curPage --;
            [self endPullUpLoadingWithMoreInfo:YES];
        }
    }
    
    return;
}

/**请求完成
 */
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData*) data
{
    if([request.identifier isEqualToString:WMCollegeCategoryIdentifier])
    {
        self.infos = [WMCollegeOperation collegeCategoryListFromData:data];
        
        if(self.infos.count == 0)
        {
            self.loading = NO;
        }
        else
        {
            [self loadCollegeInfo];
        }
        return;
    }
    
    if([request.identifier isEqualToString:WMCollegeListIdentifier])
    {
        self.showNetworkActivity = NO;
        self.requesting = NO;
        self.loading = NO;
        
        WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
        NSArray *infos = [WMCollegeOperation collegeListFromData:data];
        if(!info.infos)
        {
            info.infos = [NSMutableArray arrayWithCapacity:infos.count];
        }
        
        if(self.refreshing)
        {
            info.curPage = WMHttpPageIndexStartingValue;
            [info.infos removeAllObjects];
        }
        
        [info.infos addObjectsFromArray:infos];
        
        if(self.tableView)
        {
            if(self.refreshing)
            {
                [self endDropDownRefreshWithMsg:nil];
            }

            self.tableView.sea_shouldShowEmptyView = YES;
            [self.tableView reloadData];
        }
        else
        {
            [self initialization];
        }

        
        [self endPullUpLoadingWithMoreInfo:infos.count >= WMCollegePageSize];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.infos.count == 0)
        return 0;
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    return info.infos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    WMCollegeInfo *college = info.infos[indexPath.row];
    
    CGFloat height = [WMCollegeTableViewCell rowHeightForInfo:college];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    WMCollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    cell.info = [info.infos objectAtIndex:indexPath.row];
   // cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    WMCollegeCategoryInfo *info = [self.infos objectAtIndex:self.menuBar.selectedIndex];
    WMCollegeInfo *college = info.infos[indexPath.row];
    
    WMCollegeDetailViewController *detail = [[WMCollegeDetailViewController alloc] initWithInfo:college];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark- WMCollegeTableViewCell delegate

- (void)collegeCellDidLookDetail:(WMCollegeTableViewCell *)cell
{
    
    
}

@end
