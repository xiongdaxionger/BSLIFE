//
//  WMOrderDetailIDViewCell.h
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMOrderDetailIDViewCellIden @"WMOrderDetailIDViewCellIden"
#define WMOrderDetailIDViewCellHeight 44
/**订单号显示
 */
@interface WMOrderDetailIDViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**订单号文本
 */
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
