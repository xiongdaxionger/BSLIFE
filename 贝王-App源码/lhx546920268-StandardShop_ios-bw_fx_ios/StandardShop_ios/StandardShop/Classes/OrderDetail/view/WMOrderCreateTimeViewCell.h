//
//  WMOrderCreateTimeViewCell.h
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMOrderCreateTimeViewCellIden @"WMOrderCreateTimeViewCellIden"
#define WMOrderCreateTimeViewCellHeight 60
#define WMOrderPayTimeViewCellHeight 82

@interface WMOrderCreateTimeViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**订单的下单时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
/**订单的支付时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPayTimeLabel;
/**订单的实付款价格
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
