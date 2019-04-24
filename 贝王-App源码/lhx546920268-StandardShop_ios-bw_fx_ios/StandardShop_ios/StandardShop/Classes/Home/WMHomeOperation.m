//
//  WMHomeOperation.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMHomeOperation.h"
#import "WMGoodInfo.h"
#import "WMServerTimeOperation.h"
#import "WMArticleInfo.h"
#import "WMHomeAdInfo.h"
#import "WMHomeInfo.h"
#import "WMUserOperation.h"
#import "WMHomeDialogAdInfo.h"

@implementation WMHomeOperation

/**获取首页信息 参数
 */
+ (NSDictionary*)homeInfosParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobile.index.index", WMHttpMethod, nil];
}

/**从返回的数据获取首页信息
 *@return 数组元素是 WMHomeInfo
 */
+ (NSMutableArray*)homeInfosFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSArray *array = [dic arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

        for(NSDictionary *dict in array)
        {
            [infos addNotNilObject:[WMHomeInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    
    return nil;
}

/**获取文章 参数
 */
+ (NSDictionary*)articleInfoParamWithArticleId:(NSString*) articleId
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.index", WMHttpMethod, articleId, @"article_id", nil];
}

/**获取文章
 *@return 文章
 */
+ (WMArticleInfo*)articleInfoResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        WMArticleInfo *info = [[WMArticleInfo alloc] init];
        info.title = [[dataDic dictionaryForKey:@"indexs"] sea_stringForKey:@"title"];
        info.contentHtml = [[dataDic dictionaryForKey:@"bodys"] sea_stringForKey:@"content"];
        
        return info;
    }
    
    return nil;
}

/**获取热门搜索 参数
 */
+ (NSDictionary*)hotSearchParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.gallery.hot_search", WMHttpMethod, nil];
}

/**获取热门搜索 结果
 *@return  数组元素是 NSString
 */
+ (NSArray*)hotSearchFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return [dic arrayForKey:WMHttpData];
    }
    
    return nil;
}

/**获取系统服务器时间 参数
 */
+ (NSDictionary*)serverTimeParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobile.index.getTimes", WMHttpMethod,  nil];
}

/**获取系统服务器时间 结果
 *@return 系统服务器时间
 */
+ (NSTimeInterval)serverTimeFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        NSTimeInterval time = [[dataDic numberForKey:@"time"] doubleValue];
        
        
        return time;
    }
    
    return 0;
}

/**搜索联想 参数
 *@param searchKey 要联想的字符
 */
+ (NSDictionary*)searchAssociateWithKey:(NSString*) searchKey
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.search.associate", WMHttpMethod, searchKey, @"value", nil];
}

/**搜索联想 结果
 *@return 联想结果，数组元素是 NSString， 返回nil则表示已关闭联想
 */
+ (NSArray*)searchAssociateResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {
        return [dic arrayForKey:WMHttpData];
    }
    
    return nil;
}

/**获取首页弹窗广告 参数
 *@param time 上次显示广告的时间戳，第一次时传0
 */
+ (NSDictionary *)homeAdDialogParam:(NSTimeInterval)time {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.activity.advertising", WMHttpMethod, @(time), @"time", nil];
}

/**获取首页弹窗广告 数据
 */
+ (WMHomeDialogAdInfo *)parseAdDialogInfoWithData:(NSData *)data {
    
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return [WMHomeDialogAdInfo parseInfoWithDict:[dic dictionaryForKey:WMHttpData]];
    }
    
    return nil;
}

@end
