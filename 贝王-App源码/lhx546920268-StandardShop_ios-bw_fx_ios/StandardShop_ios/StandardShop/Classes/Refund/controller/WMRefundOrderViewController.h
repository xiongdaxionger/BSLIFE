//
//  WMRefundOrderViewController.h
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**申请退换货/退款
 */
@interface WMRefundOrderViewController : SeaTableViewController
/**初始化
 */
- (instancetype)initWithType:(NSString *)type;
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**订单数组模型
 */
@property (strong,nonatomic) NSMutableArray *orderListArray;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configureArr;
/**订单类型
 */
@property (copy,nonatomic) NSString *refundType;
/**申请退款/退换
 */
- (void)refundOrderWithOrderID:(NSString *)orderID cell:(UITableViewCell *)cell isGood:(BOOL)isGood;
@end
