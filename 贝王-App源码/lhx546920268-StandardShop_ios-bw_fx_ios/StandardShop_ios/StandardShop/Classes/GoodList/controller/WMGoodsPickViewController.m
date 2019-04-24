//
//  WMGoodsPickViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "WMGoodsPickViewController.h"
#import "WMGoodListOperation.h"
#import "WMGoodsAccessRecordListCell.h"
#import "WMGoodDetailContainViewController.h"
#import "WMGoodsAccessRecordInfo.h"

@interface WMGoodsPickViewController ()<SeaHttpRequestDelegate>

//
@property(nonatomic,strong) NSMutableArray<WMGoodsAccessRecordInfo*> *infos;

@property(nonatomic,strong) SeaHttpRequest *http;

@end

@implementation WMGoodsPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.http = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.infos = [NSMutableArray array];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    [self reloadDataFromNetwork];
}


- (void)initialization
{
    [super initialization];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WMGoodsAccessRecordListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WMGoodsAccessRecordListCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 110.0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 10)];
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.tableView.frame = CGRectMake(0, 0, _width_, self.contentHeight - _SeaMenuBarHeight_);
    self.enablePullUp = YES;
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if(!self.loadMore){
        [self failToLoadData];
    }else{
        self.curPage --;
        [self endPullUpLoadingWithMoreInfo:YES];
    }
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    long long count = 0;
    NSArray *array = [WMGoodListOperation goodsPickFromData:data totalSize:&count];
    self.totalCount = count;
    
    [self.infos addObjectsFromArray:array];
    
    if(!self.tableView){
        [self initialization];
    }else{
        [self.tableView reloadData];
    }
    
    [self endPullUpLoadingWithMoreInfo:self.infos.count < count];
}

- (void)loadInfo
{
    [self.http downloadWithURL:SeaNetworkRequestURL dic:[WMGoodListOperation goodsPickParamsWithPage:self.curPage]];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

- (void)beginPullUpLoading
{
    self.curPage ++;
    [self loadInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodsAccessRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WMGoodsAccessRecordListCell class]) forIndexPath:indexPath];
    
    cell.info = [self.infos objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMGoodDetailContainViewController *good = [[WMGoodDetailContainViewController alloc] init];
    WMGoodsAccessRecordInfo *info = [self.infos objectAtIndex:indexPath.row];
    
    good.goodID = info.goodId;
    good.productID = info.productId;
    [self.navigationController pushViewController:good animated:YES];
}


@end
