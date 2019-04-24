//
//  WMOrderDetailBarCodeViewCell.h
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMOrderDetailBarCodeViewCellHeight 140.0
#define WMOrderDetailBarCodeViewCellIden @"WMOrderDetailBarCodeViewCellIden"
@interface WMOrderDetailBarCodeViewCell : UITableViewCell<XTableCellConfigExDelegate>

///订单号
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;

///条形码
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImage;

///配置数据
- (void)configureCellWithModel:(id)model;
@end
