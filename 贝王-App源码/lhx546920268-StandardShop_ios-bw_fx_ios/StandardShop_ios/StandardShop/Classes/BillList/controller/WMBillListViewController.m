//
//  WMBillListViewController.m
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMBillListViewController.h"

#import "WMBillInfoModel.h"
#import "WMBillListOperation.h"

#import "WMBillListViewCell.h"

#define WMDropDownMenuHeight 35.0

@interface WMBillListViewController ()<SeaHttpRequestDelegate,SeaDropDownMenuDelegate>
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**下拉菜单
 */
@property (strong,nonatomic) SeaDropDownMenu *dropDownMenu;
/**表格视图的数组
 */
@property (strong,nonatomic) NSMutableArray *infoArr;
@end

@implementation WMBillListViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    
    self.title = @"账单";
    
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
    
    [self initialization];
    
    [self configureUI];
    
    self.loading = YES;
    
//    [self getBillListInfo];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)initialization{
    
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    self.page_num = 1;
    
    self.selectTitle = @"收入";
    
    self.billPayStatus = @"in";
    
    UINib *nib = [UINib nibWithNibName:@"WMBillListViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:WMBillListViewCellIden];
    
    self.tableView.rowHeight = WMBillListViewCellHeight;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;
    
    [self.view addSubview:self.tableView];

    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    
    view.textLabel.text = [NSString stringWithFormat:@"暂无%@账单信息",self.selectTitle];
}

#pragma mark - 配置UI
- (void)configureUI{
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;

    self.infoArr = [[NSMutableArray alloc] init];
    
    self.dropDownMenu = [WMBillListOperation returnDropDownViewWith:self];
    
    [self.view addSubview:self.dropDownMenu];
    
    self.tableView.frame = CGRectMake(0, self.dropDownMenu.bottom, _width_, self.contentHeight - self.dropDownMenu.height - (isIPhoneX ? 35.0 : 0.0));
}

#pragma mark - 下拉刷新和上拉加载
- (void)beginDropDownRefresh{
    
    self.page_num = 1;
    
    self.refreshing = YES;
    
    [self getBillListInfo];
}

- (void)beginPullUpLoading{
    
    self.page_num ++;
    
    [self getBillListInfo];
}

#pragma mark - 网络回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    self.refreshing = NO;
    
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.loading = NO;
    
    self.showNetworkActivity = NO;
    
    NSDictionary *dict = [WMBillListOperation returnBillListInfosWithData:data];
    
    if (dict) {
        
        if (self.refreshing) {
            
            [self.infoArr removeAllObjects];
            
            self.refreshing = NO;
        }
        
        [self.infoArr addObjectsFromArray:[dict arrayForKey:@"info"]];
        
        [self endDropDownRefreshWithMsg:nil];
        
        [self endPullUpLoadingWithMoreInfo:self.infoArr.count < [[dict numberForKey:@"total"] integerValue]];
        
        [self.tableView reloadData];
    }
}

#pragma mark - 下拉菜单协议
- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItem:(SeaDropDownMenuItem *)item{
    
    self.refreshing = YES;
    
    [self endPullUpLoadingWithMoreInfo:NO];
    
    self.firstIndex = item.itemIndex;
    
    self.page_num = 1;
    
    self.selectTitle = [WMBillListOperation returnSecondSelectTitleItem:item];
    
    self.billPayStatus = [WMBillListOperation returnSecondSelectStatusWithIndex:item.selectedIndex firstIndex:item.itemIndex];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self getBillListInfo];
}

- (void)dropDownMenu:(SeaDropDownMenu *)menu didSelectItemWithSecondMenu:(SeaDropDownMenuItem *)item{
    
    self.refreshing = YES;
    
    [self endPullUpLoadingWithMoreInfo:NO];
    
    self.page_num = 1;
    
    self.billPayStatus = [WMBillListOperation returnSecondSelectStatusWithIndex:item.selectedIndex firstIndex:item.itemIndex];
    
    self.selectTitle = [WMBillListOperation returnSecondSelectTitleItem:item];
    
    self.requesting = YES;
    
    self.showNetworkActivity = YES;
    
    [self getBillListInfo];
}

#pragma mark - 表格视图的协议

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.infoArr.count ? 5.0 : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMBillListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WMBillListViewCellIden forIndexPath:indexPath];
    
    [cell configureWithModel:[self.infoArr objectAtIndex:indexPath.row]];
    
    return cell;
}
#pragma mark - 网络请求
- (void)getBillListInfo{
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMBillListOperation returnBillListParamWithStatus:self.billPayStatus pageNum:self.page_num isCommisionOrder:self.isCommisionOrder]];
}

- (void)reloadDataFromNetwork{
    
    [self getBillListInfo];
}







@end
