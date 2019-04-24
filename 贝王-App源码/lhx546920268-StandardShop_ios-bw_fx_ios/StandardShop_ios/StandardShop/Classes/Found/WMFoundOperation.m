//
//  WMFoundOperation.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundOperation.h"
#import "WMFoundCategoryInfo.h"
#import "WMFoundListInfo.h"
#import "WMFoundCommentInfo.h"
#import "WMUserOperation.h"
#import "WMHomeAdInfo.h"
#import "WMFoundHomeInfo.h"
#import "WMFoundHomeAdCell.h"

@implementation WMFoundOperation

/**获取发现首页 参数
 */
+ (NSDictionary*)foundHomeInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.story_index", WMHttpMethod,  nil];
}

/**获取发现首页 结果
 *@return 数组元素是 WMFoundHomeInfo
 */
+ (NSArray*)foundHomeInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray array];

        ///轮播广告
        NSDictionary  *billBoardDic = [[dataDic arrayForKey:@"slideBox"] firstObject];
        NSArray *array = nil;
        if([billBoardDic isKindOfClass:[NSDictionary class]])
        {
            billBoardDic = [billBoardDic dictionaryForKey:@"params"];
            array = [billBoardDic arrayForKey:@"pic"];
            if(array.count > 0)
            {
                NSMutableArray *ads = [NSMutableArray arrayWithCapacity:array.count];
                for(NSDictionary *dict in array)
                {
                    [ads addObject:[WMHomeAdInfo infoFromDictionary:dict]];
                }
                
                WMFoundHomeInfo *info = [[WMFoundHomeInfo alloc] init];
                info.type = WMFoundHomeInfoTypeBillboards;
                info.infos = ads;
                
                ///宽高比例
                CGFloat scale = [[billBoardDic numberForKey:@"scale"] floatValue];
                if(scale == 0)
                {
                    info.size = WMFoundHomeAdCellSize; ///后台没返回，使用默认大小
                }
                else
                {
                    info.size = CGSizeMake(_width_, _width_ / scale);
                }
                
                [infos addObject:info];
            }
        }
        
        ///靓贴推荐
        array = [dataDic arrayForKey:@"hots"];
        if(array.count > 0)
        {
            NSMutableArray *cats = [NSMutableArray arrayWithCapacity:array.count];
            for(NSDictionary *dict in array)
            {
                [cats addObject:[WMFoundListInfo infoFromDictionary:dict]];
            }
            
            WMFoundHomeInfo *info = [[WMFoundHomeInfo alloc] init];
            info.name = @"靓贴推荐";
            info.infos = cats;
            info.type = WMFoundHomeInfoTypePost;
            [infos addObject:info];
        }
        
        array = [dataDic arrayForKey:@"nodes"];
        if(array.count > 0)
        {
            NSMutableArray *cats = [NSMutableArray arrayWithCapacity:array.count];
            for(NSDictionary *dict in array)
            {
                [cats addObject:[WMFoundCategoryInfo infoFromDictionary:dict]];
            }
            
            WMFoundHomeInfo *info = [[WMFoundHomeInfo alloc] init];
            info.name = @"社区版块";
            info.infos = cats;
            info.type = WMFoundHomeInfoTypePlate;
            [infos addObject:info];
        }
 
        return infos;
    }
    
    return nil;
}

/**通过分类获取发现内容 参数
 *@param info 分类信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)foundListParamWithCategoryInfo:(WMFoundCategoryInfo*) info pageIndex:(int) pageIndex
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"content.article.l", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
    
    if(info.Id)
    {
        [dic setObject:info.Id forKey:@"node_id"];
    }
    else
    {
        [dic setObject:@"stroy" forKey:@"node_type"];
    }
    
    return dic;
}

/**通过分类获取发现内容 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMFoundListInfo
 */
+ (NSArray*)foundListFromData:(NSData*) data totalSize:(long long*) totalSize
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
            [infos addObject:[WMFoundListInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**点赞发现内容 参数
 *@param info 发现内容
 */
+ (NSDictionary*)foundPraiseParamWithInfo:(WMFoundListInfo*) info
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.addPraise", WMHttpMethod, @"true", @"ifpraise", info.Id, @"article_id", nil];
}

/**点赞发现内容 结果
 *@return 是否成功
 */
+ (BOOL)foundPraiseResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    
    return NO;
}

/**评论发现内容 参数
 *@param info 发现内容
 *@param content 评论内容
 *@param code 图形验证码
 */
+ (NSDictionary*)foundCommentParamWithInfo:(WMFoundListInfo*) info content:(NSString*) content code:(NSString*) code
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.addPraise", WMHttpMethod, @"false", @"ifpraise", info.Id, @"article_id", content, @"content", code, @"code", nil];
}

/**评论发现内容 结果
 *@return 是否成功
 */
+ (BOOL)foundCommentResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取文章评论列表 参数
 *@param articleId 文章id
 *@param pageIndex 页码
 */
+ (NSDictionary*)foundCommentListParamWithArticleId:(NSString*) articleId pageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.getcommentlist", WMHttpMethod, @"false", @"ifpraise", [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, articleId, @"article_id", nil];
}

/**获取文章评论列表 结果
 *@param totalSize 列表总数
 *@return 数组元素是 WMFoundCommentInfo
 */
+ (NSArray*)foundCommentListFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        if(totalSize != nil)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        NSArray *array = [dataDic arrayForKey:@"comment_list"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMFoundCommentInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    
    return nil;
}

/**获取发现详情 参数
 *@param articleId 文章id
 */
+ (NSDictionary*)foundDetailWithArticleId:(NSString*) articleId
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"content.article.index", WMHttpMethod, articleId, @"article_id", nil];
}

/**获取发现详情 结果
 *@return 文章详情
 */
+ (WMFoundListInfo*)foundDetailFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        NSDictionary *infoDic = [dataDic dictionaryForKey:@"indexs"];
        WMFoundListInfo *info = [WMFoundListInfo infoFromDictionary:infoDic];
        info.URL = [infoDic sea_stringForKey:@"share_url"];
        
        NSDictionary *bodyDic = [dataDic dictionaryForKey:@"bodys"];
        NSString *html = [bodyDic sea_stringForKey:@"content"];
        if(html)
        {
            info.foundHtml = [NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], html];
        }
        
        info.imageURL = [bodyDic sea_stringForKey:@"image_id"];
        info.smallImageURL = [bodyDic sea_stringForKey:@"s_image_id"];
        
        return info;
    }
    
    return nil;
}

/**获取发现广告 参数
 */
+ (NSDictionary*)foundAdParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.indexad.get_all_list", WMHttpMethod, [NSNumber numberWithInt:22], @"group_id", nil];
}

/**获取发现广告 结果
 *@return 数组元素是 WMHomeAdInfo
 */
+ (NSArray*)foundAdFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSArray *array = [[dic dictionaryForKey:WMHttpData] arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMHomeAdInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    
    return nil;
}

@end
