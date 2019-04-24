//
//  WMDepositClient.h
//  WestMailDutyFee
//
//  Created by qsit on 15/9/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**预存款支付
 */
@interface WMDepositClient : NSObject

/**支付结果的回调pop
 */
- (void)checkResultWithStatusType:(NSNumber *)type errorMsg:(NSString *)errorMsg;

@end
