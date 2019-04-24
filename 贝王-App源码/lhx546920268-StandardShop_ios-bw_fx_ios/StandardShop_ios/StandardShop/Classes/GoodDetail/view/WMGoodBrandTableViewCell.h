//
//  WMGoodBrandTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMGoodBrandTableViewCellIden @"WMGoodBrandTableViewCellIden"
#define WMGoodBrandTableViewCellHeight 70.0
/**商品品牌视图
 */
@interface WMGoodBrandTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**品牌Logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
/**品牌名称
 */
@property (weak, nonatomic) IBOutlet UILabel *brandName;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
