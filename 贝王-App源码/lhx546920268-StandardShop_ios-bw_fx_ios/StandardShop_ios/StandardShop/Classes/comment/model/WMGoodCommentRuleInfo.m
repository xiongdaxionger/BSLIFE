//
//  WMGoodCommentRuleInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentRuleInfo.h"
#import "WMGoodCommentScoreInfo.h"

@implementation WMGoodCommentRuleInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    WMGoodCommentRuleInfo *info = [[WMGoodCommentRuleInfo alloc] init];
    info.codeURL = [dic sea_stringForKey:@"verifyCode"];
    info.placeHolder = [dic sea_stringForKey:@"submit_comment_notice"];

    NSArray *array = [dic arrayForKey:@"comment_goods_type"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

    for(NSDictionary *dict in array)
    {
        WMGoodCommentScoreInfo *score = [[WMGoodCommentScoreInfo alloc] init];
        score.name = [dict sea_stringForKey:@"name"];
        score.Id = [dict sea_stringForKey:@"type_id"];
        score.isDefault = [[dict numberForKey:@"is_default"] boolValue];

        [infos addObject:score];
    }

    info.scoreInfos = infos;

    return info;
}

@end
