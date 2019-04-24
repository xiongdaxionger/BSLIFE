//
//  WMBrandDetailInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMBrandDetailInfo.h"

@implementation WMBrandDetailInfo

+ (instancetype)infoFromDictionary:(NSDictionary *)dic
{
    WMBrandDetailInfo *info = [super infoFromDictionary:dic];
    info.intro = [dic sea_stringForKey:@"brand_desc"];

    if(![NSString isEmpty:info.intro])
    {
        info.intro = [NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], info.intro];
    }

    info.introHeight = 1.0;

    return info;
}

@end
