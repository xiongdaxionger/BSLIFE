//
//  WMGoodListCollectionViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGoodDetailAdjGoodInfo;
@class WMGoodSimilarInfo;
@class WMShopCarForOrderGoodInfo;

#define WMGoodListCollectionViewCellIden @"WMGoodListCollectionViewCellIden"

/**猜你喜欢和商品配件展示
 */
@interface WMGoodListCollectionViewCell : UICollectionViewCell
/**商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
/**商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
/**商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
/**加入购物车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addShopCarButton;
/**点击加入购物车回调
 */
@property (copy,nonatomic) void (^addShopCarCallBack)(NSString *productID);
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**配置数据
 */
- (void)configureCellWithSimilarInfoWith:(WMGoodSimilarInfo *)similarInfo;
- (void)configureCellWithAdjGoodInfoWith:(WMGoodDetailAdjGoodInfo *)adjGoodInfo;
- (void)configureCellWithForOrderGoodInfoWith:(WMShopCarForOrderGoodInfo *)goodInfo;
@end
