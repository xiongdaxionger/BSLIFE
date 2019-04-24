//
//  WMFoundListInfo.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundListInfo.h"

@implementation WMFoundListInfo

- (instancetype)copyWithZone:(NSZone *)zone
{
    WMFoundListInfo *info = [[WMFoundListInfo allocWithZone:zone] init];
    
    info.Id = self.Id;
    info.title = self.title;
    info.imageURL = self.imageURL;
    info.smallImageURL = self.smallImageURL;
    info.content = self.content;
    info.time = self.time;
    info.isPraised = self.isPraised;
    info.praisedCount = self.praisedCount;
    info.commentCount = self.commentCount;
    info.foundHtml = self.foundHtml;
    info.pName = self.pName;
    
    return info;
}

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMFoundListInfo *info = [[WMFoundListInfo alloc] init];
    
    info.Id = [dic sea_stringForKey:@"article_id"];
    info.title = [dic sea_stringForKey:@"title"];
    info.smallImageURL = [dic sea_stringForKey:@"s_url"];
    info.imageURL = [dic sea_stringForKey:@"url"];
    info.content = [dic sea_stringForKey:@"brief"];
    info.time = [NSDate formatTimeInterval:[dic sea_stringForKey:@"uptime"] format:DateFromatYMd];
    info.isPraised = [[dic sea_stringForKey:@"ifpraise"] boolValue];
    info.praisedCount = [[dic numberForKey:@"praise_nums"] intValue];
    info.commentCount = [[dic numberForKey:@"discuss_nums"] intValue];
    info.pName = [dic sea_stringForKey:@"node_name"];
    info.author = [dic sea_stringForKey:@"author"];
    
    return info;
}

@end
