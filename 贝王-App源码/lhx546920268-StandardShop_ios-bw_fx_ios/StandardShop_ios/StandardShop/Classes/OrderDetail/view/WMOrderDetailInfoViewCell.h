//
//  WMOrderDetailInfoViewCell.h
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMOrderDetailInfoViewCellHeight 44

/**订单详情的基本信息显示
 */
@interface WMOrderDetailInfoViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题信息
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**内容信息
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
