//
//  WMBrowseHistoryDataBase.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBrowseHistoryDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "WMGoodInfo.h"
#import "WMDataBase.h"

///商品浏览记录表
#define WMBrwoseHistoryTable @"good_browse_history_list"

///表字段
#define WMBrwoseHistoryGoodId @"good_id" ///商品id
#define WMBrwoseHistoryProductId @"product_id" ///货品id
#define WMBrwoseHistoryName @"name" ///商品名称
#define WMBrwoseHistoryImageURL @"image_url" ///商品图片
#define WMBrwoseHistoryPrice @"price" ///商品价格
#define WMBrwoseHistoryMarketPrice @"market_price" ///市场价格
#define WMBrwoseHistoryTime @"browse_time" ///浏览时间

@implementation WMBrowseHistoryDataBase

#pragma mark- 浏览记录操作

/**获取浏览记录列表
 *@return 数组元素是 WMGoodInfo
 */
+ (NSMutableArray*)browseHistoryList
{
    NSMutableArray *infos = [NSMutableArray array];
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@ order by id desc", WMBrwoseHistoryTable]];
        
        while ([rs next])
        {
            WMGoodInfo *info = [[WMGoodInfo alloc] init];
            info.goodId = [rs stringForColumn:WMBrwoseHistoryGoodId];
            info.productId = [rs stringForColumn:WMBrwoseHistoryProductId];
            info.goodName = [rs stringForColumn:WMBrwoseHistoryName];
            info.price = [rs stringForColumn:WMBrwoseHistoryPrice];
            info.marketPrice = [rs stringForColumn:WMBrwoseHistoryMarketPrice];
            info.imageURL = [rs stringForColumn:WMBrwoseHistoryImageURL];
            [infos addObject:info];
        }
        
        [rs close];
    }];
    
    return infos;
}

/**插入一条浏览记录
 *@param info 商品信息
 *@return 是否插入成功
 */
+ (BOOL)insertBrowseHistoryWithInfo:(WMGoodInfo*) info
{
    if(!info || !info.productId)
        return NO;
    
    __block BOOL result = NO;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        ///删除存在的相同商品
        [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@='%@'", WMBrwoseHistoryTable, WMBrwoseHistoryProductId, info.productId]];
        
        result = [db executeUpdate:[NSString stringWithFormat:
                                    @"insert into %@(%@,%@,%@,%@,%@,%@) values(?,?,?,?,?,?)",
                                    WMBrwoseHistoryTable,
                                    WMBrwoseHistoryGoodId,
                                    WMBrwoseHistoryProductId,
                                    WMBrwoseHistoryName,
                                    WMBrwoseHistoryImageURL,
                                    WMBrwoseHistoryPrice,
                                    WMBrwoseHistoryMarketPrice],
                                    info.goodId,
                                    info.productId,
                                    info.goodName,
                                    info.imageURL,
                                    info.price,
                                    info.marketPrice];
        
        ///判断保存的浏览记录是否已达到20条
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select count(*) from %@", WMBrwoseHistoryTable]];
        
        sqlite3_int64 count = 0;
        while ([rs next])
        {
            count = [rs longLongIntForColumnIndex:0];
            break;
        }
        
        [rs close];
        
        if(count > 20)
        {
            ///删除前20条以外的所有记录
            [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where id not in (select id from %@ order by id desc limit 0,20)", WMBrwoseHistoryTable, WMBrwoseHistoryTable]];
        }
    }];
    
    return result;
}

/**删除一条浏览记录
 *@param productId 货品id
 *@return 是否删除成功
 */
+ (BOOL)deleteBrowseHistoryWithProductId:(NSString*) productId
{
    if(!productId)
        return NO;
    
    __block BOOL result = NO;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
        
        result = [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@='%@'", WMBrwoseHistoryTable, WMBrwoseHistoryProductId, productId]];
    }];
    
    return result;
}

/**删除所有浏览记录
 *@return 是否删除成功
 */
+ (BOOL)deleteAllBrowseHistory
{
    __block BOOL result = NO;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
        
        result = [db executeUpdate:[NSString stringWithFormat:@"delete from %@", WMBrwoseHistoryTable]];
    }];
    
    return result;
}

/**获取我的足迹数量
 */
+ (int)browseHistoryCount
{
    __block int count = 0;
    [[WMDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select count(*) from %@", WMBrwoseHistoryTable]];
        while ([rs next])
        {
            count = [rs intForColumnIndex:0];
            break;
        }
        [rs close];
    }];
    
    return count;
}

@end
