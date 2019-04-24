//
//  WMHomeAdDialog.h
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

///首页的广告弹窗
@interface WMHomeAdDialog : SeaDialog

///广告图
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

///关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

///点击回调
@property (copy,nonatomic) void(^tapCallBack)(void);
@end
