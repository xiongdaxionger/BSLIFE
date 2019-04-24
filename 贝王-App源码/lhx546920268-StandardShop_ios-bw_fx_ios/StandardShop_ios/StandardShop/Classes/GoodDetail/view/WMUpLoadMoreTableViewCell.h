//
//  WMUpLoadMoreTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMUpLoadMoreTableViewCellHeight 44.0
#define WMUpLoadMoreTableViewCellIden @"WMUpLoadMoreTableViewCellIden"
/**上拉查看图文详情
 */
@interface WMUpLoadMoreTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**上拉按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *upLoadButton;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
