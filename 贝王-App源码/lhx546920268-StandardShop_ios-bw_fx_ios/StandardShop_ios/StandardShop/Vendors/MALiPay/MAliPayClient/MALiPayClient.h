//
//  MALiPayClient.h
//  WuMei
//
//  Created by qsit on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMDoPayInfoModel;
//支付宝支付成功
#define MALiPaySuccess @"9000"
//支付宝支付失败
#define MALiPayFail @"4000"
//支付宝支付取消
#define MALiPayCancel @"6001"
//支付宝支付结果key
#define MALiPayResultKey @"resultStatus"

@interface MALiPayClient : NSObject

- (instancetype)initPayWithModel:(WMDoPayInfoModel *)resModel;

- (void)usingMAiLiPayToPayOrder;

/**支付回调后pop
 */
- (void)checkResultWithStatusType:(NSNumber *)type;

@end
