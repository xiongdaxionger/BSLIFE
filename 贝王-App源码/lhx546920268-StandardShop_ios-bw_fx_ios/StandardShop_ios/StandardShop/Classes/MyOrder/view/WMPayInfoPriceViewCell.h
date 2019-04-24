//
//  WMPayInfoPriceViewCell.h
//  WestMailDutyFee
//
//  Created by qsit on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMPayInfoPriceViewCellIden @"WMPayInfoPriceViewCellIden"
#define WMPayInfoPriceViewCellHeight 55
@interface WMPayInfoPriceViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**支付信息
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
