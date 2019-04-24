//
//  WMRefundDetailMoneyViewCell.h
//  StandardShop
//
//  Created by Hank on 16/8/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMRefundDetailMoneyViewCellIden @"WMRefundDetailMoneyViewCellIden"
#define WMRefundDetailMoneyViewCellHeight 85
/**退款详情的退款总计
 */
@interface WMRefundDetailMoneyViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**副标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
/**内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




@end
