//
//  ConfirmOrderGoodViewCell.h
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#define kConfirmOrderGoodViewCellIden @"ConfirmOrderGoodViewCellIden"
#define kConfirmOrderGoodViewCellHeight 98
#import <UIKit/UIKit.h>
#import "XTableCellConfigExDelegate.h"

/**确认订单页的商品展示
 */
@interface ConfirmOrderGoodViewCell : UITableViewCell<XTableCellConfigExDelegate>
/**商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *orderGoodImage;
/**商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *orderGoodNameLabel;
/**商品的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *orderGoodPriceLabel;
/**商品的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *orderGoodQuantityLabel;
/**商品的规格
 */
@property (weak, nonatomic) IBOutlet UILabel *orderGoodSpecInfo;

@end
