//
//  WMMeHeaderView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeHeaderView.h"
#import "WMUserInfo.h"
#import "WMMyInfoViewController.h"
#import "WMUserLevelInfoViewController.h"

@implementation WMMeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorFromHexadecimal:@"FF4444"];
    self.login_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:18.0];
    self.head_imageView.layer.cornerRadius = self.head_imageView.sea_widthLayoutConstraint.constant / 2.0;
    self.head_imageView.layer.masksToBounds = YES;
    self.head_imageView.layer.borderWidth = 3.0;
    self.head_imageView.layer.borderColor = [UIColor colorFromHexadecimal:@"FF8F8F"].CGColor;
    self.head_imageView.sea_placeHolderImage = [UIImage imageNamed:@"default_head_image"];
    
    self.name_label.font = [UIFont fontWithName:MainFontName size:16.0];
    
    self.level_label.font = [UIFont fontWithName:MainFontName size:13.0];
    self.level_label.textColor = [UIColor whiteColor];
    self.level_bgView.layer.cornerRadius = 7.0;
    self.level_bgView.backgroundColor = [UIColor colorFromHexadecimal:@"d43522"];
    self.level_bgView.layer.masksToBounds = YES;
    
    [self.level_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLevel:)]];
    
    self.head_imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeadImageView:)];
    [self.head_imageView addGestureRecognizer:tap];
    self.account_btn.titleLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    [self.account_btn setButtonIconToRightWithInterval:5.0];
}

///账户管理
- (IBAction)accountAction:(id)sender
{
    WMMyInfoViewController *info = [[WMMyInfoViewController alloc] init];
    [self presentViewController:info];
}

///登录注册
- (IBAction)loginAction:(id)sender
{
    [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil];
}

///刷新数据
- (void)reloadData
{
    if([AppDelegate instance].isLogin)
    {
        WMUserInfo *info = [WMUserInfo sharedUserInfo];
        [self.head_imageView sea_setImageWithURL:info.headImageURL];
        self.name_label.text = info.displayName;
        self.level_label.text = info.level;
        self.name_label.hidden = NO;
        self.level_label.hidden = NO;
        self.level_bgView.hidden = NO;
        self.login_btn.hidden = YES;
        self.account_btn.hidden = NO;
    }
    else
    {
        [self.head_imageView sea_setImageWithURL:nil];
        self.name_label.hidden = YES;
        self.level_label.hidden = YES;
        self.level_bgView.hidden = YES;
        self.login_btn.hidden = NO;
        self.account_btn.hidden = YES;
    }
}

#pragma mark- action

///点击头像
- (void)handleTapHeadImageView:(UITapGestureRecognizer*) tap
{
    if([AppDelegate instance].isLogin)
    {
        WMMyInfoViewController *info = [[WMMyInfoViewController alloc] init];
        [self presentViewController:info];
    }
    else
    {
        [[AppDelegate instance] showLoginViewControllerWithAnimate:YES completion:nil];
    }
}

///等级
- (void)handleTapLevel:(UITapGestureRecognizer*) tap
{
    WMUserLevelInfoViewController *level = [[WMUserLevelInfoViewController alloc] init];
    [self presentViewController:level];
}

- (void)presentViewController:(UIViewController*) vc
{
    [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self.navigationController];
}

@end
