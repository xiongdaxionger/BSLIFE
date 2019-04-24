//
//  WMShakingDialog.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShakeDialog.h"

///状态
typedef NS_ENUM(NSInteger, WMShakingStatus)
{
    ///什么都不做，隐藏
    WMShakingStatusHidden = 0,
    
    ///正在摇
    WMShakingStatusLoading = 1,
    
    ///摇失败
    WMShakingStatusFail = 2,
};

///正在摇弹窗
@interface WMShakingDialog : WMShakeDialog

///活动指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_view;

///文本
@property (weak, nonatomic) IBOutlet UILabel *text_label;

///文本居中约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *text_label_centerXLayoutConstraint;

///状态
@property (assign, nonatomic) WMShakingStatus status;

@end
