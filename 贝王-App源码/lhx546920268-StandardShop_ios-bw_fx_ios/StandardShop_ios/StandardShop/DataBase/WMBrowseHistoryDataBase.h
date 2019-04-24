//
//  WMBrowseHistoryDataBase.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMGoodInfo;

///浏览记录数据库操作
@interface WMBrowseHistoryDataBase : NSObject

/**获取浏览记录列表
 *@return 数组元素是 WMGoodInfo
 */
+ (NSMutableArray*)browseHistoryList;

/**插入一条浏览记录
 *@param info 商品信息
 *@return 是否插入成功
 */
+ (BOOL)insertBrowseHistoryWithInfo:(WMGoodInfo*) info;

/**删除一条浏览记录
 *@param productId 货品id
 *@return 是否删除成功
 */
+ (BOOL)deleteBrowseHistoryWithProductId:(NSString*) productId;

/**删除所有浏览记录
 *@return 是否删除成功
 */
+ (BOOL)deleteAllBrowseHistory;

/**获取我的足迹数量
 */
+ (int)browseHistoryCount;

@end
