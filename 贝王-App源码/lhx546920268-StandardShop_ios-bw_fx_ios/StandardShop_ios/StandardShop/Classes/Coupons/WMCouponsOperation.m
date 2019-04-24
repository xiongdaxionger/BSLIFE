//
//  WMCouponsOperation.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCouponsOperation.h"
#import "WMCouponsInfo.h"
#import "WMUserOperation.h"

@implementation WMCouponsOperation

/**获取我的优惠券 参数
 *@param status use 有效的，unuse已过期或已使用的
 *@param filter 筛选 0 不筛选，1 筛选，下单时需要传
 *@param page_no 分页
 */
+ (NSDictionary*)couponsListParamWithType:(NSInteger) type filterType:(NSInteger)filterType pageNumber:(NSInteger)pageNo isFastBuy:(NSString *)isFastBuy
{
    
    NSString *status = type == 0 ? @"use" : @"unuse";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"b2c.member.coupon", WMHttpMethod, status, @"status", [NSNumber numberWithInteger:pageNo],@"page",[NSNumber numberWithInteger:filterType],@"filter_coupon",nil];
    
    if (![NSString isEmpty:isFastBuy]) {
        
        [param setObject:isFastBuy forKey:@"isfastbuy"];
    }
    
    return param;
}

/**从返回的数据获取我的优惠券
 *@param totalSize 优惠券总数
 *@return NSArray 数组元素是 WMCouponsInfo
 */
+ (NSArray*)couponsListFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *data = [dic dictionaryForKey:WMHttpData];
        
        NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:[data arrayForKey:@"coupons"].count];
        
        for(NSDictionary *dict in [data arrayForKey:@"coupons"])
        {
            [infos addObject:[WMCouponsInfo infoFromDictionary:dict]];
        }

        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:data];
        }
        
        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**生成优惠券 参数
 *@param code 优惠券编码
 */
+ (NSDictionary*)couponsCreateWithCode:(NSString*)code{
    
    return @{WMHttpMethod:@"b2c.member.get_coupon",@"cpnsCode":code};
}

/*生成优惠券 结果
 *@return BOOL
 */
+ (BOOL)couponsCreateInfoFromData:(NSData*)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}


/**返回使用优惠券 参数
 *@param 优惠券码 couponCode
 *@param 操作类型 objType
 *@param 是否快速购买 isFastBuy
 */
+ (NSDictionary *)returnUseCouponWithCouponCode:(NSString *)couponCode isFastBuy:(NSString *)isFastBuy objType:(NSString *)objType{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.add" forKey:WMHttpMethod];
    
    [param setObject:couponCode forKey:@"coupon"];
    
    if (![NSString isEmpty:isFastBuy]) {
        
        [param setObject:isFastBuy forKey:@"is_fastbuy"];
    }
    
    [param setObject:objType forKey:@"obj_type"];
    
    return param;
}

/**返回使用优惠券 结果
 */
+ (NSDictionary *)returnCouponUseResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspString = [dict sea_stringForKey:@"code"];
    
    if ([rspString isEqualToString:WMHttpSuccess]) {
        
        return dict;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**获取优惠券使用说明 参数
 */
+ (NSDictionary*)couponsUseIntroParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.coupons_explain", WMHttpMethod, nil];
}

/**获取优惠券使用说明 结果
 *@return 说明html
 */
+ (NSString*)couponsUseIntroFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [dataDic sea_stringForKey:@"explain"];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}


/**取消使用优惠券 参数
 *@param 优惠券码 couponCode
 *@param 是否立即构面 isFastBuy
 */
+ (NSDictionary *)returnCancelUseCouponParamWithCouponCode:(NSString *)couponCode isFastBuy:(NSString *)isFastBuy{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.cart.removeCartCoupon" forKey:WMHttpMethod];
    
    [param setObject:[NSString stringWithFormat:@"coupon_%@",couponCode] forKey:@"cpn_ident"];
    
    if (![NSString isEmpty:isFastBuy]) {
        
        [param setObject:isFastBuy forKey:@"is_fastbuy"];
    }
    
    return param;
}
/**取消使用优惠券 结果
 */
+ (NSDictionary *)returnCancelUseCouponResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([[dict sea_stringForKey:@"code"] isEqualToString:WMHttpSuccess]) {
        
        return [dict dictionaryForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**领券中心 参数
 */
+ (NSDictionary *)returnActivityCouponParam{
    
    return @{WMHttpMethod:@"b2c.activity.coupon_receive"};
}
/**领券中心 结果
 *@return 数组 元素是WMCouponsInfo
 */
+ (NSArray *)returnActivityCouponInfosWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [WMCouponsInfo returnActivityCouponInfosWithDictsArr:[dict arrayForKey:WMHttpData]];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}






@end
