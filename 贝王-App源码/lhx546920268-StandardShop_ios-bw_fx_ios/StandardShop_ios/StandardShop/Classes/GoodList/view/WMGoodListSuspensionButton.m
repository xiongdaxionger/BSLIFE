//
//  WMGoodListShopcartButton.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListSuspensionButton.h"
#import "WMShopCarViewController.h"

@implementation WMGoodListSuspensionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.layer.cornerRadius = 3.0;

        _shopcart_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shopcart_btn setImage:[UIImage imageNamed:@"goodlist_shopcart_icon"] forState:UIControlStateNormal];
        [_shopcart_btn addTarget:self action:@selector(shopcartAction:) forControlEvents:UIControlEventTouchUpInside];
        _shopcart_btn.frame = CGRectMake(0, 0, self.width, (self.height - 1.0) / 2.0);
        [self addSubview:_shopcart_btn];

        _badge = [[SeaNumberBadge alloc] initWithFrame:CGRectMake(self.width - _badgeViewWidth_ / 1.5, - _badgeViewHeight_ / 3.0, _badgeViewWidth_, _badgeViewHeight_)];
        _badge.userInteractionEnabled = NO;
        [self addSubview:_badge];

        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _shopcart_btn.bottom, self.width, 1.0)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self addSubview:line];

        _scroll_to_top_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scroll_to_top_btn setImage:[UIImage imageNamed:@"scroll_to_top"] forState:UIControlStateNormal];
        _scroll_to_top_btn.frame = CGRectMake(0, line.bottom, self.width, _shopcart_btn.height);
        [_scroll_to_top_btn addTarget:self action:@selector(scrollToTop:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scroll_to_top_btn];
    }
    
    return self;
}

///去购物车列表
- (void)shopcartAction:(id) sender
{
    ///购物车不需要登录
//    if(![AppDelegate instance].isLogin)
//    {
//        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES];
//        
//        return;
//    }
    WMShopCarViewController *shopcart = [[WMShopCarViewController alloc] init];
    shopcart.backItem = YES;
    [self.navigationController pushViewController:shopcart animated:YES];
}

///回到顶部
- (void)scrollToTop:(UIButton*) btn
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

@end
