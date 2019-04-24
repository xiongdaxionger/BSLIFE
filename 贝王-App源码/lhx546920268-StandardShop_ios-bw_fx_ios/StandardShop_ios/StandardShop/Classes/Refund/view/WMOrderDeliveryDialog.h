//
//  WMOrderDeliveryDialog.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/15.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"

/**订单发货弹窗
 */
@interface WMOrderDeliveryDialog : SeaDialog
//发货结果回调
@property(nonatomic,copy) void(^orderDeliveryCompletionHandler)(NSDictionary *dict);
//退货ID
@property (copy,nonatomic) NSString *refundID;
//快递公司数组
@property (strong,nonatomic) NSArray *deliverysArr;
@end
