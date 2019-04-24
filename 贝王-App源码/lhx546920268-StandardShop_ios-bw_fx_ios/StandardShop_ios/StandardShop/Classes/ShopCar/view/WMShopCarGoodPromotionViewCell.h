//
//  WMShopCarGoodPromotionViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTableCellConfigExDelegate.h"

#define WMShopCarGoodPromotionViewCellIden @"WMShopCarGoodPromotionViewCellIden"
#define WMShopCarGoodPromotionViewCellHeight 34.0
#define WMShopCarGoodPromotionViewCellExtraFloat 16
/**购物车商品享受的优惠显示
 */
@interface WMShopCarGoodPromotionViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**优惠信息显示文本
 */
@property (weak, nonatomic) IBOutlet UILabel *promotionLabel;

@end
