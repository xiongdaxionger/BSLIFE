//
//  WMInputCell.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMImageVerificationCodeView.h"

///边距
#define WMInputCellMargin 23.0

///控件之间的间隔
#define WMInputCellInterval 5.0

///字体
#define WMInputCellFont [UIFont fontWithName:MainFontName size:15.0]

@interface WMInputCell : UITableViewCell

/**边距
 */
@property(nonatomic,assign) CGFloat margin;

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**标题宽度 default is 80.0
 */
@property(nonatomic,assign) CGFloat titleWidth;

@end

/**输入框cell
 */
@interface WMInputTextFieldCell : WMInputCell

/**输入框
 */
@property(nonatomic,readonly) UITextField *textField;

@end


/**带有倒计时的输入框
 */
@interface WMInputCountDownTextFieldCell : WMInputTextFieldCell

/**倒计时
 */
@property(nonatomic,readonly) SeaCountDownButton *countDownButton;

@end

/**选择cell
 */
@interface WMInputSelectedCell : WMInputCell

/**内容
 */
@property(nonatomic,readonly) UILabel *contentLabel;

/**设置内容
 */
@property(nonatomic,copy) NSString *content;

/**没有内容时显示的东西
 */
@property(nonatomic,copy) NSString *placeHolder;

/**箭头
 */
@property(nonatomic,readonly) UIImageView *arrowImageView;


@end

/**性别选择
 */
@interface WMInputSexCell : WMInputCell

/**男按钮
 */
@property(nonatomic,readonly) UIButton *boy_btn;

/**女按钮
 */
@property(nonatomic,readonly) UIButton *girl_btn;

@end

/**图形验证码
 */
@interface WMInputImageCodeCell : WMInputCell

///图形验证码
@property(nonatomic,readonly) WMImageVerificationCodeView *codeView;

@end

/**头部
 */
@interface WMRegisterHeader : UIView

///logo
@property(nonatomic,readonly) UIImageView *logoImageView;

@end

/**底部
 */
@interface WMRegisterFooter : UIView

/**注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *register_btn;

///是否可以注册
@property (nonatomic, assign) BOOL enableRegister;

///客服电话
@property (weak, nonatomic) IBOutlet UIButton *service_btn;

///密码可见勾
@property (weak, nonatomic) IBOutlet UIButton *tick_btn;

///提示信息
@property (weak, nonatomic) IBOutlet UILabel *msg_label;

///密码输入框
@property (weak, nonatomic) IBOutlet UITextField *password_textField;

@end
