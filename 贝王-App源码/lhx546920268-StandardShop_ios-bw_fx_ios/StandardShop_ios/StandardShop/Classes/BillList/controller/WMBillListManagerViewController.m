//
//  WMBillListManagerViewController.m
//  StandardShop
//
//  Created by Hank on 16/11/10.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBillListManagerViewController.h"
#import "WMBillListViewController.h"
#import "WMUserInfo.h"

@interface WMBillListManagerViewController ()

/**分段控制器
 */
@property (strong,nonatomic) UISegmentedControl *segment;
/**余额的账单
 */
@property (strong,nonatomic) WMBillListViewController *myBlanceViewController;
/**佣金的账单
 */
@property (strong,nonatomic) WMBillListViewController *commisionViewController;

@end

@implementation WMBillListManagerViewController

- (instancetype)init{

    self = [super init];
    
    if (self) {
        
        self.segementIndex = 0;
    }
    
    return self;
}

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
    
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"余额账单",@"佣金账单"]];
    
    _segment.selectedSegmentIndex = _segementIndex;
    
    _segment.tintColor = WMButtonBackgroundColor;
    
    [_segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:WMButtonTitleColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [_segment setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [_segment addTarget:self action:@selector(segmentTap:) forControlEvents:UIControlEventValueChanged];
    
    if ([[WMUserInfo sharedUserInfo] enableUseFenXiao]) {
        
        self.navigationItem.titleView = _segment;
    }
    else{
        self.title = @"余额账单";
    }
}

- (void)segmentTap:(UISegmentedControl *)segment{
    
    _segementIndex = segment.selectedSegmentIndex;
    
    if (segment.selectedSegmentIndex == 0) {
        
        if (self.myBlanceViewController == nil) {
            
            self.myBlanceViewController = [[WMBillListViewController alloc] init];
            
            self.myBlanceViewController.isCommisionOrder = NO;
        }
        
        [self.commisionViewController removeFromParentViewController];
        
        [self.commisionViewController.view removeFromSuperview];
        
        [self addChildViewController:self.myBlanceViewController];
        
        [self.view addSubview:self.myBlanceViewController.view];
    }
    else if (segment.selectedSegmentIndex == 1){
        
        if (self.commisionViewController == nil) {
            
            self.commisionViewController = [[WMBillListViewController alloc] init];
            
            self.commisionViewController.isCommisionOrder = YES;
            
        }
        
        [self.myBlanceViewController removeFromParentViewController];
        
        [self.myBlanceViewController.view removeFromSuperview];
        
        [self addChildViewController:self.commisionViewController];
        
        [self.view addSubview:self.commisionViewController.view];
    }
}










@end
