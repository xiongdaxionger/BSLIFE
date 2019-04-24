//
//  WMShopCarUnusePromotionViewCell.h
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMShopCarUnusePromotionViewCellIden @"WMShopCarUnusePromotionViewCellIden"
#define WMShopCarUnusePromotionViewCellHeight 38.0
/**购物车未享受优惠显示
 */
@interface WMShopCarUnusePromotionViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**未享受优惠名称文本
 */
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
/**未享受优惠名称文本宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagNameWidthConstraint;
/**未享受优惠内容文本
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**凑单箭头
 */
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@end
