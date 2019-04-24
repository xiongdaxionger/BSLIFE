//
//  WMDistributionViewController.m
//  SuYan
//
//  Created by mac on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDistributionViewController.h"
#import "WMDistributionInfo.h"
#import "WMDistributionFuncButtonInfo.h"
#import "WMDistributionHeaderView.h"
#import "WMDistributionFuncButtonCell.h"
#import "WMDistributionEarningsCell.h"
#import "WMShareActionSheet.h"
#import "WMCollegeTableViewController.h"
#import "WMPartnerListViewController.h"
#import "WMStatisticalViewController.h"

@interface WMDistributionViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///分销信息
@property(nonatomic,strong) WMDistributionInfo *distributionInfo;

///按钮信息 数组元素是 NSArray
@property(nonatomic,strong) NSArray *infos;

@end

@implementation WMDistributionViewController

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的分销";
    self.backItem = YES;

    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.distributionInfo = [[WMDistributionInfo alloc] init];
    self.distributionInfo.shareURL = [NSString stringWithFormat:@"http://%@", SeaNetworkDomainName];

    [self initialization];
}

- (void)initialization
{
    self.infos = [NSArray arrayWithObjects:[self.distributionInfo distributionEarningsInfos], [WMDistributionFuncButtonInfo funcButtonInfos], nil];
    [super initialization];

    [self.collectionView registerClass:[WMDistributionEarningsCell class] forCellWithReuseIdentifier:@"WMDistributionEarningsCell"];
    [self.collectionView registerClass:[WMDistributionFuncButtonCell class] forCellWithReuseIdentifier:@"WMDistributionFuncButtonCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMDistributionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMDistributionHeaderView"];

    self.collectionView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.collectionView.alwaysBounceVertical = NO;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{

}

- (void)reloadDataFromNetwork
{

}

#pragma UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.infos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.infos objectAtIndex:section] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        CGSize size = WMDistributionEarningsCellSize;
        if((indexPath.item + 1) % 3 == 0)
        {
            size.width = (_width_ - size.width * 2);
        }

        return size;
    }
    return WMDistributionFuncButtonCellSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return WMDistributionHeaderViewSize;
    }

    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 0 ? 0 : WMDistributionFuncButtonCellMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 0 ? 0 : WMDistributionFuncButtonCellMargin;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WMDistributionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WMDistributionHeaderView" forIndexPath:indexPath];
    header.info = self.distributionInfo;
    header.navigationController = self.navigationController;

    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.infos objectAtIndex:indexPath.section];

    if(indexPath.section == 0)
    {
        WMDistributionEarningsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMDistributionEarningsCell" forIndexPath:indexPath];
        WMDistributionEarningsInfo *info = [array objectAtIndex:indexPath.item];

        cell.titleLabel.text = info.title;
        cell.contentLabel.text = info.content;

        return cell;
    }
    else
    {
        WMDistributionFuncButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMDistributionFuncButtonCell" forIndexPath:indexPath];
        cell.info = [array objectAtIndex:indexPath.item];

        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if(indexPath.section != 0)
    {
        NSArray *array = [self.infos objectAtIndex:indexPath.section];
        WMDistributionFuncButtonInfo *info = [array objectAtIndex:indexPath.item];

        switch (info.type)
        {
            case WMDistributionFuncButtonTypeTeam :
            {
                WMPartnerListViewController *partner = [[WMPartnerListViewController alloc] init];
                [self.navigationController pushViewController:partner animated:YES];
            }
                break;
            case WMDistributionFuncButtonTypeTopup :
            {

            }
                break;
            case WMDistributionFuncButtonTypeCollege :
            {
                WMCollegeTableViewController *college = [[WMCollegeTableViewController alloc] init];
                [self.navigationController pushViewController:college animated:YES];
            }
                break;
            case WMDistributionFuncButtonTypePromote :
            {
                WMShareActionSheet *share = [[WMShareActionSheet alloc] init];
                share.shareContentView.shareType = WMShareTypePromote;
                share.shareContentView.navigationController = self.navigationController;
                share.shareContentView.distributionInfo = self.distributionInfo;
                [share show];
            }
                break;
            case WMDistributionFuncButtonTypeWithdraw :
            {

            }
                break;
            case WMDistributionFuncButtonTypeStatistical :
            {
                WMStatisticalViewController *statistical = [[WMStatisticalViewController alloc] init];
                [self.navigationController pushViewController:statistical animated:YES];
            }
                break;
        }
    }
}

@end
