//
//  WMShakeTomorrowDialog.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMShakeDialog.h"

///摇一摇明日再战弹窗
@interface WMShakeTomorrowDialog : WMShakeDialog

///关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *close_btn;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///明日再战
@property (weak, nonatomic) IBOutlet UIButton *tomorrow_btn;


///提示信息
@property (copy, nonatomic) NSString *message;

@end
