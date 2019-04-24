//
//  WMIntegralOperation.m
//  AKYP
//
//  Created by 罗海雄 on 15/11/25.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMIntegralOperation.h"
#import "WMIntegralInfo.h"
#import "WMInegralGoodInfo.h"
#import "WMIntegralSignInInfo.h"
#import "WMUserInfo.h"
#import "WMUserOperation.h"

@implementation WMIntegralOperation

/**获取积分使用记录 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)integralUseHistoryParamWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.point_history", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
}

/**获取积分使用记录 结果
 *@param integralInfo 积分信息
 *@param totalSize 积分历史记录总数
 *@return 数组元素是 WMIntegralHistoryInfo
 */
+ (NSArray*)integralUseHistoryFromData:(NSData*) data integralInfo:(WMIntegralInfo**) integralInfo totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        ///积分信息
        if(integralInfo != nil)
        {
            *integralInfo = [WMIntegralInfo infoFromDictionary:dataDic];
        }

        if(totalSize != nil)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }

        NSArray *array = [dataDic arrayForKey:@"historys"];
        
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dict in array)
        {
            [infos addObject:[WMIntegralHistoryInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**获取积分规则 参数
 */
+ (NSDictionary*)integralRuleParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.point_rule", WMHttpMethod, nil];
}

/**获取积分规则，结果
 *@return html 字符串
 */
+ (NSString*)integralRuleResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSString *html = [dataDic sea_stringForKey:@"explain"];
        return [NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], html];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**积分签到 参数
 */
+ (NSDictionary*)integralSignInParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.signin", WMHttpMethod, nil];
}

/**积分签到 结果
 */
+ (WMIntegralSignInInfo*)integralSignInResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        WMIntegralSignInInfo *info = [WMIntegralSignInInfo infoFromDictionary:dataDic];
        NSString *msg = [dic sea_stringForKey:@"msg"];
        info.message = msg;
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**积分商品列表 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)integralGoodListParamWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"gift.gift.lists", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, nil];
}

/**积分商品列表 结果
 *@param totalSize 总数
 *@return 数组元素是 WMInegralGoodInfo
 */
+ (NSArray*)integralGoodListFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        if(totalSize != nil)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        NSArray *array = [dataDic arrayForKey:@"data"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            WMInegralGoodInfo *info = [[WMInegralGoodInfo alloc] init];
            info.goodName = [dict sea_stringForKey:@"name"];
            info.imageURL = [dict sea_stringForKey:@"image_default_id"];
            info.goodId = [dict sea_stringForKey:@"goods_id"];
            info.productId = [dict sea_stringForKey:@"product_id"];
            info.integral = [dict sea_stringForKey:@"consume_score"];
            
            [infos addObject:info];
        }
        
        return infos;
    }
    
    return nil;
}

@end
