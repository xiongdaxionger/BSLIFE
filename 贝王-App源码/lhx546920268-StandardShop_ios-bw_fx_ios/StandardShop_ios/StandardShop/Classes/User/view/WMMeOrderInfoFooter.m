//
//  WMMeOrderInfoFooter.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMMeOrderInfoFooter.h"
#import "WMOrderManagerController.h"
#import "WMUserInfo.h"
#import "WMMeOrderButton.h"

@implementation WMMeOrderInfoFooterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.frame = self.bounds;
        [self addSubview:_button];
        
        UIImage *image = [UIImage imageNamed:@"order_waitePay"];
        
        _badge = [[SeaNumberBadge alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width) / 2.0 + image.size.width - _badgeViewWidth_ / 2.0, (self.height - image.size.height - 17.0) / 2.0 - _badgeViewHeight_ / 2.0 + 5.0 * WMDesignScale, _badgeViewWidth_, _badgeViewHeight_)];
        _badge.textColor = [UIColor whiteColor];
        _badge.userInteractionEnabled = NO;
        [self addSubview:_badge];
    }
    
    return self;
}

@end

///起始tag
#define WMMeOrderInfoFooterStartTag 1000

@implementation WMMeOrderInfoFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];

        NSArray *icons = [NSArray arrayWithObjects:@"order_waitePay", @"order_delivery", @"order_waiteGoods", @"order_waiteComment", nil];
        NSArray *titles = [NSArray arrayWithObjects:@"待付款", @"待发货", @"待收货", @"待评价", @"", nil];
        
        CGFloat lastWidth = 83.0;
        CGFloat width = (self.width - lastWidth) / (titles.count - 1);
        CGFloat margin = 0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:12.0];
        for(NSInteger i = 0;i < titles.count;i ++)
        {
            CGRect frame = CGRectMake((margin + width) * i, 0, width, WMMeOrderInfoFooterHeight);
            if(i != titles.count - 1)
            {
                WMMeOrderInfoFooterCell *cell = [[WMMeOrderInfoFooterCell alloc] initWithFrame:frame];
                [cell.button setImage:[UIImage imageNamed:[icons objectAtIndex:i]] forState:UIControlStateNormal];
                cell.button.titleLabel.font = font;
                [cell.button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.tag = i + WMMeOrderInfoFooterStartTag;
                
                [cell.button setButtonIconToTopAndTitleBottomWithInterval:5.0];
                [self.contentView addSubview:cell];
            }
            else
            {
                frame.size.width = lastWidth;
                WMMeOrderButton *btn = [[WMMeOrderButton alloc] init];
                btn.title_label.font = font;
                btn.frame = frame;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                [btn addGestureRecognizer:tap];
                [self.contentView addSubview:btn];
            }
        }
    }
    
    return self;
}

///点击按钮
- (void)buttonDidClick:(UIButton*) btn
{
    NSInteger index = (btn.superview.tag - WMMeOrderInfoFooterStartTag) + 1;
    if(![AppDelegate instance].isLogin)
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [weakSelf clickAtIndex:index];
        }];
        return;
    }
    else
    {
        [self clickAtIndex:index];
    }
}

///点击全部订单
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    if(![AppDelegate instance].isLogin)
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            
            [weakSelf clickAtIndex:0];
        }];
        return;
    }
    else
    {
        [self clickAtIndex:0];
    }
}

///点击某个按钮
- (void)clickAtIndex:(NSInteger) index
{
    WMOrderManagerController *orderController = [[WMOrderManagerController alloc] init];
    orderController.segementIndex = 0;
    orderController.seaMenuBarIndex = index;
    
    [SeaPresentTransitionDelegate pushViewController:orderController useNavigationBar:YES parentedViewConttroller:self.navigationController];
}

///刷新数据
- (void)reloadData
{
    WMMeOrderInfoFooterCell *cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag];
    if([AppDelegate instance].isLogin)
    {
        WMUserInfo *info = [WMUserInfo sharedUserInfo];
        
        cell.badge.value = [NSString stringWithFormat:@"%d", info.personCenterInfo.orderWaitePayCount];
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 1];
        cell.badge.value = [NSString stringWithFormat:@"%d", info.personCenterInfo.orderWaiteDeliveryCount];
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 2];
        cell.badge.value = [NSString stringWithFormat:@"%d", info.personCenterInfo.orderWaiteGoodsCount];
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 3];
        cell.badge.value = [NSString stringWithFormat:@"%d", info.personCenterInfo.orderWaiteCommentCount];
    }
    else
    {
        cell.badge.value = nil;
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 1];
        cell.badge.value = nil;
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 2];
        cell.badge.value = nil;
        
        cell = (WMMeOrderInfoFooterCell*)[self viewWithTag:WMMeOrderInfoFooterStartTag + 3];
        cell.badge.value = nil;
    }
}

@end
