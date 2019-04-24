//
//  WMOrderWaitReceiveViewCell.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMOrderWaitReceiveViewCellIdentifier @"WMOrderWaitReceiveViewCellIdentifier"
#define WMOrderWaitReceiveViewCellHeight 40

/**订单待收货
 */
@interface WMOrderWaitReceiveViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**确认收货
 */
@property (weak, nonatomic) IBOutlet UIButton *orderReceiveButton;
/**查看物流
 */
@property (weak, nonatomic) IBOutlet UIButton *checkExpressButton;
/**再次购买
 */
@property (weak, nonatomic) IBOutlet UIButton *buyAgainButton;
/**确认收货宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderReceiveButtonWidth;
/**确认收货右侧距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderReceiveButtonRight;


- (void)configureCellWithModel:(id)model;
@end
