//
//  WMGoodCommentReplyViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

@class WMGoodCommentInfo;

///商品评价回复
@interface WMGoodCommentReplyViewController : SeaDialogViewController

///回复的评价信息
@property(nonatomic,strong) WMGoodCommentInfo *info;

///回复所需的验证码链接，无表示不需要验证码
@property(nonatomic,copy) NSString *codeURL;

///回复完成回调 info 新的评价信息，如果回复需要审核，则为nil
@property(nonatomic,copy) void(^replyCompletionHandler)(WMGoodCommentInfo *info);

@end
