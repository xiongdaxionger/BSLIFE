//
//  WMStoreListViewController.m
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreListViewController.h"
#import "WMStoreDetailViewController.h"

#import "WMStoreListInfo.h"
#import "WMStoreListViewCell.h"
#import "WMStoreOperation.h"
#import "WMLocationManager.h"

@interface WMStoreListViewController ()<SeaHttpRequestDelegate,UISearchBarDelegate>

///门店数据
@property (strong,nonatomic) NSMutableArray<WMStoreListInfo *> *infosArr;

///搜索栏
@property (strong,nonatomic) UISearchBar *searchBar;

///请求
@property (strong,nonatomic) SeaHttpRequest *request;

///搜索内容
@property (copy,nonatomic) NSString *searchContent;

/////遮挡视图
//@property (strong,nonatomic) UIView *showView;

@end

@implementation WMStoreListViewController

#pragma mark - 控制器周期
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.infosArr = [NSMutableArray new];
        
//        self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
        
//        self.showView.backgroundColor = [UIColor clearColor];
        
//        [self.showView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowView)]];
    }
    
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    [self addKeyboardNotification];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//
//    [super viewWillDisappear:animated];
//
//    [self removeKeyboardNotification];
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    
    self.title = @"选择门店";
    
    [self reloadDataFromNetwork];
}

#pragma mark - 键盘
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    [super keyboardWillHide:notification];
//
//    [self.showView removeFromSuperview];
//
//}
//
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    [super keyboardWillShow:notification];
//
//    [self.view addSubview:self.showView];
//}

//- (void)tapShowView{
//
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 请求
- (void)reloadDataFromNetwork{
    
    self.loading = YES;
    
    [self getStoreListInfoRequest];
}

- (void)getStoreListInfoRequest{
    
    self.request.identifier = WMStoreListIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMStoreOperation storeListParamsWithLatitude:[WMLocationManager sharedInstance].coordinate.latitude longitude:[WMLocationManager sharedInstance].coordinate.longitude keyWord:self.searchContent page:self.curPage]];
}

#pragma mark - 初始化
- (void)initialization{
    
    [super initialization];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 51.0)];
    
    view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8.0, 8.0, _width_ - 16.0, 35.0)];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.searchBar.placeholder = @"输入关键字进行搜索";
    
    self.searchBar.delegate = self;
    
    [self.searchBar setImage:[UIImage new] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(0, 0);
    
    self.searchBar.sea_searchedTextField.borderStyle = UITextBorderStyleNone;
    
    self.searchBar.sea_searchedTextField.textColor = [UIColor grayColor];
    
    self.searchBar.sea_searchedTextField.font = [UIFont fontWithName:MainFontName size:14.0];
    
    [self.searchBar.sea_searchedTextField addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.searchBar.tintColor = _searchBar.sea_searchedTextField.textColor;
    
    [view addSubview:self.searchBar];
    
    [self.view addSubview:view];
    
    self.tableView.top = view.bottom;
    
    self.tableView.height -= (view.height + (isIPhoneX ? 35.0 : 0.0));
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMStoreListViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass(WMStoreListViewCell.class)];
    
    self.tableView.sea_shouldShowEmptyView = YES;
    
    self.enablePullUp = YES;
    
    self.enableDropDown = YES;
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    [self endPullUpLoadingWithMoreInfo:self.infosArr.count < self.totalCount];
}

- (void)beginPullUpLoading{
    
    self.curPage ++;
    
    [self getStoreListInfoRequest];
}

- (void)beginDropDownRefresh{
    
    self.curPage = WMHttpPageIndexStartingValue;
    
    [self getStoreListInfoRequest];
}

- (void)emptyViewWillAppear:(SeaEmptyView *)view{
    
    view.textLabel.text = @"暂无门店";
}

#pragma mark - 请求回调
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if (self.refreshing) {
        
        [self endDropDownRefreshWithMsg:nil];
    }
    else if (self.loadMore){
        
        self.curPage --;
        
        [self endPullUpLoadingWithMoreInfo:YES];
    }
    else{
        
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    long long totalSize = 0;
    
    NSArray *infos = [WMStoreOperation parseStoreAddressListWithData:data totalSize:&totalSize];
    
    if(infos)
    {
        self.totalCount = totalSize;
        
        if(self.loadMore)
        {
            [self.infosArr addObjectsFromArray:infos];
            
            [self.tableView reloadData];
        }
        else if (self.refreshing)
        {
            [self.infosArr removeAllObjects];
            
            [self.infosArr addObjectsFromArray:infos];
            
            [self.tableView reloadData];
            
            [self endDropDownRefreshWithMsg:nil];
        }
        else
        {
            [self.infosArr addObjectsFromArray:infos];
            
            if (self.tableView) {
                
                [self.tableView reloadData];
            }
            else{
                
                [self initialization];
            }
        }
        [self endPullUpLoadingWithMoreInfo:self.infosArr.count < self.totalCount];

    }
    else{
        
        if (self.refreshing)
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
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.infosArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMStoreListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WMStoreListViewCell.class) forIndexPath:indexPath];
    
    cell.info = [self.infosArr objectAtIndex:indexPath.row];
    
    WeakSelf(self);
    
    [cell setPhoneCallBack:^(WMStoreListInfo *info) {
       
        makePhoneCall(info.mobile, YES);
    }];
    
    [cell setLocationCallBack:^(WMStoreListInfo *info) {
        
        if ([NSString isEmpty:info.latitude] || [NSString isEmpty:info.longitude]) {
            
            [weakSelf alertMsg:@"经纬度无效"];
            
            return ;
        }
        
        WMStoreDetailViewController *storeDetailController = [[WMStoreDetailViewController alloc] initWithInfo:[weakSelf.infosArr objectAtIndex:indexPath.row]];
        
        [weakSelf.navigationController pushViewController:storeDetailController animated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMStoreListInfo *info = [self.infosArr objectAtIndex:indexPath.row];
    
    return MAX(19.0, [info.completeAddress stringSizeWithFont:[UIFont fontWithName:MainFontName size:13.0] contraintWith:_width_ - 76.0].height) + 81.0 + 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMStoreListInfo *info = [self.infosArr objectAtIndex:indexPath.row];
    
    !self.selectStoreAddrCallBack ? : self.selectStoreAddrCallBack(info);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.searchContent = searchBar.text;
    
    [searchBar resignFirstResponder];
    
    self.curPage = 1;
    
    self.showNetworkActivity = YES;
    
    self.requesting = YES;
    
    [self.infosArr removeAllObjects];
    
    [self getStoreListInfoRequest];
}

- (void)searchTextChange:(UITextField *)inputFiled {
    
    if ([NSString isEmpty:inputFiled.text] && ![NSString isEmpty:self.searchContent]) {
        
        self.searchContent = nil;
        
        self.curPage = 1;
        
        [self.infosArr removeAllObjects];
        
        [self getStoreListInfoRequest];
    }
}



@end
