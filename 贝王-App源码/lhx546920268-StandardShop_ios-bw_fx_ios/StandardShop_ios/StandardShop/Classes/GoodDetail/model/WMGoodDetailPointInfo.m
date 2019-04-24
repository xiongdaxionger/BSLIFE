//
//  WMGoodDetailPointInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailPointInfo.h"

@implementation WMGoodDetailPointInfo
/**初始化
 */
+ (instancetype)returnGoooDetailPointInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailPointInfo *pointInfo = [WMGoodDetailPointInfo new];
    
    pointInfo.goodCommentCount = [dict sea_stringForKey:@"discussCount"];
    
    pointInfo.goodPointCount = [dict sea_stringForKey:@"total_point_nums"];
    
    NSDictionary *goods_point = [dict dictionaryForKey:@"goods_point"];
    
    pointInfo.goodPointStarCount = [goods_point sea_stringForKey:@"avg_num"];
    
    pointInfo.goodPointSum = [goods_point sea_stringForKey:@"total"];
    
    pointInfo.goodPointAverage = [goods_point sea_stringForKey:@"avg_num"];
    
    pointInfo.goodBestPointRate = [goods_point sea_stringForKey:@"best_avg"];

    return pointInfo;
}
@end
