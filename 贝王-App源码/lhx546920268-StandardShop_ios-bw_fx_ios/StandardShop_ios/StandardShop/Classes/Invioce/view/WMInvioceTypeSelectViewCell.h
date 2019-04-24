//
//  WMInvioceTypeSelectViewCell.h
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMInvioceTypeSelectViewCellIden @"WMInvioceTypeSelectViewCellIden"
#define WMInvioceTypeSelectViewCellHeight 80

///发票类型选择
@interface WMInvioceTypeSelectViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题文本
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**不开发票
 */
@property (weak, nonatomic) IBOutlet UIButton *unInvioceButton;
/**个人发票
 */
@property (weak, nonatomic) IBOutlet UIButton *personalButton;
/**公司发票
 */
@property (weak, nonatomic) IBOutlet UIButton *companyButton;

- (void)configureCellWithModel:(id)model;
@end
