//
//  WMMessageOperation.m
//  WanShoes
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMessageOperation.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"
#import "WMMessageCenterInfo.h"
#import "WMMessageInfo.h"

@implementation WMMessageOperation

/**获取消息中心信息 参数
 */
+ (NSDictionary*)messageCenterInfosParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.msg_center", WMHttpMethod, nil];
}

/**获取消息中心信息 结果
 *@return 数组元素是 WMMessageCenterInfo
 */
+ (NSArray*)messageCenterInfosFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSArray *array = [dataDic arrayForKey:@"msg_center"];
        
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        for(NSDictionary *dict in array)
        {
            [infos addNotNilObject:[WMMessageCenterInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    
    return nil;
}

/**获取消息列表 参数
 *@param info 消息中心信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)messageListParamsWithInfo:(WMMessageCenterInfo*) info pageIndex:(int) pageIndex
{
    ///获取评论回复和咨询回复
    if(info.type == WMMessageTypeSystem && info.selectedSubInfo.type != WMMessageCenterSubTypeAdminReply)
    {
        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.comment", WMHttpMethod, info.selectedSubInfo.key, @"type", [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.inbox", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, info.selectedSubInfo.type == WMMessageCenterSubTypeAdminReply ? info.selectedSubInfo.key : info.key, @"msg_type", nil];
}

/**获取消息列表 结果
 *@param info 消息中心信息
 *@param totalSize 列表总数
 *@return 数组元素是 WMMessageInfo 或其子类
 */
+ (NSArray*)messageListFromData:(NSData*) data info:(WMMessageCenterInfo*) info totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        if(totalSize != nil)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        NSArray *array = [dataDic arrayForKey:@"message"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        switch (info.type)
        {
            case WMMessageTypeActivity :
            case WMMessageTypeNotice :
            {
                if(info.type == WMMessageTypeActivity)
                {
                    for(NSDictionary *dict in array)
                    {
                        [infos addObject:[WMMessageActivityInfo infoFromDictionary:dict]];
                    }
                }
                else
                {
                    for(NSDictionary *dict in array)
                    {
                        [infos addObject:[WMMessageNoticeInfo infoFromDictionary:dict]];
                    }
                }
                
                return infos;
            }
                break;
            case WMMessageTypeWealth :
            {
                for(NSDictionary *dict in array)
                {
                    NSString *name = [dict sea_stringForKey:@"coupon_name"];
                    if(![NSString isEmpty:name])
                    {
                        [infos addObject:[WMMessageCouponsInfo infoFromDictionary:dict]];
                    }
                    else
                    {
                        WMMessageInfo *info = [WMMessageInfo infoFromDictionary:dict];
                        info.subtype = WMMessageSubtypeEarnings;
                        [infos addObject:info];
                    }
                }
                
                return infos;
            }
                break;
            case WMMessageTypeSystem :
            {
                WMMessageSubtype subtype = WMMessageSubtypeNotkonw;
                
                switch (info.selectedSubInfo.type)
                {
                    case WMMessageCenterSubTypeAdminReply :
                    {
                        subtype = WMMessageSubtypeSystem;
                    }
                        break;
                    case WMMessageCenterSubTypeCommentReply :
                    {
                        subtype = WMMessageSystemInfoGoodComment;
                        array = [dataDic arrayForKey:@"commentList"];
                    }
                        break;
                    case WMMessageCenterSubTypeAdviceReply:
                    {
                        subtype = WMMessageSystemInfoConsult;
                         array = [dataDic arrayForKey:@"commentList"];
                    }
                        break;
                    default:
                        break;
                }
                
                if(subtype != WMMessageSubtypeNotkonw)
                {
                    for(NSDictionary *dict in array)
                    {
                        [infos addObject:[WMMessageSystemInfo infoFromDictionary:dict type:subtype]];
                    }
                }
                
                return infos;
            }
                break;
            case WMMessageTypeOrder :
            {
                for(NSDictionary *dict in array)
                {
                    [infos addObject:[WMMessageOrderInfo infoFromDictionary:dict]];
                }
                
                return infos;
            }
                break;
            default:
                break;
        }
    }
    
    return nil;
}

/**把消息标记成已读 参数
 *@param info 消息信息
 */
+ (NSDictionary*)messageMarkReadParamsWithInfo:(WMMessageInfo*) info
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.view_msg", WMHttpMethod, info.Id, @"comment_id", nil];
}

@end
