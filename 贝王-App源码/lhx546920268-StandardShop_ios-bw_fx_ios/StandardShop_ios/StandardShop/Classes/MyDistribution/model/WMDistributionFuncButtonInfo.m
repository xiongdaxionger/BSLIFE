//
//  WMDistributionFuncButtonInfo.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMDistributionFuncButtonInfo.h"

@implementation WMDistributionFuncButtonInfo


/**通过按钮类型初始化
 */
+ (id)infoFromType:(WMDistributionFuncButtonType) type
{
    WMDistributionFuncButtonInfo *info = [[WMDistributionFuncButtonInfo alloc] init];
    info.type = type;
    
    switch (type)
    {
        case WMDistributionFuncButtonTypeTopup :
        {
            info.title = @"充值";
            info.icon = [UIImage imageNamed:@"distribution_topup"];
        }
            break;
        case WMDistributionFuncButtonTypeWithdraw :
        {
            info.title = @"提现";
            info.icon = [UIImage imageNamed:@"distribution_withdraw"];
        }
            break;
        case WMDistributionFuncButtonTypeCollege :
        {
            info.title = @"学院";
            info.icon = [UIImage imageNamed:@"distribution_college"];
        }
            break;
        case WMDistributionFuncButtonTypePromote :
        {
            info.title = @"推广";
            info.icon = [UIImage imageNamed:@"distribution_promote"];
        }
            break;
        case WMDistributionFuncButtonTypeTeam:
        {
            info.title = @"团队";
            info.icon = [UIImage imageNamed:@"distribution_team"];
        }
            break;
        case WMDistributionFuncButtonTypeStatistical :
        {
            info.title = @"统计";
            info.icon = [UIImage imageNamed:@"distribution_statistical"];
        }
            break;
    }
    
    return info;
}

- (BOOL)enableDelete
{
    return NO;
}

/**获取需要显示的按钮
 *@return 数组元素是 WMDistributionFuncButtonInfo
 */
+ (NSArray*)funcButtonInfos
{
    return [NSArray arrayWithObjects:
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypeTopup],
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypeWithdraw],
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypePromote],
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypeTeam],
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypeStatistical],
            [WMDistributionFuncButtonInfo infoFromType:WMDistributionFuncButtonTypeCollege], nil];
}

@end
