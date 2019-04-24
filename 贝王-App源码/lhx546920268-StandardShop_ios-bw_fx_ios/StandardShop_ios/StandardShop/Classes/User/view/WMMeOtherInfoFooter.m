//
//  WMMeOtherInfoFooter.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeOtherInfoFooter.h"
#import "WMCouponsListViewController.h"
#import "WMUserInfo.h"
#import "WMMyIntegralViewController.h"
#import "WMBillListManagerViewController.h"
#import "WMBalanceViewController.h"
#import "WMMeViewController.h"

///Cell
@interface WMMeOtherInfoFooterCell : UIView

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///副标题
@property(nonatomic,readonly) UILabel *subtitleLabel;

@end

@implementation WMMeOtherInfoFooterCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat margin = 5.0;
        CGFloat topMargin = 20.0 * WMDesignScale;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:15.0];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, topMargin, self.width - margin * 2, font.lineHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = font;
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        
        font = [UIFont fontWithName:MainFontName size:12.0];
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, frame.size.height - font.lineHeight - topMargin, self.width - margin * 2, font.lineHeight)];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = font;
        _subtitleLabel.textColor = [UIColor blackColor];
        [self addSubview:_subtitleLabel];
    }
    
    return self;
}

@end

///起始tag
#define WMMeOtherInfoFooterStartTag 1000

@interface WMMeOtherInfoFooter()

@end

@implementation WMMeOtherInfoFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = _SeaViewControllerBackgroundColor_;

        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(-_separatorLineWidth_, 10.0, frame.size.width + _separatorLineWidth_ * 2, frame.size.height - 10.0 * 2)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.borderColor = _separatorLineColor_.CGColor;
        contentView.layer.borderWidth = _separatorLineWidth_;
        [self.contentView addSubview:contentView];
        
        NSArray *titles = [NSArray arrayWithObjects:@"贝壳", @"优惠券", @"积分", nil];
        
        CGFloat width = self.width / titles.count;
        
        for(NSInteger i = 0;i < titles.count;i ++)
        {
            WMMeOtherInfoFooterCell *cell = [[WMMeOtherInfoFooterCell alloc] initWithFrame:CGRectMake(width * i, 0, width, contentView.height)];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidClick:)];
            [cell addGestureRecognizer:tap];
            
            cell.tag = i + WMMeOtherInfoFooterStartTag;
            cell.subtitleLabel.text = [titles objectAtIndex:i];
            [contentView addSubview:cell];
        }
    }
    
    return self;
}

///点击按钮
- (void)buttonDidClick:(UITapGestureRecognizer*) tap
{
    NSInteger index = tap.view.tag - WMMeOtherInfoFooterStartTag;
    if(![AppDelegate instance].isLogin)
    {
        WeakSelf(self);
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil loginCompletion:^(void){
            [weakSelf clickAtIndex:index];
        }];
    }
    else
    {
        [self clickAtIndex:index];
    }
}

///点击某个按钮
- (void)clickAtIndex:(NSInteger) index
{
    UIViewController *vc = nil;
    
    switch (index)
    {
        case 0 :
        {
            WMBalanceViewController *balance = [[WMBalanceViewController alloc] init];
            vc = balance;
            self.meViewController.shouldChangeStatusBarStyle = NO;
        }
            break;
        case 1 :
        {
            WMCouponsListViewController *coupons = [[WMCouponsListViewController alloc] init];
            vc = coupons;
        }
            break;
        case 2 :
        {
            WMMyIntegralViewController *integral = [[WMMyIntegralViewController alloc] init];
            vc = integral;
            self.meViewController.shouldChangeStatusBarStyle = NO;
        }
            break;
        case 3 :
        {
            WMBillListManagerViewController *bill = [[WMBillListManagerViewController alloc] init];
            vc = bill;
        }
            break;
        default:
            break;
    }
    
    if(vc)
    {
        [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self.meViewController];
    }
}

///获取对应按钮
- (WMMeOtherInfoFooterCell*)buttonForIndex:(NSInteger) index
{
    return (WMMeOtherInfoFooterCell*)[self viewWithTag:WMMeOtherInfoFooterStartTag + index];
}

///刷新数据
- (void)reloadData
{
    WMMeOtherInfoFooterCell *btn = [self buttonForIndex:0];
    if([AppDelegate instance].isLogin)
    {
        WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
        
        if([NSString isEmpty:userInfo.personCenterInfo.balance])
        {
            btn.titleLabel.text = @"0";
        }
        else
        {
            NSMutableAttributedString *attr = [WMPriceOperation formatPrice:userInfo.personCenterInfo.balance font:[UIFont fontWithName:MainFontName size:17.0]];
            [attr addAttribute:NSForegroundColorAttributeName value:btn.titleLabel.textColor range:NSMakeRange(0, attr.length)];
            btn.titleLabel.attributedText = attr;
        }
        
        btn = [self buttonForIndex:1];
        btn.titleLabel.text = [NSString stringWithFormat:@"%d", userInfo.personCenterInfo.couponCount];
        
        btn = [self buttonForIndex:2];
        btn.titleLabel.text = [NSString isEmpty:userInfo.personCenterInfo.integral] ? @"0" : userInfo.personCenterInfo.integral;
    }
    else
    {
        btn.titleLabel.text = @"0";
        
        btn = [self buttonForIndex:1];
        btn.titleLabel.text = @"0";
        
        btn = [self buttonForIndex:2];
        btn.titleLabel.text = @"0";
    }
}

@end
