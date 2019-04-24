//
//  WMMessageCenterInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///消息类型
typedef NS_ENUM(NSInteger,WMMessageType)
{
    ///不识别的消息类型
    WMMessageTypeUnknown,
    
    ///订单消息
    WMMessageTypeOrder,

    ///活动
    WMMessageTypeActivity,
    
    ///商城公告
    WMMessageTypeNotice,

    ///财富资产
    WMMessageTypeWealth,
    
    ///系统消息
    WMMessageTypeSystem,
};

@class WMMessageCenterSubInfo;

///消息中心信息
@interface WMMessageCenterInfo : NSObject

///消息类型
@property(nonatomic,assign) WMMessageType type;

///消息类型字段，用来获取对应的信息的
@property(nonatomic,copy) NSString *key;

///文章栏目id
@property(nonatomic,copy) NSString *articleColumnId;

///消息名称
@property(nonatomic,copy) NSString *name;

///未读消息数量
@property(nonatomic,assign) int unreadMsgCount;

///消息图标
@property(nonatomic,copy) NSString *imageURL;

///消息副标题
@property(nonatomic,copy) NSString *subtitle;

///时间
@property(nonatomic,copy) NSString *time;

///二级消息 数组元素是 WMMessageCenterSubInfo
@property(nonatomic,strong) NSArray *subMessages;

///选中的
@property(nonatomic,strong) WMMessageCenterSubInfo *selectedSubInfo;

///通过字典创建 如果消息类型无法识别，则返回nil
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

typedef NS_ENUM(NSInteger, WMMessageCenterSubType)
{
    ///所有回复
    WMMessageCenterSubTypeAllReply,
    
    ///商品咨询回复
    WMMessageCenterSubTypeAdviceReply,
    
    ///商品评价回复
    WMMessageCenterSubTypeCommentReply,
    
    ///系统回复
    WMMessageCenterSubTypeAdminReply,
    
    ///其他
    WMMessageCenterSubTypeOther,
};

///消息中心子消息
@interface WMMessageCenterSubInfo : NSObject

///消息类型
@property(nonatomic,assign) WMMessageCenterSubType type;

///消息类型字段，用来获取对应的信息的
@property(nonatomic,copy) NSString *key;

///消息名称
@property(nonatomic,copy) NSString *name;

///消息数量
@property(nonatomic,assign) long long count;

///页码
@property(nonatomic,assign) int curPage;

///tableView offset
@property(nonatomic,assign) CGPoint offset;

///消息 数组元素是 WMMessageInfo 或其子类
@property(nonatomic,strong) NSMutableArray *infos;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end

