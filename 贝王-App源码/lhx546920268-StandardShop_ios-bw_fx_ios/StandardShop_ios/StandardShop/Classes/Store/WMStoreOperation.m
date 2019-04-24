//
//  WMStoreOperation.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMStoreOperation.h"
#import "WMUserOperation.h"
#import "WMStoreToJoinInfo.h"
#import "WMStoreListInfo.h"


@implementation WMStoreOperation

/**获取门店加盟信息 参数
 */
+ (NSDictionary*)storeToJoinInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.apply.index", WMHttpMethod, nil];
}

/**获取门店加盟信息 结果
 */
+ (WMStoreToJoinInfo*)storeToJoinInfoFromData:(NSData*) data
{
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict])
    {
        NSArray *array = [dict arrayForKey:WMHttpData];
        WMStoreToJoinInfo *info = [[WMStoreToJoinInfo alloc] init];
        
        for(NSDictionary *dic in array)
        {
            NSString *type = [dic sea_stringForKey:@"widgets_type"];
            NSDictionary *params = [dic dictionaryForKey:@"params"];
            
            if([type isEqualToString:@"ad_pic"])
            {
                info.adInfo = [WMHomeAdInfo infoFromDictionary:params];
                info.adInfo.imageURL = [params sea_stringForKey:@"ad_pic"];
            }
            else if([type isEqualToString:@"custom_html"])
            {
                info.msg = [params sea_stringForKey:@"usercustom"];
            }
        }
        
        
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**门店加盟 参数
 *@param phoneNumber 电话
 *@param name 姓名
 *@param city 城市
 */
+ (NSDictionary*)storeToJoinParamWithPhoneNumber:(NSString*) phoneNumber name:(NSString*) name city:(NSString*) city
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.apply.add", WMHttpMethod, name, @"contact", phoneNumber, @"phone", city, @"company", nil];
}

/**门店加盟 结果
 */
+ (BOOL)storeToJoinResultFromData:(NSData*) data
{
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];

    if ([WMUserOperation resultFromDictionary:dict])
    {
        return YES;
        
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return NO;
}

/**获取门店列表 参数
 *@param latitude 维度
 *@param longitude 经度
 *@param keyWord 搜索关键字
 *@param page 页码
 */
+ (NSDictionary*)storeListParamsWithLatitude:(double) latitude longitude:(double) longitude keyWord:(NSString *) keyWord page:(NSInteger)page {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:@"pos.store.store_list" forKey:WMHttpMethod];
    
    [dict setObject:@(page) forKey:@"page"];
    
    if (![NSString isEmpty:keyWord]) {
        
        [dict setObject:keyWord forKey:@"name"];
    }
    
    if (longitude > 0) {
        
        [dict setObject:@(longitude) forKey:@"lnt"];
    }
    
    if (latitude > 0) {
        
        [dict setObject:@(latitude) forKey:@"lat"];
    }
    
    return dict;
}

/**获取门店列表信息 结果
 *@return 数组元素是 WMStoreAreaInfo
 */
+ (NSArray<WMStoreListInfo *> *)parseStoreAddressListWithData:(NSData *)data totalSize:(long long *) totalSize {
    
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        NSArray *array = [dataDic arrayForKey:WMHttpData];
        
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        return [WMStoreListInfo parseInfosArrWithDictsArr:array];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}


@end
