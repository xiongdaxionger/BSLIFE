//
//  WMBindPhoneNumberFooter.h
//  StandardShop
//
//  Created by 罗海雄 on 16/9/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///绑定手机号底部
@interface WMBindPhoneNumberFooter : UITableViewHeaderFooterView

///确认按钮
@property(nonatomic,readonly) UIButton *confirm_btn;

///提示信息
@property(nonatomic,readonly) UILabel *msg_label;

///设置提示信息
- (void)setMsg:(NSString*) msg;

///获取高度
- (CGFloat)footerHeight;

@end
