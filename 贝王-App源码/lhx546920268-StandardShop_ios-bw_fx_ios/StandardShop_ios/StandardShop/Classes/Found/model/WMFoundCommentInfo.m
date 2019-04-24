//
//  WMFoundCommentInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundCommentInfo.h"

@implementation WMFoundCommentInfo

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMFoundCommentInfo *info = [[WMFoundCommentInfo alloc] init];
    
    info.content = [dic sea_stringForKey:@"content"];
    info.userInfo = [[WMUserInfo alloc] init];
    info.userInfo.headImageURL = [dic sea_stringForKey:WMUserInfoHeadImageURL];
    info.userInfo.userId = [dic sea_stringForKey:WMUserInfoId];
    info.userInfo.name = [dic sea_stringForKey:WMUserInfoName];
    info.userInfo.level = [dic sea_stringForKey:@"member_lv_name"];
    
    NSString *time = [dic sea_stringForKey:@"uptime"];
    info.time = [NSDate previousDateWithTimeInterval:[time doubleValue]];
    
    return info;
}

@end
