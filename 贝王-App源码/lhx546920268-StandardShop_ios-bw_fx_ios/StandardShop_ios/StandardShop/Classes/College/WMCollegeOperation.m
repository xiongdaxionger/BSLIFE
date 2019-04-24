//
//  WMCollegeOperation.m
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollegeOperation.h"
#import "WMCollegeInfo.h"

@implementation WMCollegeOperation


/**获取学院文章分类列表 参数
 */
+ (NSDictionary*)collegeCategoryListParams;
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.article.getSchoolCategory", WMHttpMethod,nil];
}

/**获取学院文章分类列表 结果
 *@return 数组元素是 WMCollegeCategoryInfo
 */
+ (NSMutableArray *)collegeCategoryListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    

    if([result isEqualToString:WMHttpSuccess])
    {
        NSArray *collegeArray = [dic arrayForKey:WMHttpData];
        NSMutableArray *collegeData = [NSMutableArray arrayWithCapacity:collegeArray.count];

        for (NSDictionary *dict in collegeArray)
        {
            WMCollegeCategoryInfo *info = [[WMCollegeCategoryInfo alloc] init];
            info.Id = [dict sea_stringForKey:@"node_id"];
            info.name = [dict sea_stringForKey:@"node_name"];
            
            [collegeData addObject:info];
        }
        
        return collegeData;
    }
    else
    {
        [AppDelegate needLoginFromDictionary:dic];
    }
    
    return nil;
}

/**通过分类id获取 学院列表信息 参数
 *@param categoryId 分类id
 *@param keyword 搜索关键字
 *@param pageIndex 页码
 *@param pageSize 每页数量
 */
+ (NSDictionary*)collegeListParamsWithCategoryId:(NSString*) categoryId keyword:(NSString*) keyword pageIndex:(int) pageIndex pageSize:(int) pageSize
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"mobileapi.article.getArticleList", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, [NSNumber numberWithInt:pageSize], WMHttpPageSize, nil];
    
    if(categoryId)
    {
        [dic setObject:categoryId forKey:@"category_id"];
    }
    
    if(keyword)
    {
        [dic setObject:keyword forKey:@"keyword"];
    }
    
    return dic;
}

/**获取学院列表信息
 *@return 数组元素是 WMCollegeInfo
 */
+ (NSMutableArray*)collegeListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    NSLog(@"%@", dic);
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSArray *collegeArray = [dic arrayForKey:WMHttpData];
        NSMutableArray *collegeData = [NSMutableArray arrayWithCapacity:collegeArray.count];
        
        for (NSDictionary *dict in collegeArray)
        {
            [collegeData addObject:[WMCollegeInfo decodeCollegeWithData:dict]];
        }
        
        return collegeData;
    }
    else
    {
        [AppDelegate needLoginFromDictionary:dic];
    }
    
    return nil;
}

/**通过学院信息Id获取学院详情
 *@param info 要获取详情的学院信息
 */
+ (NSDictionary*)collegeDetailParamWithInfo:(WMCollegeInfo*) info
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.article.getArticleDetail", WMHttpMethod, info.collegeId, @"article_id", nil];
}

/**获取学院详情
 */
+ (WMCollegeDetailInfo*)collegeDetailFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        WMCollegeDetailInfo *info = [[WMCollegeDetailInfo alloc] init];
        
        info.htmlDetail = [dataDic sea_stringForKey:@"content"];
        
        return info;
    }
    
    return nil;
}

@end
