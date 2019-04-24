//
//  WMRefundMoneyDetailViewController.h
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**提交退款
 */
@interface WMRefundMoneyDetailViewController : SeaTableViewController
/**网路请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configArr;
/**订单ID
 */
@property (copy,nonatomic) NSString *orderID;
/**遮挡视图
 */
@property (strong,nonatomic) UIView *showView;
/**退款的详细理由
 */
@property (copy,nonatomic) NSString *detailReason;
/**退款的理由
 */
@property (copy,nonatomic) NSString *reason;
/**回调
 */
@property (copy,nonatomic) void(^actionCallBack)(void);

@end
