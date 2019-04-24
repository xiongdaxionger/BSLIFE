//
//  WMPayInfoViewController.h
//  WestMailDutyFee
//
//  Created by qsit on 15/9/10.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//


@class WMPayMethodModel;
@class WMPayMessageInfo;

/**订单支付页面
 */
@interface WMPayInfoViewController : SeaViewController
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**上次选中的行
 */
@property (assign,nonatomic) NSInteger lastSelectRow;
/**是否组合支付
 */
@property (assign,nonatomic) BOOL isCombinationPay;
/**是否为预售订单
 */
@property (assign,nonatomic) BOOL isPrepare;
/**组合支付的支付方式--当启用组合支付时该值不为nil
 */
@property (strong,nonatomic) WMPayMethodModel *combinationPayMethod;
/**支付信息模型
 */
@property (strong,nonatomic) WMPayMessageInfo *payMessageInfo;
/**能否取消支付并返回
 */
@property (assign,nonatomic) BOOL canBack;
/**是否订单列表或订单详情发起的支付
 */
@property (assign,nonatomic) BOOL isOrderPay;
/**能否再次输入支付密码
 */
@property (assign,nonatomic) BOOL canInputPassWordAgain;
/**是否为代客下单--默认为NO
 */
@property (assign,nonatomic) BOOL isCommisionOrder;
@end
