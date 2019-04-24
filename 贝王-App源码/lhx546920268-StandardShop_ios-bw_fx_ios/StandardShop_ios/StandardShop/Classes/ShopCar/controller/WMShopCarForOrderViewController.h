//
//  WMShopCarForOrderViewController.h
//  StandardShop
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaCollectionViewController.h"

/**购物车凑单商品显示
 */
@interface WMShopCarForOrderViewController : SeaCollectionViewController
/**菜单栏
 */
@property (strong,nonatomic) SeaMenuBar *menuBar;
/**数据数组--元素是WMShopCarForOrderGoodInfo
 */
@property (strong,nonatomic) NSArray *datasArr;
/**菜单栏数据项
 */
@property (strong,nonatomic) NSArray *tabContentsArr;
@end
