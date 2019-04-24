//
//  WMGoodDetailSettingInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailSettingInfo.h"

@implementation WMGoodDetailSettingInfo
/**初始化
 */
+ (instancetype)returnGoodDetailSettingInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailSettingInfo *info = [WMGoodDetailSettingInfo new];
    
    info.goodDetailShowConsume = [[dict sea_stringForKey:@"selllog"] isEqualToString:@"true"];
    
    info.type = [[dict sea_stringForKey:@"buytarget"] integerValue];
    
    NSDictionary *accomment = [dict dictionaryForKey:@"acomment"];
        
    NSDictionary *switchDict = [accomment dictionaryForKey:@"switch"];
    
    info.goodDetailShowAdvice = [[switchDict sea_stringForKey:@"ask"] isEqualToString:@"on"];
    
    info.goodDetailShowComment = [[switchDict sea_stringForKey:@"discuss"] isEqualToString:@"on"];
    
    return info;
}






@end
