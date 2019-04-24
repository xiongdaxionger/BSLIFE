//
//  WMMessageInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGoodInfo.h"
#import "WMGoodCommentInfo.h"
#import "WMAdviceQuestionInfo.h"
#import "WMCouponsInfo.h"

///消息类型
typedef NS_ENUM(NSInteger,WMMessageSubtype)
{
    ///未知的
    WMMessageSubtypeNotkonw = -1,
    
    ///优惠券提醒
    WMMessageSubtypeCoupons,

    ///咨询
    WMMessageSystemInfoConsult,

    ///商品评价
    WMMessageSystemInfoGoodComment,

    ///收益
    WMMessageSubtypeEarnings,
    
    ///系统回复
    WMMessageSubtypeSystem,
};

///消息信息
@interface WMMessageInfo : NSObject

///消息id
@property(nonatomic,copy) NSString *Id;

///时间
@property(nonatomic,copy) NSString *time;

///标题
@property(nonatomic,copy) NSString *title;

///副标题
@property(nonatomic,copy) NSString *subtitle;

///副标题高度
@property(nonatomic,assign) CGFloat subtitleHeight;

///类型
@property(nonatomic,assign) WMMessageSubtype subtype;

///消息类型名称
@property(nonatomic,readonly) NSString *subTypeName;

///是否已读
@property(nonatomic,assign) BOOL read;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

///活动消息
@interface WMMessageActivityInfo : WMMessageInfo

///活动链接
@property(nonatomic,copy) NSString *activityURL;

///活动图片
@property(nonatomic,copy) NSString *imageURL;



///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

///订单消息
@interface WMMessageOrderInfo : WMMessageInfo

///订单id
@property(nonatomic,copy) NSString *orderId;

///商品图片
@property(nonatomic,copy) NSString *imageURL;

///发货id
@property(nonatomic,copy) NSString *delvieryId;

///物流公司
@property(nonatomic,copy) NSString *logistics;

@end

///系统消息
@interface WMMessageSystemInfo : WMMessageInfo

///商品信息
@property(nonatomic,strong) WMGoodInfo *goodInfo;

///商品评价信息
@property(nonatomic,strong) WMGoodCommentInfo *goodCommentInfo;

///商品咨询信息
@property(nonatomic,strong) WMAdviceQuestionInfo *adviceQuestionInfo;

///行数
@property(nonatomic,readonly) NSInteger numberOfRows;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary *)dic type:(WMMessageSubtype) type;

@end

///商品公告消息
@interface WMMessageNoticeInfo : WMMessageInfo

///文章id
@property(nonatomic,copy) NSString *articleId;

///图片
@property(nonatomic,copy) NSString *imageURL;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end


///优惠券消息
@interface WMMessageCouponsInfo : WMMessageInfo

///优惠券信息
@property(nonatomic,strong) WMCouponsInfo *couponsInfo;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end