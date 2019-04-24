//
//  WMTopupAcvitityHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///充值活动头部
@interface WMTopupAcvitityHeader : UIView<UITextFieldDelegate>

///标题
@property(nonatomic,readonly) UILabel *titleLabel;

///输入框
@property(nonatomic,readonly) UITextField *textField;

///充值按钮
@property(nonatomic,readonly) UIButton *topupButton;

@end
