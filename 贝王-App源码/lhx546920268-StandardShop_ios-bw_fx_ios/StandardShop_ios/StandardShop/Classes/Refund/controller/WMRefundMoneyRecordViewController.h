//
//  WMRefundMoneyRecordViewController.h
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**退款记录
 */
@interface WMRefundMoneyRecordViewController : SeaTableViewController
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**订单模型
 */
@property (strong,nonatomic) NSMutableArray *orderListArray;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configureArr;
@end
