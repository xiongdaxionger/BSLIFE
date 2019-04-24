//
//  WMPrepareTimeViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMPrepareTimeViewCellIden @"WMPrepareTimeViewCellIden"
#define WMPrepareTimeViewCellHeight 35
/**显示预售订单的支付尾款时间
 */
@interface WMPrepareTimeViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**显示尾款支付的终结时间
 */
@property (weak, nonatomic) IBOutlet UILabel *prepareTimeLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
