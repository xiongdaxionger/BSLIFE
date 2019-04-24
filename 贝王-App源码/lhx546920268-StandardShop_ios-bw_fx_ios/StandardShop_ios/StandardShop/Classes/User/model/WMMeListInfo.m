//
//  WMMeListInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMMeListInfo.h"
#import "WMUserInfo.h"

@implementation WMMeListInfo

///构造方法
+ (instancetype)infoWithType:(WMMeListInfoTyp) type
{
    WMMeListInfo *info = [[WMMeListInfo alloc] init];
    info.type = type;
    
    switch (type)
    {
        case WMMeListInfoTypShippingAddress :
        {
            info.title = @"收货地址";
            info.icon = [UIImage imageNamed:@"me_shippingAddress"];
        }
            break;
        case WMMeListInfoTypHelpCenter :
        {
            info.title = @"帮助中心";
            info.icon = [UIImage imageNamed:@"me_helpCenter"];
        }
            break;
        case WMMeListInfoTypActivity :
        {
            info.title = @"我的活动";
            info.icon = [UIImage imageNamed:@"me_activity"];
        }
            break;
        case WMMeListInfoTypFeedback :
        {
            info.title = @"意见反馈";
            info.icon = [UIImage imageNamed:@"me_feedback"];
        }
            break;
        case WMMeListInfoTypPresellOrder :
        {
            info.title = @"预售订单";
            info.icon = [UIImage imageNamed:@"me_presell_order"];
        }
            break;
        case WMMeListInfoTypRefundService :
        {
            info.title = @"售后服务";
            info.icon = [UIImage imageNamed:@"me_refund_service"];
        }
            break;
        case WMMeListInfoTypCollect :
        {
            info.title = @"商品收藏";
        }
            break;
        case WMMeListInfoTypHistory :
        {
            info.title = @"我的足迹";
        }
            break;
        case WMMeListInfoTypDrawCoupons:
        {
            info.title = @"领券中心";
            info.icon = [UIImage imageNamed:@"me_drawcoupons"];
        }
            break;
        case WMMeListInfoTypeService :
        {
            info.title = @"客户服务";
            info.icon = [UIImage imageNamed:@"me_service"];
        }
            break;
        case WMMeListInfoTypCollectMoney :
        {
            info.title = @"收钱";
            info.icon = [UIImage imageNamed:@"me_collect_money"];
        }
            break;
        case WMMeListInfoTypMyCumstomer :
        {
            info.title = @"我的会员";
            info.icon = [UIImage imageNamed:@"me_partner"];
        }
            break;
        case WMMeListInfoTypJoinIn:
        {
            info.title = @"合伙人加盟";
            info.icon = [UIImage imageNamed:@"me_join_in"];
        }
            break;
        case WMMeListInfoTypStatistical :
        {
            info.title = @"统计";
            info.icon = [UIImage imageNamed:@"me_stasticcal"];
        }
            break;
        case WMMeListInfoTypAccess :
        {
            info.title = @"存取记录";
        }
            break;
    }
    
    return info;
}

/**我 所有列表信息
 *@return 数组元素是 NSArray 数组元素是 WMMeListInfo
 */
+ (NSMutableArray*)meListInfos
{
    NSMutableArray *infos = [NSMutableArray array];
    
    infos = [NSMutableArray arrayWithObjects:
             [WMMeListInfo infoWithType:WMMeListInfoTypCollect],
             [WMMeListInfo infoWithType:WMMeListInfoTypHistory],
             [WMMeListInfo infoWithType:WMMeListInfoTypRefundService],
             [WMMeListInfo infoWithType:WMMeListInfoTypDrawCoupons],
             [WMMeListInfo infoWithType:WMMeListInfoTypActivity],
             [WMMeListInfo infoWithType:WMMeListInfoTypShippingAddress],
             [WMMeListInfo infoWithType:WMMeListInfoTypeService], nil];

    
    if([WMUserInfo sharedUserInfo].personCenterInfo.openPresell)
    {
        [infos insertObject:[WMMeListInfo infoWithType:WMMeListInfoTypPresellOrder] atIndex:2];
    }

    if(![AppDelegate instance].isLogin)
    {
        [infos addObject:[WMMeListInfo infoWithType:WMMeListInfoTypJoinIn]];
    }
    
    if([WMUserInfo sharedUserInfo].enableUseFenXiao)
    {
        [infos addObject:[WMMeListInfo infoWithType:WMMeListInfoTypMyCumstomer]];
        [infos addObject:[WMMeListInfo infoWithType:WMMeListInfoTypCollectMoney]];
        [infos addObject:[WMMeListInfo infoWithType:WMMeListInfoTypStatistical]];
    }
    
    [infos addObject:[WMMeListInfo infoWithType:WMMeListInfoTypAccess]];
    
    return infos;
}

@end
