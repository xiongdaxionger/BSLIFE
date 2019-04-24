//
//  WMGoodSearchHistoryDataBase.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodSearchHistoryDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "WMDataBase.h"

///商品搜索记录表
#define WMGoodSearchHistoryTable @"good_search_history_list"

///表字段
#define WMSearchKey @"search_key" ///搜索关键字
#define WMSearchTime @"Search_time" ///搜索时间

@implementation WMGoodSearchHistoryDataBase

#pragma mark- 搜索记录操作

/**获取搜索记录列表
 *@return 数组元素是 WMGoodInfo
 */
+ (NSMutableArray*)searchHistoryList
{
    NSMutableArray *infos = [NSMutableArray array];
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
        
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@ order by id desc", WMGoodSearchHistoryTable]];
        
        while ([rs next])
        {
            NSString *searchKey = [rs stringForColumn:WMSearchKey];
            if(searchKey)
            {
                [infos addObject:searchKey];
            }
        }
        
        [rs close];
    }];
    
    return infos;
}

/**插入一条搜索记录
 *@param searchKey 搜索关键字
 *@return 是否插入成功
 */
+ (BOOL)insertSearchHistory:(NSString*) searchKey
{
    if(!searchKey)
        return NO;
    
    __block BOOL result = NO;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
        
        ///删除存在的相同商品
        [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@='%@'", WMGoodSearchHistoryTable, WMSearchKey, searchKey]];
        
        result = [db executeUpdate:[NSString stringWithFormat:
                                    @"insert into %@(%@) values(?)",
                                    WMGoodSearchHistoryTable,
                                    WMSearchKey],
                  searchKey];
        
        ///判断保存的搜索记录是否已达到30条
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select count(*) from %@", WMGoodSearchHistoryTable]];
        sqlite3_int64 count = [rs longLongIntForColumnIndex:0];
        [rs close];
        
        if(count > 30)
        {
            ///删除前30条以外的所有记录
            [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where id not in (select top(30) id from %@)", WMGoodSearchHistoryTable, WMGoodSearchHistoryTable]];
        }
    }];
    
    return result;
}

/**删除所有搜索记录
 *@return 是否删除成功
 */
+ (BOOL)deleteAllSearchHistory
{
    __block BOOL result = NO;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
        
        result = [db executeUpdate:[NSString stringWithFormat:@"delete from %@", WMGoodSearchHistoryTable]];
    }];
    
    return result;
}


@end
