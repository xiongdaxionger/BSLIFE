//
//  WMIntegralSignInInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMIntegralSignInInfo.h"

@implementation WMIntegralSignInInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMIntegralSignInInfo *info = [[WMIntegralSignInInfo alloc] init];
    NSDictionary *data = [dic dictionaryForKey:WMHttpData];
    
    ///规则
    NSDictionary *ruleDic = [data dictionaryForKey:@"rule"];
    
    NSMutableString *rule = [[NSMutableString alloc] init];
    NSString *ruleString = [ruleDic sea_stringForKey:@"new"];
    
    info.topImageURL = [data sea_stringForKey:@"image"];
    
    if(ruleString)
    {
        [rule appendFormat:@"%@\n", ruleString];
    }
    
    ruleString = [ruleDic sea_stringForKey:@"one"];
    if(ruleString)
    {
        [rule appendFormat:@"%@\n", ruleString];
    }
    
    ruleString = [ruleDic sea_stringForKey:@"two"];
    if(ruleString)
    {
        [rule appendFormat:@"%@\n", ruleString];
    }
    
    ruleString = [ruleDic sea_stringForKey:@"three"];
    if(ruleString)
    {
        [rule appendFormat:@"%@\n", ruleString];
    }
    
    [rule removeLastStringWithString:@"\n"];
    
    info.rule = rule;
    
    info.signInDay = [data sea_stringForKey:@"sign_fate"];
    NSDictionary *near = [data dictionaryForKey:@"near"];
    
    info.signInNearDay = [near sea_stringForKey:@"fate"];
    info.signInNearIntegral = [near sea_stringForKey:@"number"];
    
    info.shareURL = [dic sea_stringForKey:@"inv_url"];
    info.continuousSignInDay = [dic sea_stringForKey:@"content"];
    
    info.result = [[dic numberForKey:@"status"] integerValue];
    
    return info;
}

@end
