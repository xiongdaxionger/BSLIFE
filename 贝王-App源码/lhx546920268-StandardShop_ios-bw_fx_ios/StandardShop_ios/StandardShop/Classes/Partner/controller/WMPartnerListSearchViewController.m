//
//  WMPartnerListSearchViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerListSearchViewController.h"
#import "WMPartnerListViewController.h"

@interface WMPartnerListSearchViewController ()

///会员列表
@property(nonatomic,strong) WMPartnerListViewController *partnerListViewController;

@end

@implementation WMPartnerListSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.searchBar.placeholder = @"手机号、帐号、姓名";
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
}

///从新加载数据
- (void)reloadData
{
    if(!self.partnerListViewController)
    {
        self.partnerListViewController = [[WMPartnerListViewController alloc] init];
        self.partnerListViewController.searchKey = self.searchBar.text;
        self.partnerListViewController.selectPartnerHandler = self.selectPartnerHandler;
        self.partnerListViewController.partnerListSearchViewController = self;
        [self.partnerListViewController willMoveToParentViewController:self];
        [self.view addSubview:self.partnerListViewController.view];
        [self addChildViewController:self.partnerListViewController];
        [self.partnerListViewController didMoveToParentViewController:self];
    }
    
    self.partnerListViewController.searchKey = self.searchBar.text;
    [self.partnerListViewController reloadDataFromNetwork];
}

- (void)didSearchWithText:(NSString *)text
{
    [self reloadData];
}

@end
