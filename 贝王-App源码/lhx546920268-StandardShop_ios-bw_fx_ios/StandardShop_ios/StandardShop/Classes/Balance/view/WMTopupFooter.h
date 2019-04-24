//
//  WMTopupFooter.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///高度
#define WMTopupFooterHeight 49.0

///充值底部菜单
@interface WMTopupFooter : UIView

///充值金额
@property(nonatomic,readonly) UILabel *amountLabel;

///充值按钮
@property(nonatomic,readonly) UIButton *topupButton;

@end
