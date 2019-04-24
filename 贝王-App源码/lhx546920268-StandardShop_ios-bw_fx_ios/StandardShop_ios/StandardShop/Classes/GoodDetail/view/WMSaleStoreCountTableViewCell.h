//
//  WMSaleStoreCountTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

@class WMGoodDetailInfo;
#define WMSaleStoreCountTableViewCellIden @"WMSaleStoreCountTableViewCellIden"
#define WMSaleStoreCountTableViewCellHeight 44.0

/**商品的月销量和库存显示
 */
@interface WMSaleStoreCountTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentabel;
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
