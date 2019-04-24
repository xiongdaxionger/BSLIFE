//
//  WMShakeViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMShakeWinnerView;

@interface WMShakeViewController : SeaViewController

///图标
@property (weak, nonatomic) IBOutlet UIButton *logo_btn;

///图标 顶部边距约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_btn_topLayoutConstraint;

///音乐图标
@property (weak, nonatomic) IBOutlet UIButton *music_btn;

///状态背景
@property (weak, nonatomic) IBOutlet UIView *status_bg_view;

///状态
@property (weak, nonatomic) IBOutlet UILabel *status_label;

///罗盘
@property (weak, nonatomic) IBOutlet UIImageView *compass_imageView;

///罗盘 宽度边距约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *compass_imageView_widthLayoutConstraint;

///人，用于摇一摇晃动
@property (weak, nonatomic) IBOutlet UIImageView *person_imageView;

///居中约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *person_imageView_centerYLayoutConstraint;

///规则按钮
@property (weak, nonatomic) IBOutlet UIButton *rule_btn;

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

///奖励名单
@property (weak, nonatomic) IBOutlet WMShakeWinnerView *winner_view;

@end
