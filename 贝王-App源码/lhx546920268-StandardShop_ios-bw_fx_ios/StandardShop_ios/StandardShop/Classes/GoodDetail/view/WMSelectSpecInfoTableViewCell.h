//
//  WMSelectSpecInfoTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMSelectSpecInfoTableViewCellIden @"WMSelectSpecInfoTableViewCellIden"
#define WMSelectSpecInfoTableViewCellHeight 48.0
#define WMSelectSpecInfoTableViewCellExtraWidth 106.0

/**商品的规格选择
 */
@interface WMSelectSpecInfoTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**选择规格
 */
@property (weak, nonatomic) IBOutlet UILabel *specInfoLabel;
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
