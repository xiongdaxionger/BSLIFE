//
//  WMGoodGraphicDetailViewController.m
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodGraphicDetailViewController.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailTabInfo.h"
#import "WMGoodDetailParamInfo.h"
#import "WMGoodDetailSettingInfo.h"
#import "WMGoodDetailOperation.h"

#import "WMGoodSellLogHeaderViewCell.h"
#import "WMGoodSellLogContentViewCell.h"
#import "WMGoodParamHeaderViewCell.h"
#import "WMGoodParamContentViewCell.h"
#import "WMGoodDetailWebTableViewCell.h"
#import "WMGoodDetailBottomView.h"

@interface WMGoodGraphicDetailViewController ()<SeaMenuBarDelegate,SeaHttpRequestDelegate>
/**菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *menuBar;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
@end

@implementation WMGoodGraphicDetailViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.isReloadWeb = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置表格视图相关UI
- (void)initialization{
    
    [super initialization];
    
    if (self.goodDetailInfo.goodMenuBarInfosArr.count >= 2) {
        
        NSMutableArray *titlesArr = [NSMutableArray arrayWithCapacity:self.goodDetailInfo.goodMenuBarInfosArr.count];
        
        for (WMGoodDetailTabInfo *tabInfo in self.goodDetailInfo.goodMenuBarInfosArr) {
            
            [titlesArr addObject:tabInfo.tabName];
        }
        
        if(!self.menuBar)
        {
            SeaMenuBar *menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titlesArr style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
            
            menu.delegate = self;
            
            self.menuBar = menu;
        }
        
        [self.view addSubview:self.menuBar];
    }
    
    [self.tableView setBackgroundColor:_SeaViewControllerBackgroundColor_];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.separatorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.enableDropDown = YES;
    
    self.enablePullUp = YES;
    
    self.refreshControl.isRefresh = YES;
    
    CGFloat menuBarHeight = self.goodDetailInfo.goodMenuBarInfosArr.count >= 2 ? _SeaMenuBarHeight_ : CGFLOAT_MIN;
    
    self.graphicWebHeight = _height_ - self.navigationBarHeight - self.statusBarHeight - menuBarHeight;
    
    self.tableView.frame = CGRectMake(0, menuBarHeight, _width_, _height_ - self.navigationBarHeight - self.statusBarHeight - menuBarHeight - WMGoodDetailBottomViewHeight - (isIPhoneX ? 35.0 : 0.0));
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodParamHeaderViewCell" bundle:nil] forCellReuseIdentifier:WMGoodParamHeaderViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodParamContentViewCell" bundle:nil] forCellReuseIdentifier:WMGoodParamContentViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodSellLogHeaderViewCell" bundle:nil] forCellReuseIdentifier:WMGoodSellLogHeaderViewCellIden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMGoodSellLogContentViewCell" bundle:nil] forCellReuseIdentifier:WMGoodSellLogContentViewCellIden];
    
    [self endPullUpLoadingWithMoreInfo:NO];

    self.tableView.sea_shouldShowEmptyView = YES;
}

#pragma mark- SeaEmptyView

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无销售记录";
}

#pragma mark - 下拉刷新和上拉加载
- (void)beginPullUpLoading{
    
    self.curPage ++;
    
    [self reloadDataFromNetwork];
}

- (void)beginDropDownRefresh{
    
    self.dropDown();
    
    [self endDropDownRefreshWithMsg:@"释放回到商品详情"];
}

#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger selectedIndex = self.goodDetailInfo.goodMenuBarInfosArr.count <= 1 ? 0 : self.menuBar.selectedIndex;
    
    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:selectedIndex];
    
    switch (tabInfo.type) {
        case GoodGraphicDetailTypeWeb:
        case GoodGraphicDetailTypeSellLog:
        {
            return 1;
        }
            break;
        case GoodGraphicDetailTypeParam:
        {
            return self.goodDetailInfo.goodDetailParamsArr.count;
        }
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger selectedIndex = self.goodDetailInfo.goodMenuBarInfosArr.count <= 1 ? 0 : self.menuBar.selectedIndex;
    
    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:selectedIndex];
    
    switch (tabInfo.type) {
        case GoodGraphicDetailTypeParam:
        {
            WMGoodDetailParamInfo *paramInfo = [self.goodDetailInfo.goodDetailParamsArr objectAtIndex:section];
            
            return paramInfo.groupParamsArr.count + 1;
        }
            break;
        case GoodGraphicDetailTypeSellLog:
        {
            return self.goodSellLogInfosArr.count == 0 ? 0 : self.goodSellLogInfosArr.count + 1;
        }
            break;
        case GoodGraphicDetailTypeWeb:
        {
            return 1;
        }
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger selectedIndex = self.goodDetailInfo.goodMenuBarInfosArr.count <= 1 ? 0 : self.menuBar.selectedIndex;
    
    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:selectedIndex];
    
    switch (tabInfo.type) {
        case GoodGraphicDetailTypeWeb:
        {
            WMGoodDetailWebTableViewCell *webCell = [[WMGoodDetailWebTableViewCell alloc] initWithFrame:CGRectMake(0, 0, _width_, _graphicWebHeight)];
            
            webCell.webView.delegate = self;
                        
            [webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], tabInfo.tabContent] baseURL:nil];
            
            return webCell;
        }
            break;
        case GoodGraphicDetailTypeSellLog:
        {
            if (indexPath.row) {
                
                WMGoodSellLogContentViewCell *sellLogContentCell = [tableView dequeueReusableCellWithIdentifier:WMGoodSellLogContentViewCellIden forIndexPath:indexPath];
                
                sellLogContentCell.showPrice = self.sellLogShowPrice;
                
                [sellLogContentCell configureWithModel:[self.goodSellLogInfosArr objectAtIndex:indexPath.row - 1]];
                
                return sellLogContentCell;
            }
            else{
                
                WMGoodSellLogHeaderViewCell *sellLogHeaderCell = [tableView dequeueReusableCellWithIdentifier:WMGoodSellLogHeaderViewCellIden forIndexPath:indexPath];
                
                [sellLogHeaderCell configureWithModel:self.sellLogShowPrice];
                
                return sellLogHeaderCell;
            }
        }
            break;
        case GoodGraphicDetailTypeParam:
        {
            WMGoodDetailParamInfo *paramInfo = [self.goodDetailInfo.goodDetailParamsArr objectAtIndex:indexPath.section];
            
            if (indexPath.row) {
                
                WMGoodParamContentViewCell *paramContentCell = [tableView dequeueReusableCellWithIdentifier:WMGoodParamContentViewCellIden forIndexPath:indexPath];
                
                [paramContentCell configureWithModel:[paramInfo.groupParamsArr objectAtIndex:indexPath.row - 1]];
                
                return paramContentCell;
            }
            else{
                
                WMGoodParamHeaderViewCell *paramHeaderCell = [tableView dequeueReusableCellWithIdentifier:WMGoodParamHeaderViewCellIden forIndexPath:indexPath];
                
                [paramHeaderCell configureWithModel:paramInfo.groupParamName];
                
                return paramHeaderCell;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger selectedIndex = self.goodDetailInfo.goodMenuBarInfosArr.count <= 1 ? 0 : self.menuBar.selectedIndex;
    
    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:selectedIndex];
    
    switch (tabInfo.type) {
        case GoodGraphicDetailTypeWeb:
        {
            return _graphicWebHeight;
        }
            break;
        case GoodGraphicDetailTypeSellLog:
        {
            return WMGoodSellLogContentViewCellHeight;
        }
            break;
        case GoodGraphicDetailTypeParam:
        {
            WMGoodDetailParamInfo *paramInfo = [_goodDetailInfo.goodDetailParamsArr objectAtIndex:indexPath.section];
            
            UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
            
            if (indexPath.row) {
                
                WMGoodDetailParamValueInfo *valueInfo = [paramInfo.groupParamsArr objectAtIndex:indexPath.row - 1];
                
                CGFloat nameHeight = [valueInfo.paramName stringSizeWithFont:font contraintWith:WMGoodParamContentNameWidth].height;
                
                CGFloat contentHeight = [valueInfo.paramContent stringSizeWithFont:font contraintWith:_width_ - WMGoodParamContentExtraWidth].height;
                
                return MAX(nameHeight, contentHeight) + WMGoodParamContentExtraHeight;
            }
            else{
                
                return MAX(WMGoodParamHeaderViewCellHeight, [paramInfo.groupParamName stringSizeWithFont:font contraintWith:_width_ - 2 * 8.0].height + WMGoodParamHeaderViewCellExtraHeight);
            }
        }
            break;
        default:
        {
            return CGFLOAT_MIN;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

#pragma mark - SeameunBar协议
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{

    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:index];
    
    [self endPullUpLoadingWithMoreInfo:NO];
    
    switch (tabInfo.type) {
        case GoodGraphicDetailTypeParam:
        {
            [self.tableView reloadData];
        }
            break;
        case GoodGraphicDetailTypeWeb:
        {
            self.isReloadWeb = YES;
            
            [self.tableView reloadData];
        }
            break;
        case GoodGraphicDetailTypeSellLog:
        {
            if (!self.goodSellLogInfosArr) {
                
                self.goodSellLogInfosArr = [NSMutableArray new];
                
                self.requesting = YES;
                
                self.showNetworkActivity = YES;
                
                [self reloadDataFromNetwork];
            }
            else{
                
                [self endPullUpLoadingWithMoreInfo:self.goodSellLogInfosArr.count < self.totalCount];
                
                [self.tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}

- (void)reloadDataFromNetwork{
    
    self.request.identifier = WMGoodDetailSellLogRequestIdentifier;
    
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMGoodDetailOperation returnGoodSellLogWithGoodID:self.goodDetailInfo.goodID page:self.curPage]];
}

#pragma mark - 网络协议
- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGoodDetailSellLogRequestIdentifier]) {
        
        if (self.loadMore) {
            
            self.curPage --;
            
            [self endPullUpLoadingWithMoreInfo:YES];
            
            return;
        }
        
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data{
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMGoodDetailSellLogRequestIdentifier]) {
        
        NSDictionary *dict = [WMGoodDetailOperation returnGoodSellLogWithData:data];
        
        self.totalCount = [[dict numberForKey:@"total"] integerValue];
        
        self.sellLogShowPrice = [[dict numberForKey:@"showPrice"] boolValue];
        
        [self.goodSellLogInfosArr addObjectsFromArray:[dict arrayForKey:@"sellLog"]];
        
        [self endPullUpLoadingWithMoreInfo:self.goodSellLogInfosArr.count < self.totalCount];
        
        [self.tableView reloadData];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    webView.height = webView.scrollView.contentSize.height;
    
    CGFloat minHeight = _height_ - self.navigationBarHeight - self.statusBarHeight - self.goodDetailInfo.goodMenuBarInfosArr.count >= 2 ? _SeaMenuBarHeight_ : CGFLOAT_MIN;
    
    if (webView.height < minHeight) {
        
        _graphicWebHeight = minHeight;
        
    }
    else{
        
        _graphicWebHeight = webView.height;
    }
    
    NSInteger selectedIndex = self.goodDetailInfo.goodMenuBarInfosArr.count <= 1 ? 0 : self.menuBar.selectedIndex;
    
    WMGoodDetailTabInfo *tabInfo = [self.goodDetailInfo.goodMenuBarInfosArr objectAtIndex:selectedIndex];
    
    if (tabInfo.graphicHeight == 0.0) {
        
        tabInfo.graphicHeight = _graphicWebHeight;
    }
    else{
        
        _graphicWebHeight = tabInfo.graphicHeight;
    }
    
    webView.userInteractionEnabled = NO;
    
    if (self.isReloadWeb) {
        
        [self.tableView reloadData];
        
        self.isReloadWeb = NO;
    }
}




















@end
