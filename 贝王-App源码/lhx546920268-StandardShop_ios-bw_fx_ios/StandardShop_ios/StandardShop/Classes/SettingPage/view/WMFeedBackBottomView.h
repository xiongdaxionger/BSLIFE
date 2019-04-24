//
//  WMFeedBackBottomView.h
//  WanShoes
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///意见反馈底部视图
@interface WMFeedBackBottomView : UIView

/**回调
 */
@property (copy,nonatomic) void(^actionCallBack)(void);

@end
