//
//  WMHomeStatisticalInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/17.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**首页统计信息
 */
@interface WMHomeStatisticalInfo : NSObject<NSCoding>

///今日收入
@property(nonatomic,copy) NSString *todayIncome;

///累计收入
@property(nonatomic,copy) NSString *totalIncome;

///本月销量
@property(nonatomic,copy) NSString *monthSale;

///今日访客
@property(nonatomic,copy) NSString *todayVisitor;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
