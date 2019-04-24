//
//  WMGoodCommitNotifyViewController.h
//  StandardShop
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

/**商品缺货登记
 */
@interface WMGoodCommitNotifyViewController : SeaViewController
/**商品ID
 */
@property (copy,nonatomic) NSString *goodID;
/**货品ID
 */
@property (copy,nonatomic) NSString *productID;
@end
