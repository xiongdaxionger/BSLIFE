//
//  WMPartnerInviteQRCodeViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 17/2/16.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

///会员邀请注册二维码
@interface WMPartnerInviteQRCodeViewController : SeaViewController

///白色背景
@property (weak, nonatomic) IBOutlet UIView *white_bgView;

///二维码图片
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_imageView;

///微信朋友圈分享标题
@property (weak, nonatomic) IBOutlet UILabel *weixin_timeline_title_label;

///保存到手机
@property (weak, nonatomic) IBOutlet UILabel *save_title_label;

///微信朋友分享标题
@property (weak, nonatomic) IBOutlet UILabel *weixin_friend_title_label;

//标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

//副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;

//标题左边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_label_leftLayoutConstraint;

//标题右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_label_rightLayoutConstraint;

@end
