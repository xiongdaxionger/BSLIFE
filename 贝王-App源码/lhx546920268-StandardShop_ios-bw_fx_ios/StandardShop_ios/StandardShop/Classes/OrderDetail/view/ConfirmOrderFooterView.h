//
//  ConfirmOrderFooterView.h
//  WuMei
//
//  Created by qsit on 15/8/15.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderFooterView : UIView
/**开始倒计时
 */
- (void)start;
/**停止倒计时
 */
- (void)stop;
/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame timeInterval:(NSTimeInterval)time;
/**倒计时结束的回调
 */
@property (copy,nonatomic) void(^timeOut)(void);
@end
