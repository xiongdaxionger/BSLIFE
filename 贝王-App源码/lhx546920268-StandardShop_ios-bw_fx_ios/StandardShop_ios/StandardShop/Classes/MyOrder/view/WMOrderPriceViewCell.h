//
//  WMOrderWaitSendViewCell.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMOrderPriceViewCellIden @"WMOrderPriceViewCellIden"
#define WMOrderPriceViewCellHeight 35
/**价格及运费展示
 */
@interface WMOrderPriceViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**运费文本
 */
@property (weak, nonatomic) IBOutlet UILabel *orderExpressLabel;
/**价格文本
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
