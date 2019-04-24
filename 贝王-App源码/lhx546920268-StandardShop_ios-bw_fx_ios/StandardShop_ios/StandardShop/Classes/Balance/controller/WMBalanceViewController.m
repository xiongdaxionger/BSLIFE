//
//  WMBalanceViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBalanceViewController.h"
#import "WMBalanceInfo.h"
#import "WMBalanceHeaderView.h"
#import "WMBalanceFooterView.h"
#import "WMBalanceListCell.h"
#import "WMUserInfo.h"
#import "WMTopupActivityViewController.h"
#import "WMTopupViewController.h"
#import "WMBalanceOperation.h"
#import "WMTopupInfo.h"
#import "WMWithDrawingViewController.h"
#import "WMBindPhoneNumberViewController.h"
#import "WMUserOperation.h"

@interface WMBalanceViewController ()<SeaHttpRequestDelegate,WMBalanceFooterViewDelegate>

///余额列表信息 数组元素是  WMBalanceListInfo
@property(nonatomic,strong) NSArray *infos;

///余额信息
@property(nonatomic,strong) WMBalanceInfo *info;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///过渡动画
@property(nonatomic,strong) SeaPresentTransitionDelegate *presentTransitionDelegate;

@end

@implementation WMBalanceViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.iconTintColor = [UIColor whiteColor];
    [self setupNavigationBarWithBackgroundColor:WMRedColor titleColor:[UIColor whiteColor] titleFont:nil];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageWithColor:WMRedColor size:CGSizeMake(1,1)];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
    
    self.backItem = YES;
    self.title = @"钱包";

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    
    [self reloadDataFromNetwork];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sea_navigationController.targetStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.sea_navigationController.targetStatusBarStyle = WMStatusBarStyle;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialization
{
    self.loading = NO;
    ///充值成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topupDidSuccess:) name:WMDidTopupNotification object:nil];
    
    ///提现成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrawDidSuccess:) name:WMDidWithdrawNotification object:nil];
    
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.itemSize = WMBalanceListCellSize;
    self.layout.headerReferenceSize = WMBalanceHeaderViewSize(self.info.showCommission);
    self.layout.footerReferenceSize = WMBalanceFooterViewSize;

    self.infos = self.info.balanceList;

    [super initialization];

    [self.collectionView registerNib:[UINib nibWithNibName:@"WMBalanceListCell" bundle:nil] forCellWithReuseIdentifier:@"WMBalanceListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMBalanceHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMBalanceHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMBalanceFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WMBalanceFooterView"];

    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (SeaPresentTransitionDelegate*)presentTransitionDelegate
{
    if(!_presentTransitionDelegate)
    {
        _presentTransitionDelegate = [[SeaPresentTransitionDelegate alloc] init];
    }

    return _presentTransitionDelegate;
}

#pragma mark- 通知

///充值成功
- (void)topupDidSuccess:(NSNotification*) notification
{
    
    [self loadBalance];
}

///提现成功
- (void)withdrawDidSuccess:(NSNotification*) notification
{
    [self loadBalance];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMTopupInfoIdentifier])
    {
        self.requesting = NO;
        [self alerBadNetworkMsg:@"获取充值信息失败"];
        return;
    }
    
    if([request.identifier isEqualToString:WMBalanceInfoIdentifier])
    {
        if(!self.collectionView)
        {
            [self failToLoadData];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMAccountSecurityIdentifier])
    {
        self.requesting = NO;
        [self alerBadNetworkMsg:@"账号验证失败"];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMTopupInfoIdentifier])
    {
        self.requesting = NO;
        WMTopupInfo *info = [WMBalanceOperation topupInfoFromData:data];
        
        if(info)
        {
            UIViewController *vc = nil;
            if(info.activitys.count > 0)
            {
                WMTopupActivityViewController *topup = [[WMTopupActivityViewController alloc] init];
                topup.topupInfo = info;
                vc = topup;
            }
            else
            {
                WMTopupViewController *topup = [[WMTopupViewController alloc] init];
                topup.topupInfo = info;
                vc = topup;
            }
            
            [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMBalanceInfoIdentifier])
    {
        WMBalanceInfo *info = [WMBalanceOperation balanceInfoFromData:data];
        
        if(info)
        {
            self.info = info;
            if(self.collectionView)
            {
                self.infos = self.info.balanceList;
                [self.collectionView reloadData];
            }
            else
            {
                [self initialization];
            }
        }
        else if (!self.collectionView)
        {
            [self failToLoadData];
        }
        
        return;
    }
    
    if([request.identifier isEqualToString:WMAccountSecurityIdentifier])
    {
        self.requesting = NO;
        if([WMUserOperation accountSecurityInfoFromData:data])
        {
            [self withdrawVerify];
        }
        else
        {
            [self alertMsg:@"账号验证失败"];
        }
        
        return;
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadBalance];
}

///加载余额信息
- (void)loadBalance
{
    self.httpRequest.identifier = WMBalanceInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation balanceInfoParams]];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WMBalanceHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMBalanceHeaderView" forIndexPath:indexPath];
        header.info = self.info;
        header.navigationController = self.navigationController;
        header.presentTransitionDelegate = self.presentTransitionDelegate;

        return header;
    }
    else
    {
        WMBalanceFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMBalanceFooterView" forIndexPath:indexPath];
        footer.info = self.info;
        footer.delegate = self;

        return footer;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMBalanceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMBalanceListCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtIndex:indexPath.item];

    return cell;
}

#pragma mark- WMBalanceFooterView delegate

- (void)balanceFooterViewDidTopup:(WMBalanceFooterView *)view
{
    ///获取充值信息
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    self.httpRequest.identifier = WMTopupInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation topupInfoParams]];
}

- (void)balanceFooterViewDidWithdraw:(WMBalanceFooterView *)view
{
    if([WMUserInfo sharedUserInfo].accountSecurityInfo)
    {
        [self withdrawVerify];
    }
    else
    {
        ///还没获取到账户安全信息
        self.requesting = YES;
        self.showNetworkActivity = YES;
        
        self.httpRequest.identifier = WMAccountSecurityIdentifier;
        [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMUserOperation accountSecurityParams]];
    }
}

///提现验证
- (void)withdrawVerify
{
    if (![WMUserInfo sharedUserInfo].shouldBindPhoneNumber)
    {
        ///提现
        WMWithDrawingViewController *withdraw = [[WMWithDrawingViewController alloc] init];
        [SeaPresentTransitionDelegate pushViewController:withdraw useNavigationBar:YES parentedViewConttroller:self];
    }
    else if([WMUserInfo sharedUserInfo].accountSecurityInfo)
    {
        ///绑定手机号
        WMBindPhoneNumberViewController *bind = [[WMBindPhoneNumberViewController alloc] init];
        __weak UINavigationController *nav = [SeaPresentTransitionDelegate pushViewController:bind useNavigationBar:YES parentedViewConttroller:self];
        bind.shouldBackAfterBindCompletion = NO;
        bind.bindCompletionHandler = ^(void){
            
            WMWithDrawingViewController *withdraw = [[WMWithDrawingViewController alloc] init];
            [nav setViewControllers:[NSArray arrayWithObject:withdraw] animated:YES];
        };
    }
}


@end
