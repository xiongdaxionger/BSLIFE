//
//  WMMessageOperation.h
//  WanShoes
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMMessageCenterInfo, WMMessageInfo;

///消息操作
@interface WMMessageOperation : NSObject

/**获取消息中心信息 参数
  */
+ (NSDictionary*)messageCenterInfosParams;

/**获取消息中心信息 结果
 *@return 数组元素是 WMMessageCenterInfo
 */
+ (NSArray*)messageCenterInfosFromData:(NSData*) data;

/**获取消息列表 参数
 *@param info 消息中心信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)messageListParamsWithInfo:(WMMessageCenterInfo*) info pageIndex:(int) pageIndex;

/**获取消息列表 结果
 *@param info 消息中心信息
 *@param totalSize 列表总数
 *@return 数组元素是 WMMessageInfo 或其子类
 */
+ (NSArray*)messageListFromData:(NSData*) data info:(WMMessageCenterInfo*) info totalSize:(long long*) totalSize;

/**把消息标记成已读 参数
 *@param info 消息信息
 */
+ (NSDictionary*)messageMarkReadParamsWithInfo:(WMMessageInfo*) info;


@end
