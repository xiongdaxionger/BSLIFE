//
//  WMOrderCenterViewController.h
//  StandardShop
//
//  Created by mac on 16/7/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMOrderInfo;
/**订单中心--订单列表显示
 */
@interface WMOrderCenterViewController : SeaTableViewController<SeaMenuBarDelegate>
/**是否单独展示等待支付尾款的预售订单
 */
@property (assign,nonatomic) BOOL isSinglePrepare;
/**是否为代购(分销)订单--默认是NO
 */
@property (assign,nonatomic) BOOL isCommisionOrder;
/**订单数组--元素是WMOrderInfo
 */
@property (strong,nonatomic) NSMutableArray *orderInfosArr;
/**取消订单的原因
 */
@property (strong,nonatomic) NSArray *cancelOrderReasonsArr;
/**菜单栏--单一显示预售订单时菜单栏不显示
 */
@property (strong,nonatomic) SeaMenuBar *orderTypeMenuBar;
/**表格视图的配置
 */
@property (strong,nonatomic) NSArray *configureArr;
/**选中的订单菜单栏下标
 */
@property (assign,nonatomic) NSInteger orderStatusSelectIndex;
/**选中的单元格
 */
@property (strong,nonatomic) NSIndexPath *selectCellIndexPath;
/**支付待付款订单
 */
- (void)payOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**取消待付款订单
 */
- (void)cancelOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**确认收货
 */
- (void)confirmOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**查看物流
 */
- (void)checkOrderExpressWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**再次购买
 */
- (void)buyAgainWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**删除订单
 */
- (void)deleteOrderWithInfo:(WMOrderInfo *)info Cell:(UITableViewCell *)cell;
/**显示取货码
 */
- (void)showSinceQRCodeWithSinceCode:(NSString *)code;

@end
