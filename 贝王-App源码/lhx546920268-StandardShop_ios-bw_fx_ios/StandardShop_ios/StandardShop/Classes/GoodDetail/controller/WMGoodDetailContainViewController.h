//
//  WMGoodDetailContainViewController.h
//  StandardShop
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaScrollViewController.h"

/**商品详情的视图容器
 */
@interface WMGoodDetailContainViewController : SeaScrollViewController
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**是否为积分赠品
 */
@property (assign,nonatomic) BOOL isGift;
@end
