//
//  WMSearchAssociateViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSearchAssociateViewController.h"
#import "WMSearchController.h"
#import "WMHomeOperation.h"

@interface WMSearchAssociateViewController ()<SeaHttpRequestDelegate>

///网络请求
@property(nonatomic,strong) SeaHttpRequest *httpRequest;

@end

@implementation WMSearchAssociateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.style = UITableViewStyleGrouped;
    
    [self initialization];
    self.tableView.backgroundColor = _SeaViewControllerBackgroundColor_;
}

#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    self.infos = [WMHomeOperation searchAssociateResultFromData:data];
    if(!self.infos)
    {
        [self.searchController closeAssociate];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (void)refreshKey:(NSString *)key
{
    [self.httpRequest downloadWithURL:SeaNetworkRequestURL dic:[WMHomeOperation searchAssociateWithKey:key]];
}


#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    }
    
    cell.textLabel.text = [self.infos objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchController.searchBar.text = [self.infos objectAtIndex:indexPath.row];
    [self.searchController search];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}

@end
