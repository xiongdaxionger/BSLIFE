//
//  WMOrderBuyAgainViewCell.h
//  StandardShop
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMOrderBuyAgainViewCellIden @"WMOrderBuyAgainViewCellIden"
#define WMOrderBuyAgainViewCellHeight 40
/**订单的再次购买
 */
@interface WMOrderBuyAgainViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**再次购买
 */
@property (weak, nonatomic) IBOutlet UIButton *buyAgainButton;

/**我要取货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sinceCodeButton;

/**我要取货按钮宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinceCodeWidth;

///右侧距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinceCodeRIght;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;




@end
