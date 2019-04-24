//
//  WMMyIntegralTableHeader.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMIntegralInfo;

///我的积分表头
@interface WMMyIntegralTableHeader : UIView

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///积分
@property (weak, nonatomic) IBOutlet UILabel *integral_label;

///冻结积分
@property (weak, nonatomic) IBOutlet UILabel *freeze_label;

///积分使用按钮
@property (weak, nonatomic) IBOutlet UIButton *use_btn;

///积分信息
@property (strong, nonatomic) WMIntegralInfo *info;

///跳转导航
@property (weak, nonatomic) UINavigationController *navigationController;

@end
