//
//  WMCouponsListHeaderView.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCouponsListHeaderView.h"
#import "WMCouponsUseIntroViewController.h"

@implementation WMCouponsListHeaderView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _SeaMenuBarHeight_ + 45.0)];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat margin = 25.0;
 
        _menuBar = [[SeaMenuBar alloc] initWithFrame:CGRectMake(0, 0, self.width, _SeaMenuBarHeight_) titles:[NSArray arrayWithObjects:@"可用", @"失效", nil] style:SeaMenuBarStyleItemWithRelateTitleInFullScreen];
        _menuBar.topSeparatorLine.hidden = YES;
        _menuBar.selectedIndex = 0;
        [self addSubview:_menuBar];
        
        CGFloat buttonWidth = self.width - margin * 2;
        CGFloat buttonHeight = self.height - _menuBar.bottom - 16.0;
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:MainTextColor forState:UIControlStateNormal];
        [_button setTitle:@"优惠券使用说明" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontWithName:MainFontName size:16];
        [_button setBackgroundColor:[UIColor clearColor]];
        [_button setFrame:CGRectMake(margin, _menuBar.bottom + 8.0, buttonWidth, buttonHeight)];
//        _button.layer.cornerRadius = 5.0;
//        _button.layer.masksToBounds = YES;
//        _button.layer.borderColor = _separatorLineColor_.CGColor;
//        _button.layer.borderWidth = _separatorLineWidth_;
        [_button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
    }
    
    return self;
}

///点击
- (void)buttonDidClick:(id) sender
{
    WMCouponsUseIntroViewController *coupons = [[WMCouponsUseIntroViewController alloc] init];
    [self.navigationController pushViewController:coupons animated:YES];
}

@end
