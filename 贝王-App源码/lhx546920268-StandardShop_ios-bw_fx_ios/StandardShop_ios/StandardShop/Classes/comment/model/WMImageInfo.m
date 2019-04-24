//
//  WMImageInfo.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/8.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMImageInfo.h"

@implementation WMImageInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    
    WMImageInfo *info = [[WMImageInfo alloc] init];
    info.imageId = [dic sea_stringForKey:@"imgpath"];
    info.imageURL = [dic sea_stringForKey:@"imgurl"];
    
    return info;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    WMImageInfo *info = [[WMImageInfo allocWithZone:zone] init];
    info.image = self.image;
    info.imageId = self.imageId;
    info.imageURL = self.imageURL;
    info.locationImageURL = self.locationImageURL;
    
    return info;
}

- (void)dealloc
{
    if(![NSString isEmpty:_locationImageURL])
    {
        [SeaFileManager deleteOneFile:_locationImageURL];
    }
}

@end
