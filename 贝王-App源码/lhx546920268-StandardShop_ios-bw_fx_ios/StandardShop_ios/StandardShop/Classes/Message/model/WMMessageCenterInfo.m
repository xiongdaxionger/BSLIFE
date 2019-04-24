//
//  WMMessageCenterInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageCenterInfo.h"

@implementation WMMessageCenterInfo

///通过字典创建 如果消息类型无法识别，则返回nil
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    NSString *key = [dic sea_stringForKey:@"type"];
    
    WMMessageType type = WMMessageTypeUnknown;
    
    if([key isEqualToString:@"assets"])
    {
        type = WMMessageTypeWealth;
    }
    else if ([key isEqualToString:@"order"])
    {
        type = WMMessageTypeOrder;
    }
    else if ([key isEqualToString:@"active"])
    {
        type = WMMessageTypeActivity;
    }
    else if ([key isEqualToString:@"article"])
    {
        type = WMMessageTypeNotice;
    }
    else if ([key isEqualToString:@"system"])
    {
        type = WMMessageTypeSystem;
    }
    
    if(type == WMMessageTypeUnknown)
        return nil;
    
    WMMessageCenterInfo *info = [[WMMessageCenterInfo alloc] init];
    info.name = [dic sea_stringForKey:@"name"];
    info.imageURL = [dic sea_stringForKey:@"img"];
    info.unreadMsgCount = [[dic numberForKey:@"nums"] intValue];
    info.key = key;
    info.articleColumnId = [dic sea_stringForKey:@"link"];
    info.type = type;
    
    NSArray *types = [dic arrayForKey:@"re_type"];
    if(types.count > 0)
    {
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:types.count];
        for(NSDictionary *dict in types)
        {
            [infos addNotNilObject:[WMMessageCenterSubInfo infoFromDictionary:dict]];
        }
        
        info.subMessages = infos;
    }
    
    return info;
}

- (int)unreadMsgCount
{
    if(_unreadMsgCount < 0)
    {
        _unreadMsgCount = 0;
    }
    
    return _unreadMsgCount;
}

@end

@implementation WMMessageCenterSubInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.curPage = WMHttpPageIndexStartingValue;
    }
    
    return self;
}

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMMessageCenterSubInfo *info = [[WMMessageCenterSubInfo alloc] init];
    NSString *key = [dic sea_stringForKey:@"type"];
    
    WMMessageCenterSubType type = WMMessageCenterSubTypeOther;
    
    if ([key isEqualToString:@"ask"])
    {
        type = WMMessageCenterSubTypeAdviceReply;
    }
    else if ([key isEqualToString:@"discuss"])
    {
        type = WMMessageCenterSubTypeCommentReply;
    }
    else if ([key isEqualToString:@"system"])
    {
        type = WMMessageCenterSubTypeAdminReply;
    }
    else if ([key isEqualToString:@""])
    {
        type = WMMessageCenterSubTypeAllReply;
    }
    
    info.name = [dic sea_stringForKey:@"name"];
    info.key = key;
    info.type = type;
    
    return info;
}

@end