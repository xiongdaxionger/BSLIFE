//
//  WMShippingAddressOperation.h
//  WestMailDutyFee
//
//  Created by qsit on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//http请求标识
#define WMEditedShippingAddressIdentifier @"WMEditedShippingAddressIdentifier"
#define WMSaveShippingAddressInfoIdentifier @"WMSaveShippingAddressInfoIdentifier"
#define WMDeleteShippingAddresInfoIdentifier @"WMDeleteShippingAddresInfoIdentifier"

@class WMShippingAddressInfo;

/**收货地址网络操作
 */
@interface WMShippingAddressOperation : NSObject

/**获取我 的收货地址 参数
 */
+ (NSDictionary*)shippingAddressParam;

/**从返回的数据获取 我的收货地址
 *@return 数组元素是 WMShippingAddressInfo
 */
+ (NSArray*)shippingAddressFromData:(NSData*) data;

/**获取 地区信息 参数
 */
+ (NSDictionary*)areaInfoParam;

/**从返回的数据中 获取地区信息
 */
+ (NSArray*)areaInfoFromData:(NSData*) data;

/**获取要编辑的收货地址信息 参数
 *@param Id 地址id
 *@param memberID 用户id
 */
+ (NSDictionary*)editedShippingAddressParamWithId:(long long) Id memberID:(NSString *)memberID;

/**从返回的数据中 获取编辑的收货地址信息
 */
+ (WMShippingAddressInfo*)editedShippingAddressFromData:(NSData*) data;

/**保存收货地址信息 新增或编辑 参数
 *@param info 新的收获地址信息
 *@param memberID 用户id
 */
+ (NSDictionary*)saveShippingAddressInfo:(WMShippingAddressInfo*) info memberID:(NSString *)memberID;

/**保存收货地址信息结果
 *@return 地址数据模型
 */
+ (WMShippingAddressInfo *)saveShippingAddressResultFromData:(NSData*) data;

/**删除收货地址 参数
 *@param info 要删除的收货地址信息
 *@param memberID 用户id
 */
+ (NSDictionary*)deleteShippingAddresInfo:(WMShippingAddressInfo*) info memberID:(NSString *)memberID;

/**删除收货地址结果
 */
+ (BOOL)deleteShippingAddressResultFromData:(NSData*) data;

////用于编辑收货地址信息

/**合成地区参数
 *@param infos 数组元素是 WMAreaInfo
 */
+ (NSString*)combineAreaParamFromInfos:(NSArray*) infos;

/**分离地区参数
 *@param mainland 地区参数
 */
+ (NSString*)separateAreaParamFromMainland:(NSString*) mainland;

@end

