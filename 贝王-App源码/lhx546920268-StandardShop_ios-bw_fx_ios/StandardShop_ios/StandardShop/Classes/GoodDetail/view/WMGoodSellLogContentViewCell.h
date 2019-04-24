//
//  WMGoodSellLogContentViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WMGoodSellLogContentViewCellHeight 44
#define WMGoodSellLogContentViewCellIden @"WMGoodSellLogContentViewCellIden"

@class WMGoodDetailSellLogInfo;
/**商品详情销售记录内容显示
 */
@interface WMGoodSellLogContentViewCell : UITableViewCell
/**买家昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/**购买价
 */
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;
/**购买数量
 */
@property (weak, nonatomic) IBOutlet UILabel *buyQuantityLabel;
/**购买时间
 */
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLabel;
/**购买数量宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quantityWidthConstraint;
/**购买时间宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyTimeWidthConstraint;
/**购买价格宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyPriceWidthConstraint;
/**买家昵称宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameWidthConstraint;
/**是否显示购买价
 */
@property (assign,nonatomic) BOOL showPrice;
/**配置数据
 */
- (void)configureWithModel:(WMGoodDetailSellLogInfo *)info;
@end
