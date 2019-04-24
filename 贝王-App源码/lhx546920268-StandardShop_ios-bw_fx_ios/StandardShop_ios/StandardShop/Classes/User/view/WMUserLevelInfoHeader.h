//
//  WMUserLevelInfoHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///用户等级信息表头
@interface WMUserLevelInfoHeader : UIView

///背景
@property (weak, nonatomic) IBOutlet UIImageView *bg_imageView;

///头像
@property (weak, nonatomic) IBOutlet UIImageView *head_imageView;

///右下角地球
@property (weak, nonatomic) IBOutlet UIImageView *earth_imageView;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///等级背景
@property (weak, nonatomic) IBOutlet UIView *level_bgView;

///等级
@property (weak, nonatomic) IBOutlet UILabel *level_label;

///升级进度条
@property (weak, nonatomic) IBOutlet SeaProgressView *level_progressView;

///升级进度文字
@property (weak, nonatomic) IBOutlet UILabel *level_progress_label;

///升级信息
@property (weak, nonatomic) IBOutlet UILabel *levelup_msg_label;

///升级信息 垂直约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelup_msg_label_centerYLayoutConstraint;

///升级信息 左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelup_msg_label_leftLayoutConstraint;

///升级信息 右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelup_msg_label_rightLayoutConstraint;
@end
