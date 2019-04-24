//
//  WMPartnerOperation.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerOperation.h"
#import "WMUserOperation.h"
#import "WMPartnerInfo.h"
#import "WMPartnerLevelInfo.h"
#import "WMMyOrderOperation.h"

@implementation WMPartnerOperation

/**添加会员所需信息 参数
 */
+ (NSDictionary*)addPartnerNeedsParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"distribution.fxmem.signup", WMHttpMethod, nil];
}

/**添加会员所需信息 结果
 *@return 如果需要图形验证码，则返回图形验证码链接
 */
+ (NSString*)addPartnerNeedsFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        if([[dataDic numberForKey:@"valideCode"] boolValue])
        {
            return [dataDic sea_stringForKey:@"code_url"];
        }
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**添加会员 参数
 *@param phoneNumber 手机号码
 *@param code 短信验证码
 *@param name 昵称
 *@param passwd 密码
 */
+ (NSDictionary*)addPartnerParamWithPhoneNumber:(NSString*) phoneNumber code:(NSString*) code name:(NSString*) name passwd:(NSString*) passwd
{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"distribution.fxmem.create", WMHttpMethod,
            phoneNumber, @"pam_account[login_name]",
            code, @"vcode",
            name, @"contact[name]",
            passwd, @"pam_account[login_password]",
            passwd, @"pam_account[psw_confirm]",
            [NSNumber numberWithBool:YES], @"license",
            @"ios", @"source",
            [WMUserInfo sharedUserInfo].userId, WMUserInfoId,nil];
}

/**添加会员结果
 *@return 是否添加成功
 */
+ (BOOL)addPartnerResultFromData:(NSData*) data
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

/**获取某个用户的下线 参数
 *@param userId 要获取下线的用户id
 *@param pageIndex 页码
 *@param levelInfo 筛选等级
 *@param orderBy 排序
 *@param keyword 搜索关键字
 */
+ (NSDictionary*)partnerInfoListParamWithUserId:(NSString*) userId
                                      pageIndex:(int) pageIndex
                                      levelInfo:(WMPartnerLevelInfo*) levelInfo
                                        orderBy:(WMPartnerListOrderBy) orderBy
                                        keyword:(NSString*) keyword
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"distribution.fxmem.all_members", WMHttpMethod, userId, WMUserInfoId, [NSNumber numberWithInteger:pageIndex], WMHttpPageIndex, nil];
    
    if(![NSString isEmpty:levelInfo.levelId])
    {
        [dic setObject:levelInfo.levelId forKey:@"member_lv_id"];
    }
    
//    switch (orderBy)
//    {
//        case WMPartnerListOrderByIncome :
//        {
//            [dic setObject:@"income" forKey:@"orderby"];
//        }
//            break;
//        case WMPartnerListOrderByTeam :
//        {
//            [dic setObject:@"nums" forKey:@"orderby"];
//        }
//            break;
//        default:
//            break;
//    }
    
    if(keyword)
    {
        [dic setObject:keyword forKey:@"keyword"];
    }
    
    return dic;
}

/**获取某个用户的下线 结果
 *@param totalSize 列表总数
 *@param hierarchy 分销层级
 */
+ (NSArray*)partnerInfoListFromData:(NSData*) data totalSize:(long long *) totalSize hierarchy:(int*) hierarchy
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        if(hierarchy)
        {
            *hierarchy = [[dataDic numberForKey:@"show_lv"] intValue];
        }
        
        NSArray *array = [dataDic arrayForKey:@"List"];
        
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMPartnerInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**升级会员 参数
 *@param info 要升级的会员
 *@param code 升级码
 */
+ (NSDictionary*)partnerLevelupParamWithInfo:(WMPartnerInfo*) info code:(NSString*) code
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.member.c_fxmen", WMHttpMethod, info.userInfo.userId, WMUserInfoId, code, @"code", nil];
}

/**升级会员 结果
 *@return 新的会员等级信息
 */
+ (WMPartnerLevelInfo*)partnerLevelupResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    NSLog(@"%@", dic);
    
    if([result isEqualToString:WMHttpSuccess])
    {
        return [WMPartnerLevelInfo infoFromDictionary:[dic dictionaryForKey:WMHttpData]];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**获取可筛选的 会员等级 参数
 */
+ (NSDictionary*)partnerLevelListParam
{
    WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.member.my_members_lv", WMHttpMethod, userInfo.userId, WMUserInfoId, nil];
}

/**获取可筛选的 会员等级 参数
 *@return 数组元素是 WMPartnerLevelInfo
 */
+ (NSMutableArray*)partnerLevelListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    NSLog(@"%@", dic);
    
    if([result isEqualToString:WMHttpSuccess])
    {
        NSArray *array = [dic arrayForKey:WMHttpData];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        
        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMPartnerLevelInfo infoFromDictionary:dict]];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**获取会员销售订单 参数
 *@param info 会员信息
 *@param pageIndex 页码
 */
+ (NSDictionary*)partnerOrderListParamWithPartnerInfo:(WMPartnerInfo*) info pageIndex:(int) pageIndex
{
     return [WMMyOrderOperation returnMyOrderParamWithOrderType:OrderTypeAll pageIndex:pageIndex memberID:info.userInfo.userId isCommision:NO];
}

/**获取会员销售订单 结果
 *@param totalSize 列表数量
 *@return 数组元素是 WMOrderListModel
 */
+ (NSArray*)partnerOrderListFromData:(NSData *)data totalSize:(long long*) totalSize
{
    NSDictionary *dict = [WMMyOrderOperation returnMyOrderInfoResultWithData:data canComment:NO];
    
    if(totalSize)
    {
        *totalSize = [[dict numberForKey:@"count"] longLongValue];
    }
    
    return [dict arrayForKey:@"info"];
}

@end
