//
//  WMPartnerListViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerListViewController.h"
#import "WMPartnerOperation.h"
#import "WMPartnerLevelView.h"
#import "WMPartnerInfo.h"
#import "WMPartnerListCell.h"
#import "SeaDropDownMenu.h"
#import "WMPartnerDetailViewController.h"
#import "WMPartnerLevelInfo.h"
#import "WMPartnerListSearchViewController.h"
#import "WMAddPartnerListViewController.h"

@interface WMPartnerListViewController ()<SeaHttpRequestDelegate,SeaDropDownMenuDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///下拉菜单
@property(nonatomic,strong) SeaDropDownMenu *dropdownMenu;

///会员数据 数组元素是 WMPartnerInfo
@property(nonatomic,strong) NSMutableArray *infos;

///会员等级信息 数组元素是 WMPartnerLevelInfo
@property(nonatomic,strong) NSMutableArray *levelInfos;

///当前选择的等级信息
@property(nonatomic,strong) WMPartnerLevelInfo *selectedLevelInfo;

///当前排序
@property(nonatomic,assign) WMPartnerListOrderBy orderBy;

///分销层级
@property(nonatomic,assign) int hierarchy;

@end

@implementation WMPartnerListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if([NSString isEmpty:self.title])
    {
        self.title = @"我的会员";
    }
    
    self.backItem = YES;
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    self.infos = [NSMutableArray array];
    
    ///搜索和添加会员
    UIBarButtonItem *item1 = [self itemWithButtonWithType:SeaButtonTypeAdd action:@selector(addPartner)];
    UIBarButtonItem *item2 = [self barButtonItemWithTitle:nil icon:[UIImage imageNamed:@"search_nav_icon"] action:@selector(search)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 20.0;
    
    [self setBarItems:[NSArray arrayWithObjects:item1, spaceItem, item2, nil] position:SeaNavigationItemPositionRight];
    
    ///注册升级成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partnerLeveupDidSuccess:) name:WMPartnerLevelupSuccessNotification object:nil];
    
    ///添加会员
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partnerDidAdd:) name:WMPartnerDidAddNotification object:nil];
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    self.separatorEdgeInsets = UIEdgeInsetsZero;
    
    if(self.totalCount > 0)
    {
        self.title = [NSString stringWithFormat:@"%@(%d)", self.title, (int)self.totalCount];
    }
    
//    if(!self.searchKey)
//    {
//        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.levelInfos.count];
//        for(WMPartnerLevelInfo *info in self.levelInfos)
//        {
//            [titles addObject:info.levelName];
//        }
//        
//        NSMutableArray *items = [NSMutableArray arrayWithCapacity:2];
//        SeaDropDownMenuItem *item = [[SeaDropDownMenuItem alloc] init];
//        item.titleLists = titles;
//        [items addObject:item];
//        
//        item = [[SeaDropDownMenuItem alloc] init];
//        item.titleLists = [NSArray arrayWithObjects:@"默认排序", @"收益排序", @"团队排序", nil];
//        [items addObject:item];
//        
//        self.dropdownMenu = [[SeaDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, _width_, SeaDropDownMenuHeight) items:items];
//        self.dropdownMenu.delegate = self;
//        self.dropdownMenu.listHighLightColor = [UIColor blackColor];
//        self.dropdownMenu.buttonHighlightTitleColor = [UIColor blackColor];
//        self.dropdownMenu.buttonNormalTitleColor = [UIColor grayColor];
//        self.dropdownMenu.keepHighlightWhenDismissList = NO;
//        [self.view addSubview:self.dropdownMenu];
//    }
    
    [super initialization];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMPartnerListCell" bundle:nil] forCellReuseIdentifier:@"WMPartnerListCell"];
    self.tableView.rowHeight = WMPartnerListCellHeight;
    self.tableView.backgroundColor = self.view.backgroundColor;
    CGRect frame = self.tableView.frame;
    frame.origin.y = self.dropdownMenu.bottom;
    frame.size.height -= frame.origin.y;
    if (isIPhoneX) {
        frame.size.height -= 35.0;
    }
    self.tableView.frame = frame;
    
    self.enablePullUp = YES;
    self.tableView.sea_shouldShowEmptyView = YES;
    
    if(!self.searchKey)
    {
        self.enableDropDown = YES;
    }
}

///搜索
- (void)search
{
    WMPartnerListSearchViewController *search = [[WMPartnerListSearchViewController alloc] init];
    search.selectPartnerHandler = self.selectPartnerHandler;
    [self.navigationController pushViewController:search animated:YES];
}

///添加会员
- (void)addPartner
{
    WMAddPartnerListViewController *list = [[WMAddPartnerListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无会员信息";
}

#pragma mark- 通知

///会员升级成功，改变筛选列表信息，会员列表信息
- (void)partnerLeveupDidSuccess:(NSNotification*) notification
{
    NSDictionary *dic = [notification userInfo];
    
    WMPartnerLevelInfo *info = [dic objectForKey:WMPartnerLevelInfoKey];
    NSString *userId = [dic objectForKey:WMPartnerInfoUserId];
    
    if(!info.levelName || !userId)
        return;
    
    ///是否存在该等级
    BOOL existLevel = NO;
    
    for(WMPartnerLevelInfo *levelInfo in self.levelInfos)
    {
        if([info.levelId isEqual:levelInfo.levelId])
        {
            existLevel = YES;
            break;
        }
    }
    
    ///插入新的等级信息
    if(!existLevel)
    {
        [self.levelInfos addObject:info];
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.levelInfos.count];
        for(WMPartnerLevelInfo *info in self.levelInfos)
        {
            [titles addObject:info.levelName];
        }
        SeaDropDownMenuItem *item = [self.dropdownMenu.items firstObject];
        item.titleLists = titles;
        [self.dropdownMenu closeList];
    }
    
    ///刷新列表
    for(NSInteger i = 0;i < self.infos.count;i ++)
    {
        WMPartnerInfo *info1 = [self.infos objectAtIndex:i];
        if([info1.userInfo.userId isEqualToString:userId])
        {
            info1.userInfo.levelNumber = info.levelId;
            info1.userInfo.level = info.levelName;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            break;
        }
    }
}

///添加会员成功
- (void)partnerDidAdd:(NSNotification*) notification
{
    [self.refreshControl beginRefresh];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.loading = NO;
    self.requesting = NO;
    
    if([request.identifier isEqualToString:WMPartnerLevelListIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMPartnerInfoListIdentifier])
    {
        if(!self.loadMore)
        {
            [self failToLoadData];
            [self.infos removeAllObjects];
            [self.tableView reloadData];
            [self endPullUpLoadingWithMoreInfo:NO];
        }
        else if (self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
        }
        else
        {
            self.curPage --;
            [self endPullUpLoadingWithMoreInfo:YES];
        }
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMPartnerLevelListIdentifier])
    {
        self.levelInfos = [WMPartnerOperation partnerLevelListFromData:data];
        self.selectedLevelInfo = [self.levelInfos firstObject];
        
        [self loadInfo];
        
        return;
    }
    
    if([request.identifier isEqualToString:WMPartnerInfoListIdentifier])
    {
        self.loading = NO;
        self.requesting = NO;
        
        long long totalSize = 0;
        int hierarchy = 0;
        NSArray *infos = [WMPartnerOperation partnerInfoListFromData:data totalSize:&totalSize hierarchy:&hierarchy];
        
        if(infos)
        {
            if(self.refreshing)
            {
                [self.infos removeAllObjects];
                self.curPage = WMHttpPageIndexStartingValue;
            }
            
            self.hierarchy = hierarchy;
            self.totalCount = totalSize;
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
        else if(self.loadMore)
        {
            self.curPage --;
            [self endPullUpLoadingWithMoreInfo:YES];
        }
        else
        {
            [self failToLoadData];
        }
        
        if(self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
        }
        
        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
//    if(!self.levelInfos && !self.searchKey)
//    {
//        [self loadLevelInfo];
//    }
//    else
//    {
        [self setHasNoMsgViewHidden:YES msg:nil];
        self.curPage = WMHttpPageIndexStartingValue;
        [self endPullUpLoadingWithMoreInfo:NO];
        [self loadInfo];
        [self.infos removeAllObjects];
        [self.tableView reloadData];
//    }
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
}

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

///加载会员信息
- (void)loadInfo
{
    self.httpRequest.identifier = WMPartnerInfoListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation partnerInfoListParamWithUserId:[WMUserInfo sharedUserInfo].userId pageIndex:self.refreshing ? WMHttpPageIndexStartingValue : self.curPage levelInfo:self.selectedLevelInfo orderBy:self.orderBy keyword:self.searchKey]];
}

///加载等级信息
- (void)loadLevelInfo
{
    self.httpRequest.identifier = WMPartnerLevelListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMPartnerOperation partnerLevelListParam]];
}

///刷新数据
- (void)refreshManually
{
    self.levelInfos = nil;
    [self reloadDataFromNetwork];
}

#pragma mark- SeaDropDownMenu delegate

- (BOOL)dropDownMenu:(SeaDropDownMenu *)menu shouldShowListInItem:(SeaDropDownMenuItem *)item
{
    return YES;
}

- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItemWithSecondMenu:(SeaDropDownMenuItem *)item
{
    switch (item.itemIndex)
    {
        case 0 :
        {
            ///筛选
            WMPartnerLevelInfo *info = [self.levelInfos objectAtIndex:item.selectedIndex];
            if(![info.levelId isEqualToString:self.selectedLevelInfo.levelId])
            {
                self.selectedLevelInfo = info;
                [self reloadData];
            }
        }
            break;
        case  1 :
        {
            ///排序
            WMPartnerListOrderBy orderBy = WMPartnerListOrderByDefault;
            switch (item.selectedIndex)
            {
                case 1 :
                {
                    orderBy = WMPartnerListOrderByIncome;
                }
                    break;
                case 2 :
                {
                    orderBy = WMPartnerListOrderByTeam;
                }
                    break;
                default:
                    break;
            }
            
            if(orderBy != self.orderBy)
            {
                self.orderBy = orderBy;
                [self reloadData];
            }
        }
            break;
        default:
            break;
    }
}

///重新加载数据
- (void)reloadData
{
    [self.infos removeAllObjects];
    [self.tableView reloadData];
    [self endPullUpLoadingWithMoreInfo:NO];
    self.requesting = YES;
    self.showNetworkActivity = YES;
    self.curPage = WMHttpPageIndexStartingValue;
    [self loadInfo];
}

#pragma mark- UITableView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.partnerListSearchViewController.searchBar resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _infos.count > 0 ? 10.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMPartnerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMPartnerListCell" forIndexPath:indexPath];
    cell.info = [_infos objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMPartnerInfo *info = [_infos objectAtIndex:indexPath.row];
    
    if(self.selectPartnerHandler)
    {
        self.selectPartnerHandler(info);
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *viewController = nil;
        for(int i = viewControllers.count - 2; i >= 0;i --)
        {
            viewController = [viewControllers objectAtIndex:i];
            if(![viewController isKindOfClass:[WMPartnerListViewController class]])
            {
                break;
            }
        }
        
        if(viewController)
        {
            [self.navigationController popToViewController:viewController animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        WMPartnerDetailViewController *detail = [[WMPartnerDetailViewController alloc] initWithPartnerInfo:info];
        detail.hierarchy = self.hierarchy;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

@end
