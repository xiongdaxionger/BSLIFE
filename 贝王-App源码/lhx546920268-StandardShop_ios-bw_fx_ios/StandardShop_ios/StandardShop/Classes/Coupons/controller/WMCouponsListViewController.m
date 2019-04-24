//
//  WMCouponsListViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCouponsListViewController.h"
#import "WMDrawCouponsViewController.h"

#import "WMCouponsInfo.h"
#import "WMCouponsOperation.h"

#import "WMCouponsListCell.h"
#import "WMCouponsListHeaderView.h"
#import "WMShopCartEmptyView.h"

@interface WMCouponsListViewController ()<SeaHttpRequestDelegate,WMCouponsListCellDelegate,UIAlertViewDelegate,SeaMenuBarDelegate>
/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

/**头部
 */
@property(nonatomic,strong) WMCouponsListHeaderView *header;

/**过期优惠券信息 数组元素是 WMCouponsInfo
 */
@property(nonatomic,strong) NSMutableArray *overdueCouponsInfos;

///失效优惠券总数
@property(nonatomic,assign) long long overdueTotalSize;

///失效优惠券页码
@property(nonatomic,assign) int overdueCurPage;

@end

@implementation WMCouponsListViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.overdueCurPage = WMHttpPageIndexStartingValue;
    self.title = @"优惠券";

    self.backItem = YES;
    
    if(self.couponsInfos.count > 0)
    {
        [self initialization];
    }
    else
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        
        [self reloadDataFromNetwork];
    }
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMCouponsListCell" bundle:nil] forCellReuseIdentifier:@"WMCouponsListCell"];
    
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //表头 添加优惠券
    WMCouponsListHeaderView *header = [[WMCouponsListHeaderView alloc] init];
    
    header.menuBar.delegate = self;
    
    header.navigationController = self.navigationController;

    [self.view addSubview:header];
    
    self.header = header;
    
    CGRect frame = self.tableView.frame;
    
    frame.origin.y = self.header.bottom;
    
    frame.size.width = _width_;
    
    frame.size.height -= (self.header.height + 58);
    
    if (isIPhoneX) {
        
        frame.size.height -= 35.0;
    }
    
    self.tableView.frame = frame;
    
    self.enablePullUp = YES;
    
    [self setBarItemsWithTitle:@"添加" icon:nil action:@selector(createCoupons) position:SeaNavigationItemPositionRight];

    self.tableView.sea_shouldShowEmptyView = YES;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, _width_, 58)];
    
    footerView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 3.0, _width_ - 2 * 10.0, 50.0)];
    
    [button setTitle:@"更多好券，去领券中心看看吧" forState:UIControlStateNormal];
        
    [button setButtonIconToRightWithInterval:0.0];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button setTitleColor:MainTextColor forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont fontWithName:MainFontName size:14.0]];
    
    [button makeBorderWidth:0.0 Color:_separatorLineColor_ CornerRadius:WMLongButtonCornerRaidus];
    
    [button addTarget:self action:@selector(getMoreCoupon) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:button];
    
    [self.view addSubview:footerView];
}

- (void)getMoreCoupon{
    
    WeakSelf(self);
    
    WMDrawCouponsViewController *drawCouponController = [WMDrawCouponsViewController new];
    
    [drawCouponController setGetCouponSuccess:^{
        
        [weakSelf.couponsInfos removeAllObjects];
        
        [weakSelf loadCouponsInfo];
    }];
    
    [self.navigationController pushViewController:drawCouponController animated:YES];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    WMShopCartEmptyView *emptyView = [[WMShopCartEmptyView alloc] init];
    
    emptyView.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    emptyView.height = self.tableView.height;
    
    emptyView.shopping_btn.hidden = YES;
    
    emptyView.logo_imageView.image = [UIImage imageNamed:@"coupon_empty"];
    
    view.customView = emptyView;
    
    if(self.infos)
    {
        switch (self.header.menuBar.selectedIndex)
        {
            case 0 :
            {
                emptyView.title_label.text = self.wantSelectInfo ? @"你没有相关的优惠券" : @"你没有可用的优惠券";
                
                emptyView.subtitle_label.text = @"优惠券可以享受商品折扣";
            }
                break;
            case 1 :
            {
                emptyView.title_label.text = @"你没有失效的优惠券";
                
                emptyView.subtitle_label.hidden = YES;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        view.textLabel.text = nil;
    }
}

#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    if (!self.isCreateCoupon) {
        
        [self.tableView reloadData];
    }
    
    if(self.infos == nil)
    {
        self.loadMoreControl.hidden = YES;
        self.showNetworkActivity = YES;
        
        self.requesting = YES;
        
        [self loadCouponsInfo];
    }
    else
    {
        switch (index)
        {
            case 0 :
            {
                [self endPullUpLoadingWithMoreInfo:self.couponsInfos.count < self.totalCount];
            }
                break;
            case 1 :
            {
                [self endPullUpLoadingWithMoreInfo:self.overdueCouponsInfos.count < self.overdueTotalSize];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark- 添加优惠券
- (void)createCoupons
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加优惠券" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    textField.font = [UIFont fontWithName:MainFontName size:16.0];
    
    textField.placeholder = @"输入优惠码";
    
    [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    return ![NSString isEmpty:textField.text];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"确定"])
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        [textField resignFirstResponder];
        
        self.requesting = YES;
        
        self.showNetworkActivity = YES;
        
        self.httpRequest.identifier = WMCouponsCreateIdentifier;

        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation couponsCreateWithCode:textField.text]];
    }
}

#pragma mark - 上拉加载

- (void)beginPullUpLoading
{
    switch (self.header.menuBar.selectedIndex)
    {
        case 0 :
        {
            self.curPage ++;
            [self loadCouponsInfo];
        }
            break;
        case 1 :
        {
            self.overdueCurPage ++;
            [self loadCouponsInfo];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 网络请求

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    
    [self loadCouponsInfo];
}

///加载优惠券信息
- (void)loadCouponsInfo
{
    self.httpRequest.identifier = WMCouponsListIdentifier;

    NSInteger fliterType = 0;
    
    if (_wantSelectInfo) {
        
        if (!self.header.menuBar.selectedIndex) {
            
            fliterType = 1;
        }
    }

    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation couponsListParamWithType:self.header.menuBar.selectedIndex filterType:fliterType pageNumber:self.curPage isFastBuy:self.isFastBuy]];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMCouponsListIdentifier])
    {
        self.isCreateCoupon = NO;
        
        if(!self.tableView)
        {
            [self failToLoadData];
        }
        else if (self.loadMore)
        {
            switch (self.header.menuBar.selectedIndex)
            {
                case 0 :
                {
                    self.curPage --;
                }
                    break;
                case 1 :
                {
                    self.overdueCurPage --;
                }
                    break;
                default:
                    break;
            }
            [self endPullUpLoadingWithMoreInfo:YES];
        }
        
        return;
    }
    
   
    if([request.identifier isEqualToString:WMCouponsCreateIdentifier])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"生成优惠券失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    if ([request.identifier isEqualToString:WMUseCouponIdentifier]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"使用优惠券失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    if ([request.identifier isEqualToString:WMCancelUseCouponIdentifier]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"取消使用优惠券失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if([request.identifier isEqualToString:WMCouponsListIdentifier])
    {
        self.loadMoreControl.hidden = NO;
        long long totalSize = 0;
        NSArray *array = [WMCouponsOperation couponsListFromData:data totalSize:&totalSize];
        
        if(array)
        {
            self.isCreateCoupon = NO;

            switch (self.header.menuBar.selectedIndex)
            {
                case 0 :
                {
                    self.totalCount = totalSize;
                    if(!self.couponsInfos)
                    {
                        self.couponsInfos = [NSMutableArray array];
                    }
                    [self.couponsInfos addObjectsFromArray:array];
                }
                    break;
                case 1 :
                {
                    self.overdueTotalSize = totalSize;
                    if (!self.overdueCouponsInfos) {

                        self.overdueCouponsInfos = [NSMutableArray array];
                    }

                    [self.overdueCouponsInfos addObjectsFromArray:array];
                }
                    break;
                default:
                    break;
            }

            if(self.tableView)
            {
                [self.tableView reloadData];
            }
            else
            {
                [self initialization];
            }

            switch (self.header.menuBar.selectedIndex)
            {
                case 0 :
                {
                    [self endPullUpLoadingWithMoreInfo:self.couponsInfos.count < self.totalCount];
                }
                    break;
                case 1 :
                {
                    [self endPullUpLoadingWithMoreInfo:self.overdueCouponsInfos.count < self.overdueTotalSize];
                }
                    break;
                default:
                    break;
            }
        }
        else if (self.loadMore)
        {
            switch (self.header.menuBar.selectedIndex)
            {
                case 0 :
                {
                    self.curPage --;
                }
                    break;
                case 1 :
                {
                    self.overdueCurPage --;
                }
                    break;
                default:
                    break;
            }
            [self endPullUpLoadingWithMoreInfo:YES];
        }
        else
        {
            [self failToLoadData];
        }
            
        return;
    }
    
    if([request.identifier isEqualToString:WMCouponsCreateIdentifier])
    {
        BOOL info = [WMCouponsOperation couponsCreateInfoFromData:data];
        
        if(info)
        {
            self.isCreateCoupon = YES;
            
            NSString *title = [NSString stringWithFormat:@"恭喜！获得一张新的优惠券"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alertView show];
            
            [self.couponsInfos removeAllObjects];
            
            self.header.menuBar.selectedIndex = 0;
            
            [self loadCouponsInfo];
        }
        
        return;
    }
    
    if ([request.identifier isEqualToString:WMUseCouponIdentifier]) {
        
        NSDictionary *dict = [WMCouponsOperation returnCouponUseResultWithData:data];
        
        if (dict) {
            
            NSDictionary *couponDict = [[[dict dictionaryForKey:WMHttpData] arrayForKey:@"coupons"] firstObject];
            
            for (WMCouponsInfo *info in self.couponsInfos) {
                
                if (info.status == WMCouponsStatusNormal) {
                    
                    if ([info.Id isEqualToString:[couponDict sea_stringForKey:@"cpns_id"]]){
                        
                        info.isUseing = YES;
                        
                        info.couponCount -= 1;
                        
                        if (info.couponCount == 0) {
                            
                            info.title = info.firstTitle;
                        }
                        else{
                            
                            info.title = [NSString stringWithFormat:@"%@(x%d)",info.firstTitle,info.couponCount];
                        }
                    }
                    else{
                        
                        if (info.isUseing) {
                            
                            info.isUseing = NO;
                            
                            info.couponCount += 1;
                            
                            info.title = [NSString stringWithFormat:@"%@(x%d)",info.firstTitle,info.couponCount];
                        }
                    }
                }
            }
            
            [self.tableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(couponsListViewController:didSelectCouponsInfo: pointDict:)]) {
                
                [self alertMsg:@"使用优惠券成功"];
                
//                [self performSelector:@selector(back) withObject:nil afterDelay:0.8];
                
                [self.delegate couponsListViewController:self didSelectCouponsInfo:[dict dictionaryForKey:WMHttpData] pointDict:[[dict dictionaryForKey:WMHttpData] dictionaryForKey:@"point_dis"]];
            }
        }
    }
    
    if ([request.identifier isEqualToString:WMCancelUseCouponIdentifier]) {
        
        NSDictionary *dict = [WMCouponsOperation returnCancelUseCouponResultWithData:data];
        
        if (dict) {
            
            WMCouponsInfo *info = [self.couponsInfos objectAtIndex:_selectIndexPath.section];
            
            info.isUseing = NO;
                
            info.couponCount += 1;
                
            info.title = [NSString stringWithFormat:@"%@(x%d)",info.firstTitle,info.couponCount];
            
            [self.tableView reloadRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            if ([self.delegate respondsToSelector:@selector(couponsListViewController:didDselectCouponsInfo: pointDict:)]) {
                
                [self alertMsg:@"取消使用优惠券成功"];
                
                [self.delegate couponsListViewController:self didDselectCouponsInfo:[dict sea_stringForKey:@"md5_cart_info"] pointDict:[dict dictionaryForKey:@"point_dis"]];
            }
        }
    }
}

#pragma mark- UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.infos.count == 0 ? CGFLOAT_MIN : WMCouponsListCellMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WMCouponsListCell";
    
    WMCouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WMCouponsInfo *couponInfo = [self.infos objectAtIndex:indexPath.section];
    
    cell.info = couponInfo;
    
    cell.use_bg_view.hidden = !_wantSelectInfo;
    
    cell.use_btn.hidden = cell.use_bg_view.hidden;
    
    if (_wantSelectInfo) {
        
        cell.status_bg_view.hidden = NO;
        
        cell.status_label.hidden = NO;
    }
    else{
        
        cell.status_label.hidden = couponInfo.status == WMCouponsStatusNormal;
        
        cell.status_bg_view.hidden = couponInfo.status == WMCouponsStatusNormal;
    }
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMCouponsInfo *info = [self.infos objectAtIndex:indexPath.section];
        
    return [info couponNameHeight];
}

#pragma mark- WMCouponsListCell delegate

- (void)couponsListCellCellDidSelect:(WMCouponsListCell *)cell
{
    _selectIndexPath = [self.tableView indexPathForCell:cell];

    WMCouponsInfo *info = [_couponsInfos objectAtIndex:_selectIndexPath.section];
    
    self.showNetworkActivity = YES;
    
    self.requesting = YES;
    
    if (info.isUseing) {
        
        self.httpRequest.identifier = WMCancelUseCouponIdentifier;
        
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation returnCancelUseCouponParamWithCouponCode:info.couponCode isFastBuy:self.isFastBuy]];
    }
    else{
        
        self.httpRequest.identifier = WMUseCouponIdentifier;
        
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation returnUseCouponWithCouponCode:[NSString stringWithFormat:@"%@",info.couponCode] isFastBuy:self.isFastBuy objType:@"coupon"]];
    }
}

///获取数据源
- (NSArray*)infos
{
    return self.header.menuBar.selectedIndex == 0 ? self.couponsInfos : self.overdueCouponsInfos;
}

@end
