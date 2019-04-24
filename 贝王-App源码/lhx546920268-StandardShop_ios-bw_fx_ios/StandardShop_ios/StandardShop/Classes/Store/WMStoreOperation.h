//
//  WMStoreOperation.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMStoreToJoinInfo;
@class WMStoreListInfo;

///网络请求标识
#define WMStoreToJoinInfoIdentifier @"WMStoreToJoinInfoIdentifier" ///门店加盟信息
#define WMStoreToJoinIdentifier @"WMStoreToJoinIdentifier" ///门店加盟
#define WMStoreListIdentifier @"WMStoreListIdentifier" ///门店列表

///门店网络操作
@interface WMStoreOperation : NSObject

/**获取门店加盟信息 参数
 */
+ (NSDictionary*)storeToJoinInfoParams;

/**获取门店加盟信息 结果
 */
+ (WMStoreToJoinInfo*)storeToJoinInfoFromData:(NSData*) data;

/**门店加盟 参数
 *@param phoneNumber 电话
 *@param name 姓名
 *@param city 城市
 */
+ (NSDictionary*)storeToJoinParamWithPhoneNumber:(NSString*) phoneNumber name:(NSString*) name city:(NSString*) city;

/**门店加盟 结果
 */
+ (BOOL)storeToJoinResultFromData:(NSData*) data;

/**获取门店列表 参数
 *@param latitude 维度
 *@param longitude 经度
 *@param keyWord 搜索关键字
 *@param page 页码
 */
+ (NSDictionary*)storeListParamsWithLatitude:(double) latitude longitude:(double) longitude keyWord:(NSString *) keyWord page:(NSInteger)page;

/**获取门店列表信息 结果
 *@return 数组元素是 WMStoreAreaInfo
 */
+ (NSArray<WMStoreListInfo *> *)parseStoreAddressListWithData:(NSData *)data totalSize:(long long *) totalSize;

@end
