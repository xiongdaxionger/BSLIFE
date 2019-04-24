//
//  WMTradePasswordInputView.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMTradePasswordInputView;

/**支付密码输入代理
 */
@protocol WMTradePasswordInputViewDelegate <NSObject>

/**输入密码完成
 */
- (void)tradePasswordInputView:(WMTradePasswordInputView*) view didFinishInputPasswd:(NSString*) passwd;

@end

/**支付密码输入
 */
@interface WMTradePasswordInputView : UIView<UITextFieldDelegate>

@property(nonatomic,weak) id<WMTradePasswordInputViewDelegate> delegate;

/**初始化
 *@param type 类型 0 预存款支付，1提现
 *@param price 充值或提现金额
 */
- (id)initWithType:(int) type price:(NSString*) price;

/**显示
 */
- (void)show;

/**消失
 */
- (void)dismiss;

@end
