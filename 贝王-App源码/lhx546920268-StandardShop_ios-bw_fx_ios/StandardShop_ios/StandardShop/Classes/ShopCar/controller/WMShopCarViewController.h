//
//  WMShopCarViewController.h
//  StandardShop
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMShopCarInfo;
/**购物车
 */
@interface WMShopCarViewController : SeaTableViewController
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**数据模型
 */
@property (strong,nonatomic) WMShopCarInfo *shopCarInfo;
/**遮挡视图
 */
@property (strong,nonatomic) UIView *showView;
/**侧滑添加收藏的单元下标
 */
@property (strong,nonatomic) NSIndexPath *selectIndexPath;
/**是否进入编辑状态
 */
@property (assign,nonatomic) BOOL isEdit;
/**选中或取消选中商品
 */
- (void)selectShopCarGoodWithCell:(UITableViewCell *)cell isSelect:(BOOL)isSelect;
/**修改购物车商品的数量
 */
- (void)changeShopCarGoodQuantityWithCell:(UITableViewCell *)cell quantity:(NSInteger)quantity isMinus:(BOOL)isMinus;

@end
