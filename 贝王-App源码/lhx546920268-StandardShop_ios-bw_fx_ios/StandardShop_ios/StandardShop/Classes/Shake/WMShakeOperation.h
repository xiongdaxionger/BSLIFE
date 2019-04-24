//
//  WMShakeOperation.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/17.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMShakeInfo,WMShakeResultInfo;

///网络请求标识
#define WMShakeInfoIdentifier @"WMShakeInfoIdentifier" ///获取摇一摇信息
#define WMShakeResultIdentifier @"WMShakeResultIdentifier" ///摇一摇结果

///摇一摇网络操作
@interface WMShakeOperation : NSObject

/**获取摇一摇信息，包括可摇次数，摇一摇规则，获奖名单等 参数
 *@param pageIndex 页码 第一页有 摇一摇信息，包括可摇次数，摇一摇规则
 */
+ (NSDictionary*)shakeInfoParamsWithPageIndex:(int) pageIndex;

/**获取摇一摇信息，包括可摇次数，摇一摇规则，获奖名单等 结果
 *@param totalSize 获取名单总数
 *@param info 摇一摇信息
 *@return 获奖名单 数组元素是 WMShakeWinnerInfo
 */
+ (NSArray*)shakeInfoFromData:(NSData*) data totalSize:(long long*) totalSize info:(WMShakeInfo**) info;

/**摇一摇结果 参数
 */
+ (NSDictionary*)shakeResultParams;

/**摇一摇结果 
 *@return 成功返回结果，否则返回nil
 */
+ (WMShakeResultInfo*)shakeResultFromData:(NSData*) data;

@end
