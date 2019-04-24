//
//  WMPartnerDetailViewController.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerDetailViewController.h"
#import "WMPartnerInfo.h"
#import "SeaMenuBar.h"
#import "WMPartnerDetailHeaderView.h"
#import "WMPartnerIntroViewController.h"
#import "WMPartnerTeamViewController.h"
#import "WMPartnerOrderListViewController.h"

@interface WMPartnerDetailViewController ()<SeaMenuBarDelegate,SeaMenuBarDelegate>

///会员信息
@property(nonatomic,strong) WMPartnerInfo *info;

///菜单
@property(nonatomic,strong) SeaMenuBar *menuBar;

///表头
@property(nonatomic,strong) WMPartnerDetailHeaderView *header;

///会员简介
@property(nonatomic,strong) WMPartnerIntroViewController *intro;

///会员团队
@property(nonatomic,strong) WMPartnerTeamViewController *team;

///会员订单
@property(nonatomic,strong) WMPartnerOrderListViewController *orderList;

@end

@implementation WMPartnerDetailViewController

/**构造方法
 *@param info 客户信息
 *@return 一个实例
 */
- (instancetype)initWithPartnerInfo:(WMPartnerInfo*) info
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.title = @"会员详情";
        self.info = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = _SeaViewControllerBackgroundColor_;
    self.backItem = YES;
    
    ///表头
    self.header = [[WMPartnerDetailHeaderView alloc] initWithPartnerInfo:self.info];
    [self.view addSubview:self.header];
    
    NSArray *titles = self.hierarchy <= 1 ? [NSArray arrayWithObjects:@"简介", @"订单", nil] : [NSArray arrayWithObjects:@"简介", @"团队", @"订单", nil];
    ///菜单
    self.menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, self.header.bottom, _width_, _SeaMenuBarHeight_) titles:titles style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
    self.menuBar.selectedIndex = 0;
    self.menuBar.delegate = self;
    self.menuBar.titleFont = [UIFont fontWithName:MainFontName size:16.0];
    self.menuBar.selectedColor = [UIColor blackColor];
    [self.view addSubview:self.menuBar];
    
    [self menuBar:self.menuBar didSelectItemAtIndex:self.menuBar.selectedIndex];
}



#pragma mark- SeaMenuBar delegate

- (void)menuBar:(SeaMenuBar *)menu didSelectItemAtIndex:(NSInteger)index
{
    CGFloat margin = 0;
    CGRect frame = CGRectMake(0, menu.bottom + margin, _width_, self.view.height - menu.height - self.header.height - margin - (isIPhoneX ? 35.0 : 0.0));

    switch (index)
    {
        case 0 :
        {
            if(!self.intro)
            {
                self.intro = [[WMPartnerIntroViewController alloc] initWithPartnerInfo:self.info];
            }
            
            if(self.team)
            {
                [self.team.view removeFromSuperview];
                [self.team removeFromParentViewController];
            }
            
            if(self.orderList)
            {
                [self.orderList.view removeFromSuperview];
                [self.orderList removeFromParentViewController];
            }
            
            [self.intro willMoveToParentViewController:self];
            self.intro.view.frame = frame;
            [self.view addSubview:self.intro.view];
            [self addChildViewController:self.intro];
            [self.intro didMoveToParentViewController:self];
        }
            break;
        default:
        {
            if(index == 1 && self.hierarchy > 1)
            {
                if(!self.team)
                {
                    self.team = [[WMPartnerTeamViewController alloc] initWithPartnerInfo:self.info];
                }
                
                if(self.intro)
                {
                    [self.intro.view removeFromSuperview];
                    [self.intro removeFromParentViewController];
                }
                
                if(self.orderList)
                {
                    [self.orderList.view removeFromSuperview];
                    [self.orderList removeFromParentViewController];
                }
                
                [self.team willMoveToParentViewController:self];
                self.team.view.frame = frame;
                [self.view addSubview:self.team.view];
                [self addChildViewController:self.team];
                [self.team didMoveToParentViewController:self];
            }
            else
            {
                if(!self.orderList)
                {
                    self.orderList = [[WMPartnerOrderListViewController alloc] initWithPartnerInfo:self.info];
                    self.orderList.isSeeSecondReferral = self.isSeeSecondReferral;
                }
                
                if(self.team)
                {
                    [self.team.view removeFromSuperview];
                    [self.team removeFromParentViewController];
                }
                
                if(self.intro)
                {
                    [self.intro.view removeFromSuperview];
                    [self.intro removeFromParentViewController];
                }
                
                [self.orderList willMoveToParentViewController:self];
                self.orderList.view.frame = frame;
                [self.view addSubview:self.orderList.view];
                [self addChildViewController:self.orderList];
                [self.orderList didMoveToParentViewController:self];
            }
        }
            break;
    }
}

@end
