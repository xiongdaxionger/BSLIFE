//
//  WMShakeDialog.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMShakeResultInfo.h"

///摇一摇弹窗
@interface WMShakeDialog : UIView

///弹窗关闭回调
@property(nonatomic,copy) void(^closeHandler)(void);

///摇一摇结果
@property(nonatomic,strong) WMShakeResultInfo *info;

@end
