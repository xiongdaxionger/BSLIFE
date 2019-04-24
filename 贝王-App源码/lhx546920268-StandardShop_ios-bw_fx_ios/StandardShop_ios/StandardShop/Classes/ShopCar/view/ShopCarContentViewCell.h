//
//  ShopCarContentViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

#define WMShopCarContentViewCellIden @"ShopCarContentViewCellIden"
#define WMShopCarContentViewCellHeight 100
/**购物车商品显示
 */
@interface ShopCarContentViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**商品的选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopSelecteButton;
/**商品的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImage;
/**商品的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
/**商品的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;
/**商品规格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodSpecInfoLabel;
/**删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopDeleteButton;
/**商品的数量
 */
@property (weak, nonatomic) IBOutlet UITextField *shopCountLabel;
/**商品增加按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopAddButton;
/**商品减少按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopMinusButton;
/**加减商品的视图
 */
@property (weak, nonatomic) IBOutlet UIView *goodQuantityView;
/**赠品的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *giftQuantityLabel;
/**选中图片
 */
@property (strong,nonatomic) UIImage *selectImage;
/**未选中图片
 */
@property (strong,nonatomic) UIImage *unSelectImage;
/**失效图片
 */
@property (strong,nonatomic) UIImage *noUseImage;
@end
