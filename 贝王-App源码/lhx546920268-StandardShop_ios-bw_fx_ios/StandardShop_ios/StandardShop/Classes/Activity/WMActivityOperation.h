//
//  WMActivityOperation.h
//  StandardShop
//
//  Created by 罗海雄 on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///活动列表
#define WMActivityListIdentifier @"WMActivityListIdentifier"

///活动操作
@interface WMActivityOperation : NSObject

/**获取活动列表 参数
 */
+ (NSDictionary*)activityListParams;

/**获取活动列表 结果
 *@return 数组元素是 WMActivityInfo
 */
+ (NSArray*)activityListFromData:(NSData*) data;

@end
