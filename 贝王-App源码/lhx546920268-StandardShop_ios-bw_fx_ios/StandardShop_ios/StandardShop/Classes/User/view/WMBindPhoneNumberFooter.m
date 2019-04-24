//
//  WMBindPhoneNumberFooter.m
//  StandardShop
//
//  Created by 罗海雄 on 16/9/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBindPhoneNumberFooter.h"

@implementation WMBindPhoneNumberFooter

- (instancetype)init
{
    return [self initWithReuseIdentifier:@"WMBindPhoneNumberFooter"];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
     
        CGFloat margin = 15.0;
        ///提示信息
        _msg_label = [[UILabel alloc] initWithFrame:CGRectMake(margin, 10.0, _width_ - margin * 2, 0)];
        _msg_label.font = [UIFont fontWithName:MainFontName size:13.0];
        _msg_label.numberOfLines = 0;
        _msg_label.textColor = WMRedColor;
        [self.contentView addSubview:_msg_label];
        
        ///确认按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin, 30.0, _width_ - margin * 2, WMLongButtonHeight);
        btn.backgroundColor = WMButtonBackgroundColor;
        btn.layer.cornerRadius = WMLongButtonCornerRaidus;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = WMLongButtonTitleFont;
        [self.contentView addSubview:btn];
        _confirm_btn = btn;
    }
    
    return self;
}

///设置提示信息
- (void)setMsg:(NSString*) msg
{
    _msg_label.text = msg;
    if([NSString isEmpty:msg])
    {
        _msg_label.height = 0;
        _confirm_btn.top = 30.0;
    }
    else
    {
        _msg_label.height = [_msg_label.text stringSizeWithFont:_msg_label.font contraintWith:_msg_label.width].height + 1.0;
        _confirm_btn.top = _msg_label.bottom + _msg_label.top;
    }
}

///获取高度
- (CGFloat)footerHeight
{
    return _confirm_btn.bottom;
}

@end
