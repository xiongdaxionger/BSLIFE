//
//  WMRefundButtonViewCell.h
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMRefundButtonViewCellIden @"WMRefundButtonViewCellIden"
#define WMRefundButtonViewCellHeight 40

@interface WMRefundButtonViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**退款状态的显示按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
/**按钮的宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
/**状态
 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
