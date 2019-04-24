//
//  ValuesQuantityViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodDetailInfo;

@protocol ValuesQuantityViewCellDelegate <NSObject>

/**更改购买数量
 */
- (void)changeBuyQuantityWithNewQuantity:(NSInteger)quantity;

@end

#define ValuesQuantityViewCellIden @"ValuesQuantityViewCellIden"
#define ValuesQuantityViewCellHeight 60
/**规格选择的数量视图
 */
@interface ValuesQuantityViewCell : UITableViewCell
/**数量文本
 */
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
/**数量文本
 */
@property (weak, nonatomic) IBOutlet UILabel *quantityCountLabel;
/**增加按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;
/**减少按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
/**数量
 */
@property (weak, nonatomic) IBOutlet UILabel *quantityNameLabel;
/**数量视图
 */
@property (weak, nonatomic) IBOutlet UIView *quantityView;
/**限购数量
 */
@property (weak, nonatomic) IBOutlet UILabel *buyLimitCountLabel;

/**当前的购买数量
 */
@property (assign,nonatomic) NSInteger buyQuantity;
/**代理
 */
@property (weak,nonatomic) id<ValuesQuantityViewCellDelegate>delegate;
/**配置数据
 */
- (void)configureWithModel:(WMGoodDetailInfo *)info;
@end
