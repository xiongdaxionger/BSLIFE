//
//  WMActivityListViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMActivityListViewController.h"
#import "WMActivityInfo.h"
#import "WMActivityListCell.h"
#import "WMShakeViewController.h"
#import "WMIntegralSignInViewController.h"
#import "WMActivityOperation.h"
#import "WMDrawCouponsViewController.h"
#import "WMTopupActivityViewController.h"
#import "WMBalanceOperation.h"
#import "WMTopupInfo.h"
#import "WMTopupViewController.h"
#import "WMInviteRegisterQRCodeViewController.h"

@interface WMActivityListViewController ()<SeaHttpRequestDelegate>

///活动信息 数组元素是 WMActivityInfo
@property(nonatomic,strong) NSArray *infos;

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMActivityListViewController

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

    self.backItem = YES;
    self.title = @"我的活动";
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.layout.minimumLineSpacing = WMActivityListCellMargin;
    self.layout.minimumInteritemSpacing = WMActivityListCellMargin;
    self.layout.itemSize = WMActivityListCellSize;
    self.layout.headerReferenceSize = CGSizeMake(_width_, _separatorLineWidth_);
    
    [super initialization];

    [self.collectionView registerNib:[UINib nibWithNibName:@"WMActivityListCell" bundle:nil] forCellWithReuseIdentifier:@"WMActivityListCell"];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMActivityListIdentifier])
    {
        [self failToLoadData];
        return;
    }
    
    if([request.identifier isEqualToString:WMTopupInfoIdentifier])
    {
        self.requesting = NO;
        [self alerBadNetworkMsg:@"获取充值信息失败"];
        return;
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMActivityListIdentifier])
    {
        self.infos = [WMActivityOperation activityListFromData:data];
        if(self.infos)
        {
            [self initialization];
        }
        else
        {
            [self failToLoadData];
        }
        
        return;
    }
    
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
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;

    self.httpRequest.identifier = WMActivityListIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMActivityOperation activityListParams]];
}

///获取充值信息
- (void)loadTopupInfo
{
    ///获取充值信息
    self.requesting = YES;
    self.showNetworkActivity = YES;
    
    self.httpRequest.identifier = WMTopupInfoIdentifier;
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMBalanceOperation topupInfoParams]];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.infos.count;
    return count + (count % WMActivityListCellCountPerRow == 0 ? 0 : (WMActivityListCellCountPerRow - count % WMActivityListCellCountPerRow));
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    header.backgroundColor = _separatorLineColor_;
    
    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMActivityListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMActivityListCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtNotBeyondIndex:indexPath.item];
    cell.index = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    WMActivityInfo *info = [self.infos objectAtNotBeyondIndex:indexPath.item];
    
    if(!info)
        return;

    switch (info.type)
    {
        case WMActivityTypeDrawCoupons :
        {
            [self selectInfo:info];
        }
            break;
        default:
        {
            if([AppDelegate instance].isLogin)
            {
                [self selectInfo:info];
            }
            else
            {
                WeakSelf(self);
                [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
                   
                    [weakSelf selectInfo:info];
                }];
            }
        }
            break;
    }
}

///选择某个活动
- (void)selectInfo:(WMActivityInfo*) info
{
    switch (info.type)
    {
        case WMActivityTypeShake :
        {
            WMShakeViewController *shake = [[WMShakeViewController alloc] init];
            [self.navigationController pushViewController:shake animated:YES];
        }
            break;
        case WMActivityTypeSignup :
        {
            WMIntegralSignInViewController *signup = [[WMIntegralSignInViewController alloc] init];
            [self.navigationController pushViewController:signup animated:YES];
        }
            break;
        case WMActivityTypeDrawCoupons :
        {
            WMDrawCouponsViewController *draw = [[WMDrawCouponsViewController alloc] init];
            [self.navigationController pushViewController:draw animated:YES];
        }
            break;
        case WMActivityTypeTopup :
        {
            [self loadTopupInfo];
        }
            break;
        case WMActivityTypeInviteRegister :
        {
            WMInviteRegisterQRCodeViewController *registerQ = [[WMInviteRegisterQRCodeViewController alloc] init];
            registerQ.title = info.name;
            [self.navigationController pushViewController:registerQ animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
