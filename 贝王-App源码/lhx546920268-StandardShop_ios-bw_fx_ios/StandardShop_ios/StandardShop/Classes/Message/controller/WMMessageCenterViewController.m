//
//  WMMessageCenterViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageCenterViewController.h"
#import "SeaHttpRequest.h"
#import "WMMessageCenterInfo.h"
#import "WMMessageCenterListCell.h"
#import "WMMessageOperation.h"
#import "WMMessageOrderViewController.h"
#import "WMMessageNoticeViewController.h"
#import "WMMessageSystemViewController.h"
#import "WMMessageActivityViewController.h"
#import "WMMessageWealthViewController.h"

@interface WMMessageCenterViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

///消息中心数据，数组元素是 WMMessageCenterInfo
@property(nonatomic,strong) NSArray *infos;

@end

@implementation WMMessageCenterViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backItem = YES;
    self.title = @"消息中心";
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.infos = [NSMutableArray array];

    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.loading = NO;
    
    self.layout.minimumLineSpacing = WMMessageCenterListCellMargin;
    self.layout.minimumInteritemSpacing = WMMessageCenterListCellMargin;
    self.layout.itemSize = WMMessageCenterListCellSize;
    self.layout.headerReferenceSize = CGSizeMake(_width_, _separatorLineWidth_);
    
    [super initialization];

    [self.collectionView registerNib:[UINib nibWithNibName:@"WMMessageCenterListCell" bundle:nil] forCellWithReuseIdentifier:@"WMMessageCenterListCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.enableDropDown = YES;
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无消息";
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(self.refreshing)
    {
        [self endDropDownRefreshWithMsg:nil];
    }
    else
    {
        [self failToLoadData];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSArray *infos = [WMMessageOperation messageCenterInfosFromData:data];
    if(infos)
    {
        self.infos = infos;
        if(self.collectionView)
        {
            [self.collectionView reloadData];
            [self endDropDownRefreshWithMsg:nil];
        }
        else
        {
            [self initialization];
        }
    }
    else if(self.refreshing)
    {
        [self endDropDownRefreshWithMsg:nil];
    }
    else
    {
        [self failToLoadData];
    }
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

///加载消息中心信息
- (void)loadInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMMessageOperation messageCenterInfosParams]];
}

- (void)beginDropDownRefresh
{
    [self loadInfo];
}

#pragma mark- UITableView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.infos.count;
    return count + (count % WMMessageCenterListCellCountPerRow == 0 ? 0 : (WMMessageCenterListCellCountPerRow - count % WMMessageCenterListCellCountPerRow));
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    header.backgroundColor = _separatorLineColor_;
    
    return header;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMMessageCenterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMMessageCenterListCell" forIndexPath:indexPath];
    cell.info = [self.infos objectAtNotBeyondIndex:indexPath.item];
    cell.index = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMMessageCenterInfo *info = [self.infos objectAtNotBeyondIndex:indexPath.item];
    
    if(!info)
        return;
    
    switch (info.type)
    {
        case WMMessageTypeActivity :
        {
            WMMessageActivityViewController *message = [[WMMessageActivityViewController alloc] init];
            message.info = info;
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case WMMessageTypeNotice :
        {
            WMMessageNoticeViewController *message = [[WMMessageNoticeViewController alloc] init];
            message.info = info;
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case WMMessageTypeOrder :
        {
            WMMessageOrderViewController *order = [[WMMessageOrderViewController alloc] init];
            order.info = info;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case WMMessageTypeWealth :
        {
            WMMessageWealthViewController *wealth = [[WMMessageWealthViewController alloc] init];
            wealth.info = info;
            [self.navigationController pushViewController:wealth animated:YES];
        }
            break;
        case WMMessageTypeSystem :
        {
            WMMessageSystemViewController *system = [[WMMessageSystemViewController alloc] init];
            system.info = info;
            [self.navigationController pushViewController:system animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
