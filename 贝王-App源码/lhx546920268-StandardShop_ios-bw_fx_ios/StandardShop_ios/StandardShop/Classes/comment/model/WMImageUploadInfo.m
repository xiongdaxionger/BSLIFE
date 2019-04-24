//
//  WMImageUploadInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMImageUploadInfo.h"

@implementation WMImageUploadInfo

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.imageInfo = [[WMImageInfo alloc] init];
    }

    return self;
}



/**获取封面参数
 *@param infos 数组元素是 WMGoodEditImageInfo
 *@return 封面参数
 */
+ (NSString*)imagesParamFromInfos:(NSArray*) infos
{
    NSMutableString *string = [NSMutableString string];

    for(WMImageUploadInfo *info in infos)
    {
        if(![NSString isEmpty:info.imageInfo.imageId])
        {
            [string appendFormat:@"%@,", info.imageInfo.imageId];
        }
    }

    [string removeLastStringWithString:@","];

    return string;
}

/**获取配图参数
 *@param infos 数组元素是 WMGoodEditImageInfo
 *@return 配图参数
 */
+ (NSString*)descriptionsParamFromInfos:(NSArray*) infos
{
    NSMutableString *string = [NSMutableString string];

    for(WMImageUploadInfo *info in infos)
    {
        if(![NSString isEmpty:info.imageInfo.imageURL])
        {
            [string appendFormat:@"<img src=\"%@\"/>", info.imageInfo.imageURL];
        }
    }

    return string;
}


@end
