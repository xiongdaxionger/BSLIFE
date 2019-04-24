//
//  WMInviteRegisterQRCodeViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

///邀请注册二维码
@interface WMInviteRegisterQRCodeViewController : SeaViewController

///白色背景
@property (weak, nonatomic) IBOutlet UIView *white_bgView;

///白色背景高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *white_bgView_heightConstraint;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///灰色分割线
@property (weak, nonatomic) IBOutlet SeaDashView *dash_view;

///二维码图片
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_imageView;


@end
