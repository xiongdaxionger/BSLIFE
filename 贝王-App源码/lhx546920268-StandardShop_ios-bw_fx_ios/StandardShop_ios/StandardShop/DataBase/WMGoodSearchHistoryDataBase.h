//
//  WMGoodSearchHistoryDataBase.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///商品搜索记录数据库操作
@interface WMGoodSearchHistoryDataBase : NSObject

/**获取搜索记录列表
 *@return 数组元素是 WMGoodInfo
 */
+ (NSMutableArray*)searchHistoryList;

/**插入一条搜索记录
 *@param searchKey 搜索关键字
 *@return 是否插入成功
 */
+ (BOOL)insertSearchHistory:(NSString*) searchKey;

/**删除所有搜索记录
 *@return 是否删除成功
 */
+ (BOOL)deleteAllSearchHistory;

@end
