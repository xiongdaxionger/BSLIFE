//
//  WMOrderWaitPayViewCell.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMOrderWaitPayViewCellIdentifier @"WMOrderWaitPayViewCellIdentifier"
#define WMOrderWaitPayViewCellHeight 40
/**订单再次支付
 */
@interface WMOrderWaitPayViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/**再次购买按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyAgainButton;
/**支付按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *payButton;
/**付款按钮宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payButtonWidth;
/**付款按钮右侧宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payButtonRight;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
