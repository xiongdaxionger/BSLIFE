//
//  wuliutbViewController.m
//  WuMei
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMLogisticsViewController.h"
#import "WMLogisticsListCell.h"
#import "WMLogisticsInfo.h"
#import "WMLogisticsOperation.h"

@interface WMLogisticsViewController ()<SeaHttpRequestDelegate>

/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;

///物流名称
@property(nonatomic, strong) UILabel *logistics_name_label;

///物流单号
@property(nonatomic,strong) UILabel *logistics_number_label;

///物流信息
@property(nonatomic,strong) WMLogisticsInfo *info;


@end

@implementation WMLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.separatorEdgeInsets = UIEdgeInsetsMake(0, WMLogisticsListCellMargin, 0, 0);
    self.request = [[SeaHttpRequest alloc] initWithDelegate:self];
  
    self.backItem = YES;
    
    [self reloadDataFromNetwork];
}

- (void)initialization
{
    self.style = UITableViewStyleGrouped;
    
    [super initialization];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMLogisticsListCell" bundle:nil] forCellReuseIdentifier:@"WMLogisticsListCell"];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 10.0;
    ///表头
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width_, 0)];
    
    ///物流公司
    self.logistics_name_label = [[UILabel alloc]initWithFrame:CGRectMake(margin, 20, _width_ - margin * 2, 15)];
    [self.logistics_name_label setTextColor:MainGrayColor];
    self.logistics_name_label.font = [UIFont fontWithName:MainFontName size:13];
    [header addSubview:self.logistics_name_label];
    
    self.logistics_number_label = [[UILabel alloc]initWithFrame:CGRectMake(margin, self.logistics_name_label.bottom + 5, self.logistics_name_label.width, self.logistics_name_label.height)];
    [self.logistics_number_label setTextColor:MainGrayColor];
    self.logistics_number_label.font = [UIFont fontWithName:MainFontName size:13];
    [header addSubview:self.logistics_number_label];
    
    ///分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.logistics_number_label.bottom + 20, _width_,_separatorLineWidth_)];
    line.backgroundColor = _separatorLineColor_;
    [header addSubview:line];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(margin, line.bottom + 10, _width_ - margin * 2, 20)];
    label.text = @"物流详情";
    label.font = [UIFont fontWithName:MainFontName size:13];
    [label setTextColor:[UIColor blackColor]];
    [header addSubview:label];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom + 10, _width_ , _separatorLineWidth_)];
    line.backgroundColor = _separatorLineColor_;
    [header addSubview:line];
    header.backgroundColor = [UIColor whiteColor];
    header.height = line.bottom;
    
    self.tableView.tableHeaderView = header;
    
    
    self.enableDropDown = YES;
}

- (void)beginDropDownRefresh
{
    [self lookLogistics];
}

-(void)reloadDataFromNetwork
{
    self.loading = YES;
    [self lookLogistics];
}

#pragma mark- http

///查看物流
-(void)lookLogistics
{
    self.request.identifier = WMLogisticsInfoIdentifier;
    [self.request downloadWithURL:SeaNetworkRequestURL dic:[WMLogisticsOperation logisticsInfoParamWithOrderId:self.deliveryID isOrder:self.isOrder]];
}

-(void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    if([request.identifier isEqualToString:WMLogisticsInfoIdentifier])
    {
        self.info = [WMLogisticsOperation logisticsInfoFromData:data];
        
        if(!self.tableView)
        {
            self.loading = NO;
            [self initialization];
        }
        else
        {
            [self.tableView reloadData];
            [self endDropDownRefreshWithMsg:nil];
        }
        
        self.logistics_name_label.text = self.info.name;
        self.logistics_number_label.text = self.info.number;
        
        return;
    }
}

-(void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    if([request.identifier isEqualToString:WMLogisticsInfoIdentifier])
    {
        if(self.refreshing)
        {
            [self endDropDownRefreshWithMsg:nil];
        }
        else
        {
            [self failToLoadData];
        }
        return;
    }
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.info.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WMLogisticsListCell rowHeightWithInfo:[self.info.infos objectAtIndex:indexPath.row]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMLogisticsListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WMLogisticsListCell" forIndexPath:indexPath];

    cell.info = [self.info.infos objectAtIndex:indexPath.row];
    
    cell.point_imageView.highlighted = indexPath.row == 0;
    
    return cell;
}



@end
