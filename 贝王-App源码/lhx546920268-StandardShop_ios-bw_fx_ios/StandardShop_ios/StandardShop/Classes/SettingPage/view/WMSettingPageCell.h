//
//  SettingPageCustomViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define kSettingPageCustomViewHeight 49
#define kSettingPageCustomViewIden @"SettingPageCustomViewIden"

///设置列表
@interface WMSettingPageCell : UITableViewCell<XTableCellConfigExDelegate>

///标题
@property (weak, nonatomic) IBOutlet UILabel *settingCustomLabel;

///内容
@property (weak, nonatomic) IBOutlet UILabel *settingCustomContentLabel;

@end
