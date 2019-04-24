//
//  WMDataBase.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

///数据库基类，包含数据库队列的创建及各种表的创建和更新
@interface WMDataBase : NSObject

///数据库队列
@property(nonatomic,readonly) FMDatabaseQueue *dbQueue;

///数据库单例
+ (instancetype)sharedInstance;

@end
