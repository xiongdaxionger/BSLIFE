//
//  WMImageVerificationCodeView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///图形验证码视图
@interface WMImageVerificationCodeView : UIView<UITextFieldDelegate>

///输入框
@property(nonatomic,readonly) UITextField *textField;

///图形验证码
@property(nonatomic,readonly) UIImageView *code_imageView;

///验证码链接
@property(nonatomic,copy) NSString *codeURL;

///刷新验证码
- (void)refreshCode;

@end
