//
//  WMLoginPageInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/11/28.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMLoginPageInfo.h"
#import "WXApi.h"

@implementation WMLoginPageInfo

///从字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMLoginPageInfo *info = [[WMLoginPageInfo alloc] init];
    
    if([[dic numberForKey:@"show_varycode"] boolValue])
    {
        info.imageCodeURL = [dic sea_stringForKey:@"code_url"];
    }
    
    NSArray *array = [dic arrayForKey:@"login_image_url"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
    
    for(NSDictionary *dict in array)
    {
        [infos addNotNilObject:[WMSocialLoginTypeInfo infoFromDictionary:dict]];
    }
    
    info.socialLogins = infos;
    
    return info;
}

@end

@implementation WMSocialLoginTypeInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    NSString *name = [dic sea_stringForKey:@"name"];
    NSString *title = nil;
    UIImage *image = nil;
    
    WMPlatformType type = WMPlatformTypeNotknow;
    
    if([name isEqualToString:@"qq"])
    {
        type = WMPlatformTypeQQ;
        title = @"QQ登录";
        image = [UIImage imageNamed:@"login_qq"];
    }
    else if ([name isEqualToString:@"weixin"])
    {
        if([WXApi isWXAppInstalled])
        {
            type = WMPlatformTypeWeixin;
            title = @"微信登录";
            image = [UIImage imageNamed:@"login_weixin"];
        }
    }
    
    if(type != WMPlatformTypeNotknow)
    {
        WMSocialLoginTypeInfo *info = [[WMSocialLoginTypeInfo alloc] init];
        info.image = image;
        info.type = type;
        info.title = title;
        
        return info;
    }
    
    return nil;
}


@end
