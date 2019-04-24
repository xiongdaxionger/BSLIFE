//
//  WMMeInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/31.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMMeInfo.h"
#import "WMMeListInfo.h"

@implementation WMMeInfo

+ (instancetype)infoWithType:(WMMeInfoType) type
{
    WMMeInfo *info = [[WMMeInfo alloc] init];
    info.type = type;
    info.topLineHeight = _separatorLineWidth_;
    info.bottomLineHeight = _separatorLineWidth_;
    
    switch (type)
    {
        case WMMeInfoTypeLogin :
        {
            
        }
            break;
        case WMMeInfoTypeFunc :
        {
            info.topLine = YES;
            info.bottomLine = YES;
            info.infos = [WMMeListInfo meListInfos];
        }
            break;
        case WMMeInfoTypeOrder :
        {
            info.bottomLine = YES;
//            info.bottomLineHeight = 10.0;
        }
            break;
        case WMMeInfoTypeAssets :
        {
            info.topLine = NO;
            info.bottomLine = NO;
//            info.bottomLineHeight = 10.0;
        }
            break;
        case WMMeInfoTypeGoodList :
        {
            info.title = @"为你推荐";
        }
            break;
        case WMMeInfoTypeBindPhone :
        {
            info.title = @"点此绑定手机号，确保账号安全";
            info.bottomLine = YES;
            info.bottomLineHeight = 10.0;
        }
            break;
    }
    
    return info;
}

- (NSInteger)items
{
    switch (self.type)
    {
        case WMMeInfoTypeFunc :
        {
            NSInteger count = self.infos.count;
            return count + (count % 4 == 0 ? 0 : (4 - count % 4));
        }
            break;
        case WMMeInfoTypeGoodList :
        {
            return self.infos.count;
        }
            break;
        case WMMeInfoTypeAssets :
        case WMMeInfoTypeOrder :
        case WMMeInfoTypeBindPhone :
        {
            return 1;
        }
            break;
        case WMMeInfoTypeLogin :
        {
            return 0;
        }
            break;
    }
}

///获取个人中数据 数组元素是 WMMeInfo
+ (NSMutableArray*)meInfos
{
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:4];
    [infos addObject:[WMMeInfo infoWithType:WMMeInfoTypeLogin]];
    [infos addObject:[WMMeInfo infoWithType:WMMeInfoTypeOrder]];
    [infos addObject:[WMMeInfo infoWithType:WMMeInfoTypeAssets]];
    [infos addObject:[WMMeInfo infoWithType:WMMeInfoTypeFunc]];
    
    return infos;
}

@end
