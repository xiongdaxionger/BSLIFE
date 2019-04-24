//
//  WMIntegralSignInHeaderView.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/18.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///头部高度
#define WMIntegralSignInHeaderViewHeight (_width_ * 300.0 / 1242.0 + 180 + 50.0)

///头部高度 没商品
#define WMIntegralSignInHeaderViewNoGoodsHeight (_width_ * 300.0 / 1242.0 + 180)

@class WMIntegralSignInInfo;

///积分签到头部
@interface WMIntegralSignInHeaderView : UICollectionReusableView

///顶部红色背景
@property (weak, nonatomic) IBOutlet UIView *top_bg_view;

///背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bg_imageVIew;

///连续签到详情
@property (weak, nonatomic) IBOutlet UILabel *day_detail_label;

///日历图标
@property (weak, nonatomic) IBOutlet UIImageView *calendar_imageView;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///积分背景
@property (weak, nonatomic) IBOutlet UIView *integral_bg_view;

///积分规则标题
@property (weak, nonatomic) IBOutlet UILabel *rule_title_label;

///积分规则副标题
@property (weak, nonatomic) IBOutlet UILabel *rule_subtitle_label;

///积分钱图标
@property (weak, nonatomic) IBOutlet UIImageView *integral_money_imageView;

///积分钱包图标
@property (weak, nonatomic) IBOutlet UIImageView *integral_wallet_imageView;

///积分猪图标
@property (weak, nonatomic) IBOutlet UIImageView *integral_pig_imageView;

///分享按钮
@property (weak, nonatomic) IBOutlet UIButton *share_btn;

///我的积分按钮
@property (weak, nonatomic) IBOutlet UIButton *my_integral_btn;

///商品换购头部背景
@property (weak, nonatomic) IBOutlet UIView *good_header_bg_view;

///换购按钮
@property (weak, nonatomic) IBOutlet UIButton *title_btn;

///签到信息
@property (strong, nonatomic) WMIntegralSignInInfo *info;

///跳转导航
@property (weak, nonatomic) UINavigationController *navigationController;

@end
