//
//  WMDoPaymemtClient.h
//  WestMailDutyFee
//
//  Created by qsit on 15/8/29.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MALiPayClient.h"
#import "WMDepositClient.h"
#import "WeiCharPayClient.h"
#import "WMUnionPayClient.h"
@interface WMDoPaymemtClient : NSObject
//预存款的支付ID
#define WMDepositID @"deposit"
//支付宝的支付ID
#define WMMAlipayID @"malipay"
//中国银联端支付
#define WMUnionPayID @"wapupacp"
//微信支付的支付ID
#define WMWxPayID @"wxpayjsapi"
//支付方式ID的key
#define WMPayAppID @"pay_app_id"
/**初始化
 */
- (instancetype)initWithPaymemtDict:(NSDictionary *)paymentDict payAppID:(NSString *)appID;
/**检测支付结果
 */
- (void)checkResultWithStatusType:(NSNumber *)type errorMsg:(NSString *)msg isCombinationPay:(BOOL)isCombinationPay needPresent:(BOOL)needPresent;
/**发起支付
 */
- (void)callClientToPay;
@end
