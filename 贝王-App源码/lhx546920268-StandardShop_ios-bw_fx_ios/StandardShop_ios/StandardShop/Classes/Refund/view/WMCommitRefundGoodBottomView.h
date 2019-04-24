//
//  WMCommitRefundGoodBottomView.h
//  WanShoes
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCommitRefundGoodBottomView : UIView
/**是否同意售后
 */
@property (assign,nonatomic) BOOL isAgree;
/**点击协议回调
 */
@property (copy,nonatomic) void(^actionCallBack)(void);


@end
