//
//  WMHomeDialogAdInfo.m
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMHomeDialogAdInfo.h"

#import "WMHomeAdInfo.h"
@implementation WMHomeDialogAdInfo

///解析数据
+ (WMHomeDialogAdInfo *)parseInfoWithDict:(NSDictionary *)dict {
    
    WMHomeDialogAdInfo *info = [WMHomeDialogAdInfo new];
    
    NSString *idString = [NSString isEmpty:[dict sea_stringForKey:@"id"]] ? @"" : [dict sea_stringForKey:@"id"];
    
    NSString *linkString = [NSString isEmpty:[dict sea_stringForKey:@"advertising"]] ? @"" : [dict sea_stringForKey:@"advertising"];

    NSDictionary *adDict = @{@"link":linkString,@"url_id":idString,@"url_type":[dict sea_stringForKey:@"type"]};
    
    info.adInfo = [WMHomeAdInfo infoFromDictionary:adDict];
    
    info.isOpenSetting = [[dict numberForKey:@"advertising_status"] boolValue];
    
    info.needShowAd = [[dict numberForKey:@"status"] boolValue];
    
    return info;
}
@end
