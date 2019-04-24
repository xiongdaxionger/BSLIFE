//
//  ConfirmOrderBottomView.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ConfirmOrderBottomViewHeight 49.0
/**确认订单的底部视图
 */
@interface ConfirmOrderBottomView : UIView
/**初始化
 */
- (instancetype)initWithOrderPrice:(NSString *)price frame:(CGRect)frame;
/**更改价格
 */
- (void)changePrice:(NSString *)price;
/**点击创建订单按钮
 */
@property (copy,nonatomic) void(^createOrderButtonClick)(UIButton *button);
@end
