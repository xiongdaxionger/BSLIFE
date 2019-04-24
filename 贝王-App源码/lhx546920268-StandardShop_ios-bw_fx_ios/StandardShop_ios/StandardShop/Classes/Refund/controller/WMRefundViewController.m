//
//  WMRefundViewController.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundViewController.h"

#import "WMRefundOrderViewController.h"
#import "WMRefundGoodRecordViewController.h"
#import "WMRefundMoneyRecordViewController.h"

@interface WMRefundViewController ()<SeaMenuBarDelegate>
/**申请退款货控制器
 */
@property (strong,nonatomic) WMRefundOrderViewController *refundMoneyOrderController;
/**申请退换货控制器
 */
@property (strong,nonatomic) WMRefundOrderViewController *refundGoodOrderController;
/**退换货记录控制器
 */
@property (strong,nonatomic) WMRefundGoodRecordViewController *refundGoodRecordController;
/**退款记录控制器
 */
@property (strong,nonatomic) WMRefundMoneyRecordViewController *refundMoneyRecordController;
@end

@implementation WMRefundViewController

#pragma mark - 初始化
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.backItem = YES;

        self.title = @"申请售后";
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureSeaMenuBar];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置菜单栏
- (void)configureSeaMenuBar{
    
    SeaMenuBar *menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:@[@"申请退款",@"退款记录",@"申请退货",@"退货记录"] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    
    menu.delegate = self;
    
    menu.topSeparatorLine.hidden = YES;
    
    menu.callDelegateWhenSetSelectedIndex = NO;
    
    menu.selectedIndex = 0;
    
    self.orderListMenuBar = menu;
    
    [self.view addSubview:self.orderListMenuBar];
    
    [self menuBar:self.orderListMenuBar didSelectItemAtIndex:0];
}

#pragma mark - 选项卡协议
- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index{
    
    CGRect frame = CGRectMake(0, self.orderListMenuBar.bottom, _width_, self.contentHeight + self.statusBarHeight);
    
    switch (index) {
        case 0:
        {
            if (!self.refundMoneyOrderController) {
                
                self.refundMoneyOrderController = [[WMRefundOrderViewController alloc] initWithType:@"refund"];
            }
            
            if(self.refundGoodRecordController)
            {
                [self.refundGoodRecordController.view removeFromSuperview];
                
                [self.refundGoodRecordController removeFromParentViewController];
            }
            
            if(self.refundMoneyRecordController)
            {
                [self.refundMoneyRecordController.view removeFromSuperview];
                
                [self.refundMoneyRecordController removeFromParentViewController];
            }
            
            if (self.refundGoodOrderController) {
                
                [self.refundGoodOrderController.view removeFromSuperview];
                
                [self.refundGoodOrderController removeFromParentViewController];
            }
            
            [self.refundMoneyOrderController willMoveToParentViewController:self];
            
            self.refundMoneyOrderController.view.frame = frame;
            
            [self.view addSubview:self.refundMoneyOrderController.view];
            
            [self addChildViewController:self.refundMoneyOrderController];
            
            [self.refundMoneyOrderController didMoveToParentViewController:self];
        }
            break;
        case 1:
        {
            if (!self.refundMoneyRecordController) {
                
                self.refundMoneyRecordController = [[WMRefundMoneyRecordViewController alloc] init];
            }
            
            if(self.refundGoodRecordController)
            {
                [self.refundGoodRecordController.view removeFromSuperview];
                
                [self.refundGoodRecordController removeFromParentViewController];
            }
            
            if(self.refundMoneyOrderController)
            {
                [self.refundMoneyOrderController.view removeFromSuperview];
                
                [self.refundMoneyOrderController removeFromParentViewController];
            }
            
            if (self.refundGoodOrderController) {
                
                [self.refundGoodOrderController.view removeFromSuperview];
                
                [self.refundGoodOrderController removeFromParentViewController];
            }
            
            [self.refundMoneyRecordController willMoveToParentViewController:self];
            
            self.refundMoneyRecordController.view.frame = frame;
            
            [self.view addSubview:self.refundMoneyRecordController.view];
            
            [self addChildViewController:self.refundMoneyRecordController];
            
            [self.refundMoneyRecordController didMoveToParentViewController:self];
        }
            break;
        case 2:
        {
            if (!self.refundGoodOrderController) {
                
                self.refundGoodOrderController = [[WMRefundOrderViewController alloc] initWithType:@"reship"];
            }
            
            if(self.refundGoodRecordController)
            {
                [self.refundGoodRecordController.view removeFromSuperview];
                
                [self.refundGoodRecordController removeFromParentViewController];
            }
            
            if(self.refundMoneyRecordController)
            {
                [self.refundMoneyRecordController.view removeFromSuperview];
                
                [self.refundMoneyRecordController removeFromParentViewController];
            }
            
            if (self.refundMoneyOrderController) {
                
                [self.refundMoneyOrderController.view removeFromSuperview];
                
                [self.refundMoneyOrderController removeFromParentViewController];
            }
            
            [self.refundGoodOrderController willMoveToParentViewController:self];
            
            self.refundGoodOrderController.view.frame = frame;
            
            [self.view addSubview:self.refundGoodOrderController.view];
            
            [self addChildViewController:self.refundGoodOrderController];
            
            [self.refundGoodOrderController didMoveToParentViewController:self];
        }
            break;
        case 3:
        {
            if (!self.refundGoodRecordController) {
                
                self.refundGoodRecordController = [[WMRefundGoodRecordViewController alloc] init];
            }
            
            if(self.refundMoneyRecordController)
            {
                [self.refundMoneyRecordController.view removeFromSuperview];
                
                [self.refundMoneyRecordController removeFromParentViewController];
            }
            
            if(self.refundMoneyOrderController)
            {
                [self.refundMoneyOrderController.view removeFromSuperview];
                
                [self.refundMoneyOrderController removeFromParentViewController];
            }
            
            if (self.refundGoodOrderController) {
                
                [self.refundGoodOrderController.view removeFromSuperview];
                
                [self.refundGoodOrderController removeFromParentViewController];
            }
            
            [self.refundGoodRecordController willMoveToParentViewController:self];
            
            self.refundGoodRecordController.view.frame = frame;
            
            [self.view addSubview:self.refundGoodRecordController.view];
            
            [self addChildViewController:self.refundGoodRecordController];
            
            [self.refundGoodRecordController didMoveToParentViewController:self];
        }
            break;
        default:
            break;
    }
}










@end
