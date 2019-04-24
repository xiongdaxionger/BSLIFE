//
//  WMMeListInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///我信息类型
typedef NS_ENUM(NSInteger, WMMeListInfoTyp)
{
    ///意见反馈
    WMMeListInfoTypFeedback,

    ///我的活动
    WMMeListInfoTypActivity,
    
    ///客户服务
    WMMeListInfoTypeService,

    ///收货地址
    WMMeListInfoTypShippingAddress,

    ///帮助中心
    WMMeListInfoTypHelpCenter,

    ///预售订单
    WMMeListInfoTypPresellOrder,

    ///售后服务
    WMMeListInfoTypRefundService,
    
    ///商品收藏
    WMMeListInfoTypCollect,
    
    ///我的足迹
    WMMeListInfoTypHistory,
    
    ///领券中心
    WMMeListInfoTypDrawCoupons,
    
    ///合伙人加盟
    WMMeListInfoTypJoinIn,
    
    ///我的客户
    WMMeListInfoTypMyCumstomer,
    
    ///收钱
    WMMeListInfoTypCollectMoney,
    
    ///统计
    WMMeListInfoTypStatistical,
    
    ///存取记录
    WMMeListInfoTypAccess,
};

/// 我列表信息
@interface WMMeListInfo : NSObject

///信息类型
@property(nonatomic,assign) WMMeListInfoTyp type;

///标题
@property(nonatomic,copy) NSString *title;

///副标题
@property(nonatomic,copy) NSString *subtitle;

///图标
@property(nonatomic,strong) UIImage *icon;

///构造方法
+ (instancetype)infoWithType:(WMMeListInfoTyp) type;

/**我 所有列表信息
 *@return 数组元素是 WMMeListInfo
 */
+ (NSMutableArray*)meListInfos;

@end
