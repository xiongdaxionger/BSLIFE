//
//  WMRefundGoodTypeViewCell.h
//  WanShoes
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMRefundGoodTypeViewCellHeight 44
#define WMRefundGoodTypeViewCellIden @"WMRefundGoodTypeViewCellIden"
@interface WMRefundGoodTypeViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**类型名称
 */
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
/**勾选按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
- (void)configureCellWithModel:(id)model;
@end
