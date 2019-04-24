//
//  WMOrderIDViewCell.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMOrderIDViewCellIdentifier @"WMOrderIDViewCellIdentifier"
#define WMOrderIDViewCellHegith 40

/**订单号展示
 */
@interface WMOrderIDViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**订单号文本
 */
@property (weak, nonatomic) IBOutlet UIButton *orderIDLabel;
/**订单号文本宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderIDWidth;
/**订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
