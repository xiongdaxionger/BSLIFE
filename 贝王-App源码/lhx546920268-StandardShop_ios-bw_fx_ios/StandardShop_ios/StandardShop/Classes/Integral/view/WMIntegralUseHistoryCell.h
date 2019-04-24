//
//  MYsoureTableViewCell.h
//  WuMei
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMIntegralHistoryInfo;

///行高
#define WMIntegralUseHistoryCellHeight 75.0

///积分使用记录cell
@interface WMIntegralUseHistoryCell : UITableViewCell

///积分按钮宽度约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *integral_btn_widthConstraint;

///积分按钮
@property (strong, nonatomic) IBOutlet UIButton *integral_btn;

///时间
@property (strong, nonatomic) IBOutlet UILabel *time_label;

///内容
@property (strong, nonatomic) IBOutlet UILabel *content_label;

///分割线
@property (weak, nonatomic) IBOutlet UIView *line;

///积分信息
@property(nonatomic,strong) WMIntegralHistoryInfo *info;

///分割线高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@end
