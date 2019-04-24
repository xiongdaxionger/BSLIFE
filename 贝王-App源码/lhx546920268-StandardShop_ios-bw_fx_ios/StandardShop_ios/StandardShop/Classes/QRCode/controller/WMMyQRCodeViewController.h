//
//  WMMyQRCodeViewController.h
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMShareActionSheetContentView;

///我的二维码类型
typedef NS_ENUM(NSInteger, WMMyQRCodeType) {

    ///分享时生成二维码
    WMMyQRCodeTypeShare,
    
    ///添加会员
    WMMyQRCodeTypeAddPartner,
};

///二维码
@interface WMMyQRCodeViewController : SeaViewController

///白色背景
@property (weak, nonatomic) IBOutlet UIView *white_bgView;

///白色背景高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *white_bgView_heightConstraint;

///白色背景顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *white_bgView_topLayoutConstraint;

///昵称
@property (weak, nonatomic) IBOutlet UILabel *name_label;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///灰色分割线
@property (weak, nonatomic) IBOutlet SeaDashView *dash_view;

///二维码图片
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_imageView;

///微信朋友圈分享标题
@property (weak, nonatomic) IBOutlet UILabel *weixin_timeline_title_label;

///保存到手机
@property (weak, nonatomic) IBOutlet UILabel *save_title_label;

///微信朋友分享标题
@property (weak, nonatomic) IBOutlet UILabel *weixin_friend_title_label;

///关联的分享视图
@property (strong, nonatomic) WMShareActionSheetContentView *shareContentView;

///二维码类型
@property (assign, nonatomic) WMMyQRCodeType QRCodeType;

@end
