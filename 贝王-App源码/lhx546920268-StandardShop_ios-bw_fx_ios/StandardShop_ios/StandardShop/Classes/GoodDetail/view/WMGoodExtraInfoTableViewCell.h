//
//  WMGoodExtraInfoTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/12.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMGoodExtraInfoTableViewCellIden @"WMGoodExtraInfoTableViewCell"
#define WMGoodExtraInfoTableViewCellHeight 54.0

/**商品详情扩展参数显示单元格
 */
@interface WMGoodExtraInfoTableViewCell : UITableViewCell
/**扩展参数值
 */
@property (weak, nonatomic) IBOutlet UILabel *extraInfoNameLabel;
/**扩展参数内容
*/
@property (weak, nonatomic) IBOutlet UILabel *extraInfoContentLabel;

/**配置数据
 */
- (void)configureWithDict:(NSDictionary *)dict;
@end
