//
//  WMCustomerServiceOperation.h
//  StandardShop
//
//  Created by Hank on 16/9/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///获取客户服务的相关信息
#define WMCustomerServiceInfoIdentifier @"WMCustomerServiceInfoIdentifier"

@interface WMCustomerServiceOperation : NSObject
/**获取在线客服 参数
 */
+ (NSDictionary *)returnCustomServiceParam;
/**获取在线客服 结果
 */
+ (NSDictionary *)returnCustomServiceResultWithData:(NSData *)data;



@end
