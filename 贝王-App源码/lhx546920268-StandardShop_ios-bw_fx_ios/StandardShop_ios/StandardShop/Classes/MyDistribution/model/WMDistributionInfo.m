//
//  WMDistributionInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMDistributionInfo.h"


@implementation WMDistributionInfo

- (NSString*)cur_earnings
{
    if(!_cur_earnings)
    {
        return @"0.00";
    }

    return _cur_earnings;
}

- (NSString*)freeze_earnings
{
    if(!_freeze_earnings)
    {
        return @"0.00";
    }

    return _freeze_earnings;
}

- (NSString*)today_earnings
{
    if(!_today_earnings)
    {
        return @"0.00";
    }

    return _today_earnings;
}

- (NSString*)cumulative_earnings
{
    if(!_cumulative_earnings)
    {
        return @"0.00";
    }

    return _cumulative_earnings;
}

/**获取分销首页信息
 *@return 数组元素是 WMDistributionEarningsInfo
 */
- (NSArray*)distributionEarningsInfos
{
    return [NSArray arrayWithObjects:
            [WMDistributionEarningsInfo infoWithTitle:@"冻结收益" content:self.freeze_earnings],
            [WMDistributionEarningsInfo infoWithTitle:@"今日收益" content:self.today_earnings],
            [WMDistributionEarningsInfo infoWithTitle:@"累计收益" content:self.cumulative_earnings], nil];
}

@end

@implementation WMDistributionEarningsInfo

///遍历构造方法
+ (instancetype)infoWithTitle:(NSString*) title content:(NSString*) content
{
    WMDistributionEarningsInfo *info = [[WMDistributionEarningsInfo alloc] init];
    info.title = title;
    info.content = content;

    return info;
}

@end
