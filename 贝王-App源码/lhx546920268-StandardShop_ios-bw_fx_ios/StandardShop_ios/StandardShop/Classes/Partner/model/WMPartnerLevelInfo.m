//
//  WMPartnerLevelInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/18.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerLevelInfo.h"

@implementation WMPartnerLevelInfo

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMPartnerLevelInfo *info = [[WMPartnerLevelInfo alloc] init];
    info.levelId = [dic sea_stringForKey:@"member_lv_id"];
    info.levelName = [dic sea_stringForKey:@"name"];
    
    return info;
}

@end
