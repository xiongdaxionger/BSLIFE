//
//  ConfirmOrderPageController.h
//  WuMei
//
//  Created by SDA on 15-7-26.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "SeaViewController.h"

@class WMConfirmOrderInfo;
@class ConfirmOrderBottomView;
@class WMShippingAddressInfo;
@class WMCouponsInfo;

@interface ConfirmOrderPageController : SeaTableViewController
/**确认订单模型
 */
@property (strong,nonatomic) WMConfirmOrderInfo *orderInfo;
/**是否立即购买
 */
@property (copy,nonatomic) NSString *isFastBuy;
/**顶部视图
 */
@property (strong,nonatomic) ConfirmOrderBottomView *bottomView;
/**单元格配置数组
 */
@property (strong,nonatomic) NSArray *configArr;
/**是否切换了地址
 */
@property (assign,nonatomic) BOOL isChangeAddr;
/**是否收到更改地址信息的通知
 */
@property (assign,nonatomic) BOOL isReceiveAddrNotification;
/**更新订单价格
 */
- (void)updateTotalMoney;
/**积分使用回调
 */
- (void)usePointWithIsUse:(BOOL)isUsePoint;
@end
