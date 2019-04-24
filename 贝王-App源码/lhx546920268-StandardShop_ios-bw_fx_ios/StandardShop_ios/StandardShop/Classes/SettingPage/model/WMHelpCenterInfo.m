//
//  WMHelpCenterInfo.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/9/7.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMHelpCenterInfo.h"


@implementation WMHelpCenterInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMHelpCenterInfo *info = [[WMHelpCenterInfo alloc] init];
    info.Id = [dic sea_stringForKey:@"article_id"];
    info.title = [dic sea_stringForKey:@"title"];

    return info;
}

@end
