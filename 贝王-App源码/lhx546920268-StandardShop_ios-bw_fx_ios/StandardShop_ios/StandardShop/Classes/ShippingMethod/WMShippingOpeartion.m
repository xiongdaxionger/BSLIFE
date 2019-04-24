//
//  WMShippingOpeartion.m
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippingOpeartion.h"
#import "WMUserOperation.h"
#import "WMShippingMethodInfo.h"
#import "WMServerTimeOperation.h"
#import "NSDate+Utilities.h"
@implementation WMShippingOpeartion

/**获取配送方式 参数
 */
+ (NSDictionary *)returnShippingMethodParamWithAreaID:(NSString *)areaID isFastBuy:(NSString *)isFastBuy isSelfAuto:(BOOL)isSelfAuto
{
    if ([isFastBuy isEqualToString:@"true"]) {
        
        return @{WMHttpMethod:@"b2c.cart.delivery_change",@"isfastbuy":isFastBuy,@"area":areaID,@"is_sotre_auto":isSelfAuto ? @"true" : @"false"};
    }
    else{
        
        return @{WMHttpMethod:@"b2c.cart.delivery_change",@"area":areaID,@"is_sotre_auto":isSelfAuto ? @"true" : @"false"};
    }
}

/**获取配送方式 结果
 */
+ (NSArray *)returnShippingMethodResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:@"code"];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        NSArray *allShippingInfoArr = [WMShippingMethodInfo returnShippingMethodInfoWithDictsArr:[[dict dictionaryForKey:WMHttpData] arrayForKey:@"shippings"]];
        
        return allShippingInfoArr;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:NO];
    }
    
    return nil;
}

/**返回当前时间的后七天自提时间数组
 */
+ (NSArray *)returnBranchTimeArr{
    
    NSTimeInterval currentTime = [WMServerTimeOperation sharedInstance].time;
    
    NSMutableArray *dateArr = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 7; i++) {
        
        currentTime += 3600 * 24;
        
        [dateArr addObject:@{@"timeString":[NSDate formatTimeInterval:[NSString stringWithFormat:@"%f",currentTime] format:@"yyyy-MM-dd"],@"time":[NSString stringWithFormat:@"%.0f",currentTime]}];
    }
    
    return dateArr;
}







@end
