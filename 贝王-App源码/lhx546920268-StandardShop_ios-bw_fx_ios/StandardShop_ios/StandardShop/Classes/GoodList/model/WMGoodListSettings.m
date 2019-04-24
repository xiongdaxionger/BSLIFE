//
//  WMGoodListSettings.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/27.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodListSettings.h"

@implementation WMGoodListSettings

/**通过字典创建
 *@param dic 包含设置信息的字典
 *@return 一个实例
 */
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    NSDictionary *setting = [dic dictionaryForKey:@"setting"];

    WMGoodListSettings *settings = [[WMGoodListSettings alloc] init];
    settings.showCommentCount = [[setting sea_stringForKey:@"commentListListnum"] boolValue];
    settings.isSingleRow = [[setting sea_stringForKey:@"showtype"] isEqualToString:@"list"];

    return settings;
}

@end
