//
//  WMGoodCommentOverallInfo.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodCommentOverallInfo.h"
#import "WMGoodCommentScoreInfo.h"


@implementation WMGoodCommentOverallInfo

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    ///评价信息
    NSDictionary *commentDic = [dic dictionaryForKey:@"comments"];
    
    WMGoodCommentOverallInfo *info = [[WMGoodCommentOverallInfo alloc] init];

    NSDictionary *settings = [commentDic dictionaryForKey:@"setting"];
    info.enableReply = [[settings sea_stringForKey:@"switch_reply"] isEqualToString:@"on"];
    info.codeURL = [settings sea_stringForKey:@"verifyCode"];

    info.totalScore = [[[commentDic dictionaryForKey:@"goods_point"] numberForKey:@"avg_num"] floatValue];

    NSArray *scores = [commentDic arrayForKey:@"_all_point"];
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:MIN(3, scores.count)];

    for(NSInteger i = 0;i < scores.count;i ++)
    {
        NSDictionary *dict = [scores objectAtIndex:i];
        WMGoodCommentScoreInfo *score = [[WMGoodCommentScoreInfo alloc] init];
        score.name = [dict sea_stringForKey:@"type_name"];
        score.score = [[dict numberForKey:@"avg"] floatValue];

        [infos addObject:score];
    }

    info.scoreInfos = infos;
    
    ///筛选信息
    NSArray *filters = [dic arrayForKey:@"goodsDiscuss_type"];
    NSMutableArray *filterInfos = [NSMutableArray arrayWithCapacity:filters.count];
    
    for(NSInteger i = 0;i < filters.count;i ++)
    {
        NSDictionary *dict = [filters objectAtIndex:i];
        WMGoodCommentFilterInfo *filter = [[WMGoodCommentFilterInfo alloc] init];
        filter.name = [dict sea_stringForKey:@"name"];
        filter.value = [dict sea_stringForKey:@"value"];
        filter.count = [[dict numberForKey:@"count"] longLongValue];
        
        [filterInfos addObject:filter];
    }
    info.filterInfos = filterInfos;

    return info;
}

@end

@implementation WMGoodCommentFilterInfo


@end
