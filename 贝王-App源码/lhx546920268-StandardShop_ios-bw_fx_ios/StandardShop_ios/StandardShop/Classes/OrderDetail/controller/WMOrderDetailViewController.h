//
//  WMOrderDetailViewController.h
//  AKYP
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

#define WMOrderDetailBottomViewHeight 49

/**订单详情
 */
@interface WMOrderDetailViewController : SeaViewController

/**表格视图
 */
@property (strong,nonatomic) UITableView *tableView;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configureArr;
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**取消订单的原因
 */
@property (strong,nonatomic) NSArray *cancelOrderReasonsArr;
/**是否通过售后订单列表进入详情
 */
@property (assign,nonatomic) BOOL isRefundOrderDetail;
@end
