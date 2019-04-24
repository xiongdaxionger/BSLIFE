//
//  WMPromotionDropTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMPromotionDropTableViewCellIden @"WMPromotionDropTableViewCellIden"
#define WMPromotionDropTableViewCellHeight 44.0
@class JCTagListView;
/**商品促销--未展开
 */
@interface WMPromotionDropTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**下拉箭头
 */
@property (weak, nonatomic) IBOutlet UIButton *dropDowmButton;
/**标签展示视图
 */
@property (weak, nonatomic) IBOutlet JCTagListView *promotionTagListView;
/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
