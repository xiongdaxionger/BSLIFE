//
//  WMPassManageCommonViewCell.h
//  WestMailDutyFee
//
//  Created by qsit on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#define kWMPassManageCommonViewCellIden @"WMPassManageCommonViewCell"
#define kWMPassManageCommonViewCellHeight 44

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

///密码管理cell
@interface WMPassManageCommonViewCell : UITableViewCell<XTableCellConfigExDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commonLabel;

@end
