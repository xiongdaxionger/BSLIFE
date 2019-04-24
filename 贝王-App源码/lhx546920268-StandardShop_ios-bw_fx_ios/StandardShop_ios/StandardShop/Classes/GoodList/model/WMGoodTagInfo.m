//
//  WMGoodTagInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodTagInfo.h"

@implementation WMGoodTagInfo

/**通过字典创建
 *@param dic 包含标签信息的字典
 *@return 数组元素是 WMGoodTagInfo
 */
+ (NSArray*)infosFromDictionary:(NSDictionary*) dic
{
    NSArray *array = [dic arrayForKey:@"tags"];
    
    if(array.count > 0)
    {
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];
        for(NSDictionary *dict in array)
        {
            WMGoodTagInfo *info = [[WMGoodTagInfo alloc] init];

            NSDictionary *params = [dict dictionaryForKey:@"params"];
            info.imageURL = [params sea_stringForKey:@"tag_image"];

            ///标签位置
            NSString *position = [params sea_stringForKey:@"pic_loc"];
            if([position isEqualToString:@"bl"])
            {
                info.position = WMGoodTagPositionLeftBottom;
            }
            else if ([position isEqualToString:@"tr"])
            {
                info.position = WMGoodTagPositionRightTop;
            }
            else if ([position isEqualToString:@"br"])
            {
                info.position = WMGoodTagPositionRightBottom;
            }
            else
            {
                info.position = WMGoodTagPositionLeftTop;
            }

            if([NSString isEmpty:info.imageURL])
            {
                info.type = WMGoodTagTypeText;
                info.text = [dict sea_stringForKey:@"tag_name"];
                info.textColor = [UIColor colorFromHexadecimal:[dict sea_stringForKey:@"tag_fgcolor"]];
                info.backgroundColor = [UIColor colorFromHexadecimal:[dict sea_stringForKey:@"tag_bgcolor"]];
            }
            else
            {
                info.type = WMGoodTagTypeImage;
            }

            [infos addObject:info];
        }

        return infos;
    }

    return nil;
}

@end
