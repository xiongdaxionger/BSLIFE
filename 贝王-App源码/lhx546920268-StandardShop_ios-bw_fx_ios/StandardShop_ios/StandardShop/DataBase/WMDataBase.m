//
//  WMDataBase.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation WMDataBase
{
    ///数据库队列
    FMDatabaseQueue *_dbQueue;
}

///浏览记录数据库单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t once = 0;
    static WMDataBase *dataBase = nil;
    
    dispatch_once(&once, ^(void){
        
        dataBase = [[WMDataBase alloc] init];
    });
    
    return dataBase;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //创建数据库连接
        NSString *sqlitePath = [self sqlitePath];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:sqlitePath];
        
        
        [_dbQueue inDatabase:^(FMDatabase *db){
            
#if SeaDebug 
            db.logsErrors = YES;
#endif
            if(![db open])
            {
                NSLog(@"不能打开数据库");
            }
            else
            {
                ///创建商品浏览记录表
                if(![db executeUpdate:@"create table if not exists good_browse_history_list(id integer primary key autoincrement,good_id varchar(64),product_id varchar(64),name text,price varchar(64),market_price varchar(64),image_url text,browse_time TIMESTAMP default (datetime('now','localtime')))"])
                {
                    NSLog(@"创建商品浏览记录表失败");
                }
                
                ///创建商品搜索记录表
                if(![db executeUpdate:@"create table if not exists good_search_history_list(id integer primary key autoincrement,search_key text,search_time TIMESTAMP default (datetime('now','localtime')))"])
                {
                    NSLog(@"创建商品搜索记录表失败");
                }
            }
        }];
    }
    
    return self;
}

- (void)dealloc
{
    [_dbQueue close];
}

- (FMDatabaseQueue*)dbQueue
{
    return _dbQueue;
}

///获取数据库地址
- (NSString*)sqlitePath
{
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *sqliteDirectory = [docDirectory stringByAppendingPathComponent:@"sqlite"];
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:sqliteDirectory isDirectory:&isDir];
    
    if(!(exist && isDir))
    {
        if(![fileManager createDirectoryAtPath:sqliteDirectory withIntermediateDirectories:YES attributes:nil error:nil])
        {
            return nil;
        }
        else
        {
            ///防止iCloud备份
            [SeaFileManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:sqliteDirectory isDirectory:YES]];
        }
    }
    
    return [sqliteDirectory stringByAppendingPathComponent:@"dreamsWork"];
}


@end
