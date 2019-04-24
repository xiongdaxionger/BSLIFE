//
//  WMGoodDetailGiftInfo.m
//  StandardShop
//
//  Created by Hank on 16/8/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailGiftInfo.h"

@implementation WMGoodDetailGiftInfo

/**初始化
 */
+ (instancetype)returnGoodDetailGiftInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailGiftInfo *giftInfo = [WMGoodDetailGiftInfo new];
    
    giftInfo.canExchangeGift = [[dict numberForKey:@"permission"] boolValue];
    
    giftInfo.notExchangeReason = giftInfo.canExchangeGift ? @"" : [dict sea_stringForKey:@"permissionMsg"];
    
    giftInfo.exchangeMax = [dict sea_stringForKey:@"max"];
    
    giftInfo.consumeScore = [dict sea_stringForKey:@"consume_score"];
    
    giftInfo.beginTime = [NSDate formatTimeInterval:[dict sea_stringForKey:@"from_time"] format:DateFormatYMdHm];
    
    giftInfo.endTime = [NSDate formatTimeInterval:[dict sea_stringForKey:@"to_time"] format:DateFormatYMdHm];
    
    NSMutableString *string = [NSMutableString new];
    
    NSArray *memberArr = [dict arrayForKey:@"member_lv_data"];
    
    for (NSInteger i = 0; i < memberArr.count; i ++) {
        
        NSDictionary *memberDict = [memberArr objectAtIndex:i];
        
        if (i == memberArr.count - 1) {
            
            [string appendString:[memberDict sea_stringForKey:@"name"]];
        }
        else{
            
            [string appendString:[NSString stringWithFormat:@"%@/",[memberDict sea_stringForKey:@"name"]]];
        }
    }
    
    giftInfo.memberLevel = string;
        
    return giftInfo;
}









@end
