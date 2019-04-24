//
//  WMHomeStatisticalInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/17.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMHomeStatisticalInfo.h"

@implementation WMHomeStatisticalInfo

- (NSString*)todayIncome
{
    if([NSString isEmpty:_todayIncome])
    {
        return @"0";
    }
    
    return _todayIncome;
}

- (NSString*)totalIncome
{
    if([NSString isEmpty:_totalIncome])
    {
        return @"0";
    }
    
    return _totalIncome;
}

- (NSString*)monthSale
{
    if([NSString isEmpty:_monthSale])
    {
        return @"0";
    }
    
    return _monthSale;
}

- (NSString*)todayVisitor
{
    if([NSString isEmpty:_todayVisitor])
    {
        return @"0";
    }
    
    return _todayVisitor;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.todayIncome = [aDecoder decodeObjectForKey:@"todayIncome"];
        self.totalIncome = [aDecoder decodeObjectForKey:@"totalIncome"];
        self.monthSale = [aDecoder decodeObjectForKey:@"monthSale"];
        self.todayVisitor = [aDecoder decodeObjectForKey:@"todayVisitor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.todayIncome forKey:@"todayIncome"];
    [aCoder encodeObject:self.totalIncome forKey:@"totalIncome"];
    [aCoder encodeObject:self.monthSale forKey:@"monthSale"];
    [aCoder encodeObject:self.todayVisitor forKey:@"todayVisitor"];
}

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMHomeStatisticalInfo *info = [[WMHomeStatisticalInfo alloc] init];
    info.todayIncome = [dic sea_stringForKey:@"day"];
    info.totalIncome = [dic sea_stringForKey:@"total"];
    info.monthSale = [dic sea_stringForKey:@"month_sale"];
    info.todayVisitor = [dic sea_stringForKey:@"day_visit"];
    
    return info;
}

@end
