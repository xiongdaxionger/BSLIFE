//
//  WMOrderManagerController.m
//  StandardFenXiao
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderManagerController.h"
#import "WMOrderCenterViewController.h"
#import "WMUserInfo.h"

@interface WMOrderManagerController ()
/**分段控制器
 */
@property (strong,nonatomic) UISegmentedControl *segment;
/**我的订单
 */
@property (strong,nonatomic) WMOrderCenterViewController *myOrderViewController;
/**代购订单
 */
@property (strong,nonatomic) WMOrderCenterViewController *salesOrderViewController;

@end

@implementation WMOrderManagerController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backItem = YES;
    
    [self configureWithUI];
    
    [self segmentTap:self.segment];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 配置UI
- (void)configureWithUI{
    
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"我的订单",@"代购订单"]];
    
    _segment.selectedSegmentIndex = _segementIndex;
    
    _segment.tintColor = WMTintColor;
    
    [_segment addTarget:self action:@selector(segmentTap:) forControlEvents:UIControlEventValueChanged];
    
    if ([[WMUserInfo sharedUserInfo] enableUseFenXiao]) {
        self.navigationItem.titleView = _segment;
    }
    else{
        self.title = @"我的订单";
    }
}

- (void)segmentTap:(UISegmentedControl *)segment{
    
    _segementIndex = segment.selectedSegmentIndex;
    
    if (segment.selectedSegmentIndex == 0) {
        
        if (self.myOrderViewController == nil) {
            
            self.myOrderViewController = [[WMOrderCenterViewController alloc] init];
            
            self.myOrderViewController.isSinglePrepare = NO;
            
            self.myOrderViewController.orderStatusSelectIndex = self.seaMenuBarIndex;
        }
        
        [self.salesOrderViewController removeFromParentViewController];
        
        [self.salesOrderViewController.view removeFromSuperview];
        
        [self addChildViewController:self.myOrderViewController];
        
        [self.view addSubview:self.myOrderViewController.view];
    }
    else if (segment.selectedSegmentIndex == 1){
        
        if (self.salesOrderViewController == nil) {
            
            self.salesOrderViewController = [[WMOrderCenterViewController alloc] init];
            
            self.salesOrderViewController.isSinglePrepare = NO;
            
            self.salesOrderViewController.isCommisionOrder = YES;
            
            self.salesOrderViewController.orderStatusSelectIndex = self.seaMenuBarIndex == 4 ? 3 : self.seaMenuBarIndex;
        }
        
        [self.myOrderViewController removeFromParentViewController];
        
        [self.myOrderViewController.view removeFromSuperview];
        
        [self addChildViewController:self.salesOrderViewController];
        
        [self.view addSubview:self.salesOrderViewController.view];
    }
}











@end
