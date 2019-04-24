//
//  WMSinceCodeViewCell.h
//  StandardShop
//
//  Created by Hank on 2018/6/20.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMSinceCodeViewCellIden @"WMSinceCodeViewCellIden"
#define WMSinceCodeViewCellHeight 87.0
///自提码显示
@interface WMSinceCodeViewCell : UITableViewCell<XTableCellConfigExDelegate>

///自提码
@property (weak, nonatomic) IBOutlet UILabel *sinceCodeLabel;

///数量
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

///待备货按钮
@property (weak, nonatomic) IBOutlet UIButton *havePrepareButton;

///待备货状态
@property (weak, nonatomic) IBOutlet UILabel *havePrepareLabel;

///第一步横线
@property (weak, nonatomic) IBOutlet UIView *stepOneView;

///出库中按钮
@property (weak, nonatomic) IBOutlet UIButton *outingButton;

///出库状态
@property (weak, nonatomic) IBOutlet UILabel *outingLabel;

///待自提按钮
@property (weak, nonatomic) IBOutlet UIButton *waitGetButton;

///待自提状态
@property (weak, nonatomic) IBOutlet UILabel *waitGetLabel;

///第二步横线
@property (weak, nonatomic) IBOutlet UIView *stepSecondView;

///已自提按钮
@property (weak, nonatomic) IBOutlet UIButton *haveGetButton;

///已自提状态
@property (weak, nonatomic) IBOutlet UILabel *haveGetLaebl;

///第三步横线
@property (weak, nonatomic) IBOutlet UIView *stepThirdView;


@end
