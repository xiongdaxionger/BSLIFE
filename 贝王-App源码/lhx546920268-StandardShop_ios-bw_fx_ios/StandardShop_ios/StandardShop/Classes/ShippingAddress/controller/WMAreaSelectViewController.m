//
//  WMAddressSelectViewController.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMAreaSelectViewController.h"
#import "WMAreaInfo.h"
#import "WMShippingAddressOperation.h"

@interface WMAreaSelectViewController ()<SeaHttpRequestDelegate>

/**网络请求
 */
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMAreaSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.selectedInfos.count > 0)
    {
        WMAreaInfo *info = [self.selectedInfos lastObject];
        self.title = info.name;
    }
    else
    {
        self.title = @"地区";
    }
    
    self.backItem = YES;
    if(!self.infos)
    {
        self.infos = [NSMutableArray array];
    }
    
    if(!self.selectedInfos)
    {
        self.selectedInfos = [NSMutableArray array];
    }
    
    if(self.infos.count > 0)
    {
        [self initialization];
    }
    else
    {
        self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
        [self reloadDataFromNetwork];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.selectedInfos.count > self.level)
    {
        [self.selectedInfos removeLastObject];
    }
}

- (void)initialization
{
    [super initialization];
    
    [self.tableView setExtraCellLineHidden];
}

#pragma mark- http

//加载数据
- (void)loadInfo
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMShippingAddressOperation areaInfoParam]];
}

- (void)reloadDataFromNetwork
{
    self.loading = YES;
    [self loadInfo];
}

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    [self failToLoadData];
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    NSArray *infos = [WMShippingAddressOperation areaInfoFromData:data];
    if(infos.count > 0)
    {
        [self.infos addObjectsFromArray:infos];
        
        [self initialization];
    }
    else
    {
        [self failToLoadData];
    }
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont fontWithName:MainFontName size:16.0];
        
       // cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick_red"]];
    }
    
    WMAreaInfo *info = [self.infos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMAreaInfo *info = [self.infos objectAtIndex:indexPath.row];
    [self.selectedInfos addObject:info];

    if(info.childAreaInfos.count == 0)
    {
        NSMutableString *string = [NSMutableString string];
        for(WMAreaInfo *info in self.selectedInfos)
        {
            
            [string appendFormat:@"%@", info.name];
        }
        
        if([self.delegate respondsToSelector:@selector(areaSelectViewController:didSelectArea:)])
        {
            [self.delegate areaSelectViewController:self didSelectArea:string];
        }
        
        [self.navigationController popToViewController:self.rootViewController animated:YES];
    }
    else
    {
        WMAreaSelectViewController *areaSelect = [[WMAreaSelectViewController alloc] init];
        areaSelect.infos = info.childAreaInfos;
        areaSelect.level = self.level + 1;
        areaSelect.selectedInfos = self.selectedInfos;
        areaSelect.delegate = self.delegate;
        areaSelect.rootViewController = self.rootViewController;
        [self.navigationController pushViewController:areaSelect animated:YES];
    }
}


@end
