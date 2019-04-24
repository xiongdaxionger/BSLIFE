//
//  WMDrawCouponsViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDrawCouponsViewController.h"

#import "WMDrawCouponsListCell.h"

#import "WMCouponsOperation.h"
#import "WMCouponsInfo.h"

@interface WMDrawCouponsViewController ()<SeaHttpRequestDelegate,WMDrawCouponsListCellDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///优惠券信息 数组元素是 WMCouponsInfo
@property(nonatomic,strong) NSMutableArray *infos;

//选中的下标
@property (strong,nonatomic) NSIndexPath *selectIndexPath;


@end

@implementation WMDrawCouponsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backItem = YES;
    self.title = @"领券中心";
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.infos = [NSMutableArray array];
    self.loading = YES;
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;

    [super initialization];
    
    self.tableView.height -= (isIPhoneX ? 35.0 : 0.0);

    [self.tableView registerNib:[UINib nibWithNibName:@"WMDrawCouponsListCell" bundle:nil] forCellReuseIdentifier:@"WMDrawCouponsListCell"];

    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    self.loading = NO;
    
    self.requesting = NO;
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMActivityCouponIdentifier]) {
        
        [self failToLoadData];
    }
    else if ([request.identifier isEqualToString:WMCouponsCreateIdentifier]){
        
        [self alertMsg:@"网络错误，请重试"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.loading = NO;
    
    self.requesting = NO;
    
    self.showNetworkActivity = NO;
    
    if ([request.identifier isEqualToString:WMActivityCouponIdentifier]) {
        
        NSArray *infosArr = [WMCouponsOperation returnActivityCouponInfosWithData:data];
        
        if (infosArr) {
            
            [self.infos addObjectsFromArray:infosArr];
            
            if (!self.tableView) {
                
                [self initialization];
            }
            
            [self.tableView reloadData];
        }
        else{
            
            [self failToLoadData];
        }
    }
    else if ([request.identifier isEqualToString:WMCouponsCreateIdentifier]){
        
        if ([WMCouponsOperation couponsCreateInfoFromData:data]) {
            
            [self alertMsg:@"优惠券领取成功"];
            
            WMCouponsInfo *info = [self.infos objectAtIndex:self.selectIndexPath.section];
            
            info.statusString = @"已领";
            
            info.activityStatus = WMActivityStatusReceived;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            if (self.getCouponSuccess) {
                
                self.getCouponSuccess();
            }
        }
    }
}

- (void)reloadDataFromNetwork{
    
    self.httpRequest.identifier = WMActivityCouponIdentifier;
    
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation returnActivityCouponParam]];
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
    return self.infos.count == 0 ? CGFLOAT_MIN : 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.infos.count - 1 ? 10.0 : CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WMDrawCouponsListCell";

    WMDrawCouponsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.info = [self.infos objectAtIndex:indexPath.section];
    
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WMCouponsInfo *info = [self.infos objectAtIndex:indexPath.section];
    
    return [info couponNameHeight];
}

#pragma mark- WMDrawCouponsListCell delegate

- (void)drawCouponsListCellDidDraw:(WMDrawCouponsListCell *)cell
{
    self.selectIndexPath = [self.tableView indexPathForCell:cell];
    
    if([AppDelegate instance].isLogin)
    {
        [self drawCoupons];
    }
    else
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
           
            [weakSelf drawCoupons];
        }];
    }
}

- (void)drawCoupons
{
    WMCouponsInfo *info = [self.infos objectAtIndex:self.selectIndexPath.section];
    if (info.activityStatus == WMActivityStatusReceived)
    {
        [self alertMsg:@"您已领取了该优惠券"];
    }
    else
    {
        self.requesting = YES;
        self.showNetworkActivity = YES;
        self.httpRequest.identifier = WMCouponsCreateIdentifier;
        
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMCouponsOperation couponsCreateWithCode:info.couponCode]];
    }
}

@end
