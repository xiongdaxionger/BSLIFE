//
//  WMSinceQRCodeView.h
//  StandardShop
//
//  Created by Hank on 2018/6/20.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

///自提码二维码显示
@interface WMSinceQRCodeView : SeaDialog

///图片
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

///回调
@property (copy,nonatomic) void(^closeCallBack)(void);
@end
