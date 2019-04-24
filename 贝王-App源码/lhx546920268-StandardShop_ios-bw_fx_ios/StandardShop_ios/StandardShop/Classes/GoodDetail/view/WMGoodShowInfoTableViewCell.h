//
//  WMGoodShowInfoTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMGoodShowInfoTableViewCellIden @"WMGoodShowInfoTableViewCellIden"
#define WMGoodShowInfoTableViewCellHeight 48.0
/**商品详情的扩展属性单元格
 */
@interface WMGoodShowInfoTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
