//
//  WMGoodsAccessRecordViewController.m
//  StandardShop
//
//  Created by 罗海雄 on 2017/11/24.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "WMGoodsAccessRecordViewController.h"
#import "WMGoodsStoreViewController.h"
#import "WMGoodsPickViewController.h"


@interface WMGoodsAccessRecordViewController ()<SeaMenuBarDelegate>

@property(nonatomic,strong) WMGoodsStoreViewController *store;

@property(nonatomic,strong) WMGoodsPickViewController *pick;

@property(nonatomic,strong) SeaMenuBar *menu;

@end

@implementation WMGoodsAccessRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.title = @"存取记录";
    
    self.menu = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:[NSArray arrayWithObjects:@"存货列表", @"存取记录", nil] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    self.menu.topSeparatorLine.hidden = YES;
    self.menu.delegate = self;
    
    [self.view addSubview:self.menu];
    
    [self menuBar:self.menu didSelectItemAtIndex:0];
}

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0 : {
            if(!self.store){
                self.store = [[WMGoodsStoreViewController alloc] init];
            }
            
            if(self.pick){
                [self.pick.view removeFromSuperview];
                [self.pick removeFromParentViewController];
            }
            
            self.store.view.frame = CGRectMake(0, self.menu.bottom, _width_, self.contentHeight - self.menu.height);
            [self.store willMoveToParentViewController:self];
            [self.view addSubview:self.store.view];
            [self addChildViewController:self.store];
            [self.store didMoveToParentViewController:self];
        }
            break;
        case 1 : {
            if(!self.pick){
                self.pick = [[WMGoodsPickViewController alloc] init];
            }
            
            if(self.store){
                [self.store.view removeFromSuperview];
                [self.store removeFromParentViewController];
            }
            
            self.pick.view.frame = CGRectMake(0, self.menu.bottom, _width_, self.contentHeight - self.menu.height);
            [self.pick willMoveToParentViewController:self];
            [self.view addSubview:self.pick.view];
            [self addChildViewController:self.pick];
            [self.pick didMoveToParentViewController:self];
        }
            break;
        default:
            break;
    }
}

@end
