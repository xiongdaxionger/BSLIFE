//
//  WMPromotionUpTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMPromotionUpTableViewCellIden @"WMPromotionUpTableViewCellIden"
#define WMPromotionUpTableViewCellHeight 44.0
/**商品促销--展开
 */
@interface WMPromotionUpTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *upButton;
/**分割线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**分割线高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
