//
//  WeiCharPayClient.h
//  WuMei
//
//  Created by qsit on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@class WeChatPayViewModel;

@interface WeiCharPayClient : NSObject<WXApiDelegate>

- (instancetype)initPayWithModel:(WeChatPayViewModel *)resModel;

- (void)usingWeChatPayToPayOrder;

/**支付结果的回调pop
 */
- (void)checkResultWithStatusType:(NSNumber *)type;

@end
