//
//  WMSettingOperation.m
//  WanShoes
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSettingOperation.h"
#import "WMAboutMeInfo.h"
#import "WMUserOperation.h"
#import "WMHelpCenterInfo.h"

@implementation WMSettingOperation

/**返回关于我们 参数
 */
+ (NSDictionary*)returnAboutDictParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.activity.about", WMHttpMethod, nil];
}

/**返回关于我们 结果
 */
+ (WMAboutMeInfo*)returnAboutDictResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [WMAboutMeInfo infoFromDictionary:[dict dictionaryForKey:WMHttpData]];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**获取意见返回类型 参数
 */
+ (NSDictionary *)returnFeedBackTypeParam{
    
    return @{WMHttpMethod:@"b2c.member.feedback"};
}
/**获取意见返回类型 结果
 */
+ (NSDictionary *)returnFeedBackTypeResult:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        NSString *phone = [dataDict sea_stringForKey:@"suggest_mobile"];
        
        return @{@"type":[dataDict arrayForKey:@"suggest_type"],@"phone":[NSString isEmpty:phone] ? @"" : phone};
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}
/**意见反馈 参数
 *type 反馈类型
 *title 标题
 *receive 收件人
 *content 反馈内容
 *contact 反馈人的联系方式
 */
+ (NSDictionary*)returnFeedBackParamWith:(NSString *)type content:(NSString *)content contact:(NSString *)contact title:(NSString *)title receive:(NSString *)receive{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:type forKey:@"gask_type"];
    
    [param setObject:content forKey:@"comment"];
    
    [param setObject:title forKey:@"subject"];
    
    [param setObject:@"b2c.member.send_msg" forKey:WMHttpMethod];
    
    [param setObject:receive forKey:@"msg_to"];
    
    if (![NSString isEmpty:contact]) {
        
        [param setObject:contact forKey:@"contact"];
    }
    
    [param setObject:@"true" forKey:@"has_sent"];
    
    return param;
}
/**意见反馈 结果
 */
+ (BOOL)returnFeedBackResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取帮助中心信息 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)helpCenterInfoParamsWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.l", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, @"help", @"node_type", nil];
}

/**获取帮助中心信息
 *@param totalSize 列表总数
 *@return 数组元素是 WMHelpCenterInfo
 */
+ (NSArray*)helpCenterInfoFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        if(totalSize != nil)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }

        NSArray *array = [dataDic arrayForKey:@"articles"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMHelpCenterInfo infoFromDictionary:dict]];
        }

        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**获取帮助中心详情 参数
 */
+ (NSDictionary*)helpCenterDetailParamsWithInfo:(WMHelpCenterInfo*) info
{
     return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.index", WMHttpMethod, info.Id, @"article_id", nil];
}

/**获取帮助中心详情 结果
 *@return 帮助中心html详情
 */
+ (NSString*)helpCenterDetailFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        return [[dataDic dictionaryForKey:@"bodys"] sea_stringForKey:@"content"];
    }
    
    return nil;
}

@end
