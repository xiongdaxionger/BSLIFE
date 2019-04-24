//
//  WMCollege.m
//  WestMailDutyFee
//
//  Created by YUYE on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMCollegeInfo.h"

@implementation WMCollegeCategoryInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.curPage = WMHttpPageIndexStartingValue;
    }
    
    return self;
}

@end

@implementation WMCollegeInfo


+ (WMCollegeInfo *)decodeCollegeWithData:(NSDictionary*)data
{
    WMCollegeInfo *college = [[WMCollegeInfo alloc] init];
    college.collegeId = [data sea_stringForKey:@"article_id"];
    college.title = [data sea_stringForKey:@"title"];
    college.pubtime = [NSDate formatDate:[data sea_stringForKey:@"uptime"] fromFormat:DateFromatYMd toFormat:@"yyyy年MM月dd日"] ;
    college.iamgeUrlString = [data sea_stringForKey:@"image_src"];
    college.introduction = [data sea_stringForKey:@"description"];
    college.detailUrl = [data sea_stringForKey:@"html5_link"];
    
    return college;
}
@end


@implementation WMCollegeDetailInfo


@end