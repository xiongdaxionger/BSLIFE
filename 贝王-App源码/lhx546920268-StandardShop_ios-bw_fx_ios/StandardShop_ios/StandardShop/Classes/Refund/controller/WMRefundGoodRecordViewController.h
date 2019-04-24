//
//  WMRefundGoodRecordViewController.h
//  WanShoes
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**申请售后的记录
 */
@interface WMRefundGoodRecordViewController : SeaTableViewController
/**网络请求
 */
@property (strong,nonatomic) SeaHttpRequest *request;
/**订单数据，元素是WMRefundGoodRecordModel
 */
@property (strong,nonatomic) NSMutableArray *orderListArray;
/**配置数组
 */
@property (strong,nonatomic) NSArray *configureArr;
/**选中的组
 */
@property (strong,nonatomic) NSIndexPath *selectIndex;
/**快递信息
 */
@property (strong,nonatomic) NSArray *deliverysArr;
/**物流信息弹窗
 */
- (void)showDeliveryDialogSelectCell:(UITableViewCell *)cell;
@end
