//
//  WMFoundViewController.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundViewController.h"
#import "WMFoundListInfo.h"
#import "WMFoundFooterView.h"
#import "WMFoundOperation.h"
#import "WMFoundCategoryInfo.h"
#import "WMQRCodeScanViewController.h"
#import "WMFoundListViewController.h"

@interface WMFoundViewController ()<SeaMenuBarDelegate>

///菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///滑动
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation WMFoundViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)back
{
    for(WMFoundCategoryInfo *info in self.infos)
    {
        info.infos = nil;
    }
    
    [super back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItem = YES;
    self.title = @"社区板块";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initialization];
}

- (void)initialization
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.infos.count];
    for(WMFoundCategoryInfo *info in self.infos)
    {
        NSString *title = info.name;
        if(!title)
            title = @"";
        [titles addObject:title];
    }
    
    self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_) titles:titles style:SeaMenuBarStyleItemWithRelateTitle];
    self.menuBar.callDelegateWhenSetSelectedIndex = NO;
    self.menuBar.buttonInterval = 15.0;
    self.menuBar.delegate = self;
    [self.view addSubview:self.menuBar];
    
    //创建pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = CGRectMake(0, self.menuBar.bottom, _width_, _height_ - self.menuBar.height);
    [self.pageViewController willMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    ///跳到指定的栏目
    NSInteger index = 0;
    if(self.selectedFoundCategoryInfo)
    {
        for(NSInteger i = 0;i < self.infos.count;i ++)
        {
            WMFoundCategoryInfo *info = [self.infos objectAtIndex:i];
            if([self.selectedFoundCategoryInfo.Id isEqualToString:info.Id])
            {
                index = i;
                break;
            }
        }
    }
    
    self.menuBar.selectedIndex = index;
    [self menuBar:self.menuBar didSelectItemAtIndex:index];
}


///判断是否有发现信息
- (void)hasMsg
{
    [self setHasNoMsgViewHidden:self.infos.count > 0 msg:[NSString stringWithFormat:@"暂无信息"]];
}

#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    WMFoundListViewController *found = [self.pageViewController.viewControllers lastObject];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self foundListViewControllerForIndex:index]] direction:found.index > index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark- UIPageViewController delegate

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    WMFoundListViewController *found = (WMFoundListViewController*)viewController;

    return [self foundListViewControllerForIndex:found.index + 1];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    WMFoundListViewController *found = (WMFoundListViewController*)viewController;
    
    return [self foundListViewControllerForIndex:found.index - 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        WMFoundListViewController *found = [pageViewController.viewControllers lastObject];
        [self.menuBar setSelectedIndex:found.index animated:YES];
    }
}

///获取对应下标的发现内容
- (WMFoundListViewController*)foundListViewControllerForIndex:(NSInteger) index
{
    if(index >= self.infos.count || index < 0)
        return nil;
    
    WMFoundListViewController *found = [[WMFoundListViewController alloc] init];
    found.categorInfo = [self.infos objectAtIndex:index];
    found.index = index;
    found.infos = self.infos;
    
    return found;
}

@end
