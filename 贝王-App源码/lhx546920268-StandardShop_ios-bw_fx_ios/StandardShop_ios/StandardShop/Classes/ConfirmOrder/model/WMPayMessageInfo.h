//
//  WMPayMessageInfo.h
//  StandardShop
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**支付页面用户预存款模型
 */
@interface WMPayUserDepositInfo : NSObject
/**预存款金额
 */
@property (copy,nonatomic) NSString *depositMoeny;
/**格式化预存款金额
 */
@property (copy,nonatomic) NSString *formatDepostiMoney;
/**是否设置了支付密码
 */
@property (assign,nonatomic) BOOL hasSetPayPassWord;
/**剩余支付金额--用于组合支付
 */
@property (copy,nonatomic) NSString *combinationMoney;
/**格式化的剩余支付金额--用于组合支付
 */
@property (copy,nonatomic) NSString *formatCombinationMoney;
/**初始的剩余支付金额
 */
@property (copy,nonatomic) NSString *firstCombinationMoeny;
/**初始化
 */
+ (instancetype)returnPayUserDepositInfoWithDict:(NSDictionary *)dict;
@end

/**支付主页模型
 */
@interface WMPayMessageInfo : NSObject
/**用户预存款信息
 */
@property (strong,nonatomic) WMPayUserDepositInfo * userDepositInfo;
/**是否开启组合支付
 */
@property (assign,nonatomic) BOOL canCombinationPay;
/**选中的支付方式能否支付
 */
@property (assign,nonatomic) BOOL canPay;
/**选中的支付方式的支付提示语--支付按钮文本,为空是支付方式不能使用
 */
@property (copy,nonatomic) NSString *payButtonTitle;
/**选中的支付方式的不能支付的提示语--不能支付的原因
 */
@property (copy,nonatomic) NSString *payRejectReason;
/**支付方式数组--元素是WMPayMethodModel
 */
@property (strong,nonatomic) NSArray *paymentsArr;
/**组合支付的支付方式数组--需要组合支付时不为nil
 */
@property (strong,nonatomic) NSArray *combinationPaymentsArr;
/**需要支付的总金额
 */
@property (copy,nonatomic) NSString *totalMoney;
/**需要支付的总金额,格式化
 */
@property (copy,nonatomic) NSString *formatTotalMoney;
/**订单类型--普通订单/预售订单
 */
@property (assign,nonatomic) BOOL isPrepare;
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
/**选择的支付ID
 */
@property (copy,nonatomic) NSString *selectPayID;
/**货币类型
 */
@property (copy,nonatomic) NSString *currency;
/**初始化
 */
+ (instancetype)returnPayMessageInfoWithDict:(NSDictionary *)dict;

@end












