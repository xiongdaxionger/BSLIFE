//
//  WMFoundCommentViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

@class WMFoundListInfo,WMFoundCommentInfo;

///发现评论
@interface WMFoundCommentViewController : SeaDialogViewController

///发现信息
@property(nonatomic,strong) WMFoundListInfo *info;

///所需的验证码链接，无表示不需要验证码
@property(nonatomic,copy) NSString *codeURL;

///完成回调 info 新的评价信息，如果回复需要审核，则为nil
@property(nonatomic,copy) void(^commentCompletionHandler)(WMFoundCommentInfo *info);

@end
