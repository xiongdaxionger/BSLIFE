//
//  WMOrderDeadViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMOrderDeadViewCellIden @"WMOrderDeadViewCell"
#define WMOrderDeadViewCellHeight 40
/**作废订单
 */
@interface WMOrderDeadViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**删除订单
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
/**再次购买
 */
@property (weak, nonatomic) IBOutlet UIButton *buyAgainButton;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
