//
//  WMRefundInfoViewCell.h
//  StandardFenXiao
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMRefundInfoViewCellIden @"WMRefundInfoViewCellIden"
#define WMRefundInfoViewCellHeight 69.0
@interface WMRefundInfoViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *infoTittle;
/**内容
 */
@property (weak, nonatomic) IBOutlet UILabel *infoContent;

- (void)configureCellWithModel:(id)model;
@end
