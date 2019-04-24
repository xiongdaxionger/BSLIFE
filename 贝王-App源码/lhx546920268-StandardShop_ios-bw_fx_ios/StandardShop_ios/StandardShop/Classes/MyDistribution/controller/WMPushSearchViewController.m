//
//  WMPushSearchViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMPushSearchViewController.h"

@interface WMPushSearchViewController ()


@end

@implementation WMPushSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.hidesBackButton = YES;
    self.httpRequest = [[SeaHttpRequest alloc] initWithDelegate:self];
    self.infos = [NSMutableArray array];
    [self setBarItemsWithTitle:@"取消" icon:nil action:@selector(back) position:SeaNavigationItemPositionRight];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _width_ - 90.0, 30.0)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    UITextField *textField = self.searchBar.sea_searchedTextField;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    textField.layer.cornerRadius = 3.0;
    textField.layer.masksToBounds = YES;
    self.searchBar.tintColor = _UIKitTintColor_;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
}


#pragma mark- http

- (void)httpRequest:(SeaHttpRequest *)request didFailed:(NSInteger)error
{
    
}

- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData *)data
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark- UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self didSearchWithText:searchBar.text];
}

///点击搜索 子类重写该方法
- (void)didSearchWithText:(NSString*) text
{
    
}

@end
