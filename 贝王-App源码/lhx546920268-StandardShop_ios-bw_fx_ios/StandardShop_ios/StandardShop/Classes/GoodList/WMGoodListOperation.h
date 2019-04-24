//
//  WMGoodListOperation.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

//商品排序方式
#define WMGoodOrderByPiceAsc @"price asc" //价格升序
#define WMGoodOrderByPiceDesc @"price desc" //价格降序
#define WMGoodOrderByBuyCountDesc @"buy_count desc" //销量升序
#define WMGoodOrderByWeekBuyCountDesc @"buy_w_count desc" //周销量降序
//#define WMGoodOrderByTime @"uptime desc" //时间排序 降序

///网络请求标识
#define WMGoodListIdentifier @"WMGoodListIdentifier" ///商品列表

#define WMCollectionListIdentifier @"WMCollectionListIdentifier" ///收藏列表
#define WMGoodCollectIdentifier @"WMGoodCollectIdentifier" ///收藏商品
#define WMGoodRemoveCollectIdentifier @"WMGoodRemoveCollectIdentifier" ///收藏商品

#define WMSecondKillGoodCancelSubscribleIdentifier @"WMSecondKillGoodCancelSubscribleIdentifier" ///取消订阅
#define WMSecondKillGoodSubScribleIdentifier @"WMSecondKillGoodSubScribleIdentifier" ///订阅

@class WMSecondKillInfo, WMGoodsAccessRecordInfo;

/**商品列表网络操作
 */
@interface WMGoodListOperation : NSObject

/**获取商品列表 参数
 *@param categoryId 商品分类Id
 *@param virtualCategoryId 虚拟分类Id， 和商品分类Id只能二选1
 *@param brandId 品牌id
 *@param promotionTagId 促销标签id
 *@param order 排序方式
 *@param searchKey 搜索关键字
 *@param pageIndex 页码
 *@param filters 筛选参数
 *@param needSettings 是否需要配置信息
 *@param onlyPresell 是否只获取预售
 */
+ (NSDictionary*)goodListParamWithCategoryId:(long long) categoryId
                           virtualCategoryId:(long long) virtualCategoryId
                                     brandId:(NSString*) brandId
                              promotionTagId:(NSString*) promotionTagId
                                       order:(NSString*) order
                                   searchKey:(NSString*) searchKey
                                   pageIndex:(int) pageIndex
                                     filters:(NSDictionary *) filters
                                needSettings:(BOOL) needSettings
                                 onlyPresell:(BOOL) onlyPresell;

/**从返回的数据获取商品信息
 *@param totalSize 商品总数
 *@return key是good,value是数组 数组元素是 WMGoodInfo
 第一页商品时，有排序信息，key是 orderBy，value是数组，数组元素是 WMGoodListOrderByInfo ，筛选信息key是filter,value 是NSString 用来获取筛选信息的分类id
 设置信息，key是setting，value是 WMGoodListSettings，品牌信息 key是 brand，value 是WMBrandDetailInfo
 */
+ (NSDictionary*)goodListFromData:(NSData*) data totalSize:(long long*) totalSize;

/**返回选中的筛选类型
 */
+ (NSDictionary *)returnGoodSelectFilterTypeStr:(NSArray *)filterArr;

/**返回筛选商品的类型数组
 */
+ (NSArray *)returnGoodFilterTypeArrWithData:(NSData *)data;

/**返回筛选商品的参数
 *cateID 分类ID
 */
+ (NSDictionary *)returnGoodCateFilterParamWithCateID:(NSString *)cateID;

/**获取秒杀商品列表 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)secondKillGoodListWithPageIndex:(int) pageIndex;

/**获取秒杀商品列表 结果
 *@return key是 goods 秒杀商品列表 数组元素是 WMSecondKillInfo， key是 ads 轮播广告数组元素是 WMHomeAdInfo ，key是 adSize 轮播广告大小 NSValue CGSizeValue
 */
+ (NSDictionary*)secondKillGoodListFromData:(NSData*) data;

#pragma mark- 商品收藏

/**获取用户收藏信息 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)collectionListParamPageIndex:(int) pageIndex;

/**从返回的数据获取用户收藏信息
 *@param totalSize 列表数量
 *@return WMCollectionInfo
 */
+ (NSArray*)collectionListFromData:(NSData*) data totalSize:(long long*) totalSize;

/**收藏或取消收藏商品
 *@param type 0 收藏商品，1取消收藏
 *@param goodId 商品Id
 */
+ (NSDictionary*)goodCollectParamWithType:(int) type goodId:(NSString*) goodId;

/**收藏或取消收藏结果
 */
+ (BOOL)goodCollectResultFromData:(NSData*) data;

/**秒杀商品取消订阅 参数
 *@param productId 货品id
 */
+ (NSDictionary*)secondKillGoodCancelSubscribleWithProductId:(NSString*) productId;

/**秒杀商品取消订阅 结果
 *@return 是否取消订阅成功
 */
+ (BOOL)secondKillGoodCancelSubscribleFromData:(NSData*) data;

/**秒杀商品订阅 参数
 *@param productId 货品id
 *@param info 秒杀信息
 */
+ (NSDictionary*)secondKillGoodSubScribleWithProductId:(NSString*) productId secondKillInfo:(WMSecondKillInfo*) info;

/**秒杀商品订阅 结果
 *@return 是否订阅成功
 */
+ (BOOL)secondKillGoodSubScribleFromData:(NSData*) data;

/**获取存列表
 */
+ (NSDictionary*)goodsStoreParamsWithPage:(int) page;

/**获取存列表
 */
+ (NSArray<WMGoodsAccessRecordInfo*>*)goodsStoreFromData:(NSData*) data totalSize:(long long*) totalSize;

/**获取取列表
 */
+ (NSDictionary*)goodsPickParamsWithPage:(int) page;

/**获取取列表
 */
+ (NSArray<WMGoodsAccessRecordInfo*>*)goodsPickFromData:(NSData*) data totalSize:(long long*) totalSize;

@end
