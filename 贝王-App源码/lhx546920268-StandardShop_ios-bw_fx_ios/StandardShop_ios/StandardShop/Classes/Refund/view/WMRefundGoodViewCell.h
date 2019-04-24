//
//  ShopCarContentViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define WMRefundGoodViewCellIden @"WMRefundGoodViewCellIden"
#define WMRefundGoodViewCellHeight 100
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"
@interface WMRefundGoodViewCell : UITableViewCell<XTableCellConfigExDelegate>
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
/**商品的规格
 */
@property (weak, nonatomic) IBOutlet UILabel *specInfoLabel;


@end
