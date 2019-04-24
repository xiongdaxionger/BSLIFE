//
//  WMPromotionContentTableViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"
#define WMPromotionContentTableViewCellIden @"WMPromotionContentTableViewCellIden"
#define WMPromotionContentTableViewCellHeight 44.0
//标签最大计算宽度
#define WMTagCalculateMaxWidth 150.0
//其他内容宽度--用于计算促销内容高度
#define WMPromotionExtraWidth 98.0
//内容最小高度
#define WMPromotionContentMinHeight 27.0
/**商品促销内容显示
 */
@interface WMPromotionContentTableViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**促销标题
 */
@property (weak, nonatomic) IBOutlet UILabel *promotionTitleLabel;
/**促销标题宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;
/**促销内容
 */
@property (weak, nonatomic) IBOutlet SeaLabel *contentLabel;
/**右侧箭头
 */
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
/**选中商品
 */
@property (copy,nonatomic) void(^selectCallBack)(NSString *productName);

/**配置数据
 */
- (void)configureCellWithModel:(id)model;
@end
