//
//  WMMeHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMMeHeaderViewHeight 176.0

///个人中心头部
@interface WMMeHeaderView : UICollectionReusableView

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///等级背景
@property (weak, nonatomic) IBOutlet UIView *level_bgView;

///等级
@property (weak, nonatomic) IBOutlet UILabel *level_label;

///账户管理
@property (weak, nonatomic) IBOutlet UIButton *account_btn;

///登录
@property (weak, nonatomic) IBOutlet UIButton *login_btn;

///跳转导航
@property (weak, nonatomic) UINavigationController *navigationController;

///刷新数据
- (void)reloadData;

@end
