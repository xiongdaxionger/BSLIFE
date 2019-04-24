//
//  WMShippingAddressOperation.m
//  WestMailDutyFee
//
//  Created by qsit on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMShippingAddressOperation.h"
#import "AppDelegate.h"
#import "WMAreaInfo.h"
#import "WMShippingAddressInfo.h"
#import "WMUserOperation.h"
#import "WMUserInfo.h"

@implementation WMShippingAddressOperation

/**获取我 的收货地址 参数
 */
+ (NSDictionary*)shippingAddressParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.receiver", WMHttpMethod, nil];
}

/**从返回的数据获取 我的收货地址
 *@return 数组元素是 WMShippingAddressInfo
 */
+ (NSArray*)shippingAddressFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSArray *addrs = [dataDic arrayForKey:@"receiver"];
        
        NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:addrs.count];
        
        for(NSDictionary *dict in addrs)
        {
            WMShippingAddressInfo *info = [[WMShippingAddressInfo alloc] init];
            info.Id = [[dict numberForKey:@"addr_id"] longLongValue];
            info.phoneNumber = [dict sea_stringForKey:@"mobile"];
            info.telPhoneNumber = [dict sea_stringForKey:@"tel"];
            info.consignee = [dict sea_stringForKey:@"name"];
            info.detailAddress = [dict sea_stringForKey:@"addr"];
            info.area = [dict sea_stringForKey:@"txt_area"];
            info.isDefaultAdr = [[dict sea_stringForKey:@"def_addr"] boolValue];
            info.jsonValue = [dict sea_stringForKey:@"value"];
            info.mainland = [dict sea_stringForKey:@"area"];
            
            [infos addObject:info];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**获取 地区信息 参数
 */
+ (NSDictionary*)areaInfoParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobile.index.area", WMHttpMethod, nil];
}

/**从返回的数据中 获取地区信息
 */
+ (NSArray*)areaInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        NSDictionary *infoDic = [dataDic dictionaryForKey:@"info"];

        ///0 是一级地区
        NSDictionary *treeDic = [dataDic dictionaryForKey:@"tree"];
        NSArray *items = [treeDic objectForKey:@"0"];

        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:items.count];

        ///一级地区
        for(NSString *Id in items)
        {
            [infos addNotNilObject:[WMAreaInfo infoFromTreeDic:treeDic infoDic:infoDic areaId:Id]];
        }

        return infos;
    }
    
    return nil;
}

/**获取要编辑的收货地址信息 参数
 *@param Id 地址id
 */
+ (NSDictionary*)editedShippingAddressParamWithId:(long long) Id memberID:(NSString *)memberID
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.modify_receiver", WMHttpMethod,memberID,WMUserInfoId, [NSNumber numberWithLongLong:Id], @"addr_id",nil];
}

/**从返回的数据中 获取编辑的收货地址信息
 */
+ (WMShippingAddressInfo*)editedShippingAddressFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *addrDic = [dic dictionaryForKey:WMHttpData];
        
        WMShippingAddressInfo *info = [[WMShippingAddressInfo alloc] init];
        info.Id = [[addrDic numberForKey:@"addr_id"] longLongValue];
        
        NSDictionary *phoneDic = [addrDic dictionaryForKey:@"phone"];
        info.phoneNumber = [phoneDic sea_stringForKey:@"mobile"];
        info.telPhoneNumber = [phoneDic sea_stringForKey:@"telephone"];
        info.consignee = [addrDic sea_stringForKey:@"name"];
        info.detailAddress = [addrDic sea_stringForKey:@"addr"];
        info.mainland = [addrDic sea_stringForKey:@"area"];
        info.jsonValue = [addrDic sea_stringForKey:@"value"];
        info.area = [WMShippingAddressOperation separateAreaParamFromMainland:info.mainland];
        
        if ([[addrDic sea_stringForKey:@"default"] isEqualToString:@"1"]) {
            
            info.isDefaultAdr = YES;
        }
        else{
            
            info.isDefaultAdr = NO;
        }
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**保存收货地址信息 新增或编辑 参数
 *@param info 新的收获地址信息
 */
+ (NSDictionary*)saveShippingAddressInfo:(WMShippingAddressInfo*) info memberID:(NSString *)memberID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(info.Id != 0)
    {
        [dic setObject:[NSNumber numberWithLongLong:info.Id] forKey:@"addr_id"];
    }
    
//    if(![NSString isEmpty:info.telPhoneNumber])
//    {
//        [dic setObject:info.telPhoneNumber forKey:@"tel"];
//    }
    
    if(![NSString isEmpty:info.phoneNumber])
    {
        [dic setObject:info.phoneNumber forKey:@"mobile"];
    }
    
    [dic setObject:info.consignee forKey:@"name"];
    [dic setObject:info.detailAddress forKey:@"addr"];
    [dic setObject:info.mainland forKey:@"area"];
    [dic setObject:memberID forKey:WMUserInfoId];
    [dic setObject:@"b2c.member.save_rec" forKey:WMHttpMethod];

    if (info.isDefaultAdr) {
        [dic setObject:@"1" forKey:@"def_addr"];
    }
    else{
        [dic setObject:@"0" forKey:@"def_addr"];
    }
    return dic;
}

/**保存收货地址信息结果
 *@return 地址Id
 */
+ (WMShippingAddressInfo *)saveShippingAddressResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        WMShippingAddressInfo *info = [[WMShippingAddressInfo alloc] init];
        info.Id = [[dataDic numberForKey:@"addr_id"] longLongValue];
        
        info.phoneNumber = [dataDic sea_stringForKey:@"mobile"];
        info.telPhoneNumber = [dataDic sea_stringForKey:@"tel"];
        info.consignee = [dataDic sea_stringForKey:@"name"];
        info.detailAddress = [dataDic sea_stringForKey:@"addr"];
        info.mainland = [dataDic sea_stringForKey:@"area"];
        info.jsonValue = [dataDic sea_stringForKey:@"value"];
        info.area = [WMShippingAddressOperation separateAreaParamFromMainland:info.mainland];
        
        if ([[dataDic sea_stringForKey:@"def_addr"] isEqualToString:@"1"]) {
            
            info.isDefaultAdr = YES;
        }
        else{
            
            info.isDefaultAdr = NO;
        }
        
        
        
        return info;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**删除收货地址 参数
 *@param info 要删除的收货地址信息
 */
+ (NSDictionary*)deleteShippingAddresInfo:(WMShippingAddressInfo*) info memberID:(NSString *)memberID
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.del_rec", WMHttpMethod,memberID,WMUserInfoId, [NSNumber numberWithLongLong:info.Id], @"addr_id",nil];
}

/**删除收货地址结果
 */
+ (BOOL)deleteShippingAddressResultFromData:(NSData*) data
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

////用于编辑收货地址信息

/**合成地区参数
 *@param infos 数组元素是 WMAreaInfo
 */
+ (NSString*)combineAreaParamFromInfos:(NSArray*) infos
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"mainland:"];
    for(NSInteger i = 0; i < infos.count;i ++)
    {
        WMAreaInfo *info = [infos objectAtIndex:i];
        if(i == infos.count - 1)
        {
            [string appendFormat:@"%@:%lld", info.name, info.Id];
        }
        else
        {
            [string appendString:info.name];
        }
    }
    
    return string;
}

/**分离地区参数
 *@param mainland 地区参数
 */
+ (NSString*)separateAreaParamFromMainland:(NSString*) mainland
{
    if([mainland hasPrefix:@"mainland:"])
    {
        mainland = [mainland stringByReplacingOccurrencesOfString:@"mainland:" withString:@""];
    }
    
    NSArray *array = [mainland componentsSeparatedByString:@":"];
    NSString *string = [array firstObject];
    
    return [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

@end
