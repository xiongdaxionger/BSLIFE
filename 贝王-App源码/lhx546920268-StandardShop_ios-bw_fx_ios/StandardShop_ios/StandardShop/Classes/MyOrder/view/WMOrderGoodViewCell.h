//
//  WMOrderGoodViewCell.h
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
#define WMOrderGoodViewCellIdentifier @"WMOrderGoodViewCellIdentifier"
#define WMOrderGoodViewCellHeight 100
/**订单列表的商品展示
 */
@interface WMOrderGoodViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
/**商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
/**商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
/**商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodQuantityLabel;
/**商品规格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodSpecInfoLabel;
/**评价商品按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
/**评价商品
 */
@property (copy,nonatomic) void(^commentGood)(UITableViewCell *cell);
@end
