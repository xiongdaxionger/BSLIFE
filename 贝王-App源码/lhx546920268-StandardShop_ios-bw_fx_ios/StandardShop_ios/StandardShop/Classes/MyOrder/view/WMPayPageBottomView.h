//
//  WMPayPageBottomView.h
//  StandardShop
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

//上边距
#define WMBottomTopMargin 4.0
//内容边距
#define WMBottomContentContentMargin 10.0
//底部视图的高度
#define WMBottomViewHeight 49.0
/**支付页面的底部视图
 */
@interface WMPayPageBottomView : UIView
/**初始化
 */
- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString isCombinationPay:(BOOL)isCombinationPay;
/**更新按钮标题和状态
 */
- (void)updateButtonTitleStatusWithTitle:(NSString *)title isCombinationPay:(BOOL)isCombinationPay;
/**支付按钮
 */
@property (strong,nonatomic) UIButton *payButton;
/**按钮标题--用于判断能否支付
 */
@property (copy,nonatomic) NSString *titleString;
/**组合支付是否启用
 */
@property (assign,nonatomic) BOOL isCombinationPay;
/**点击支付
 */
@property (copy,nonatomic) void(^payButtonClick)(void);

@end
