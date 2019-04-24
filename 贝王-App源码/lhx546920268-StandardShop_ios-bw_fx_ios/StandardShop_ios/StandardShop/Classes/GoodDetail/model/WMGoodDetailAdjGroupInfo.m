//
//  WMGoodDetailAdjGroupInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailAdjGroupInfo.h"

@implementation WMGoodDetailAdjGoodInfo
/**批量初始化
 */
+ (NSArray *)returnGoodDetailAdjGoodInfoArrWithDictArr:(NSArray *)dictArr imagesDict:(NSDictionary *)imagesDict{
    
    NSMutableArray *infoArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [infoArr addObject:[WMGoodDetailAdjGoodInfo returnGoodDetailAdjGoodInfoWithDict:dict imagesDict:imagesDict]];
    }
    
    return infoArr;
}

+ (instancetype)returnGoodDetailAdjGoodInfoWithDict:(NSDictionary *)dict imagesDict:(NSDictionary *)imagesDict{
    
    WMGoodDetailAdjGoodInfo *info = [WMGoodDetailAdjGoodInfo new];
    
    info.goodAdjPrice = [dict sea_stringForKey:@"adjprice"];
    
    info.goodID = [dict sea_stringForKey:@"goods_id"];
    
    info.goodInitPrice = [dict sea_stringForKey:@"o_adjprice"];
    
    info.goodMarketAble = [[dict sea_stringForKey:@"marketable"] isEqualToString:@"true"];
    
    info.goodName = [dict sea_stringForKey:@"name"];
    
    info.goodSpecInfo = [dict sea_stringForKey:@"spec_info"];
    
    info.goodStore = [dict sea_stringForKey:@"store"];
    
    info.productID = [dict sea_stringForKey:@"product_id"];
    
    info.goodImage = [imagesDict sea_stringForKey:info.goodID];
    
    return info;
}
@end

@implementation WMGoodDetailAdjGroupInfo
/**批量初始化
 */
+ (NSArray *)returnGoodDetailAdjGroupInfoArrWithDictArr:(NSArray *)dictArr imagesDict:(NSDictionary *)imagesDict{
    
    NSMutableArray *groupInfoArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [groupInfoArr addObject:[WMGoodDetailAdjGroupInfo returnGoodDetailAdjGroupInfoWithDict:dict imagesDict:imagesDict]];
    }
    
    WMGoodDetailAdjGroupInfo *firstGroupInfo = [groupInfoArr firstObject];
    
    firstGroupInfo.groupIsSelect = YES;
    
    return groupInfoArr;
}

+ (instancetype)returnGoodDetailAdjGroupInfoWithDict:(NSDictionary *)dict imagesDict:(NSDictionary *)imagesDict{
    
    WMGoodDetailAdjGroupInfo *groupInfo = [WMGoodDetailAdjGroupInfo new];
    
    groupInfo.groupMaxBuyCount = [[dict sea_stringForKey:@"max_num"] integerValue];
    
    groupInfo.groupName = [dict sea_stringForKey:@"name"];
    
    groupInfo.groupType = [dict sea_stringForKey:@"type"];
    
    groupInfo.groupGoodInfoArr = [WMGoodDetailAdjGoodInfo returnGoodDetailAdjGoodInfoArrWithDictArr:[dict arrayForKey:@"items"] imagesDict:imagesDict];
    
    return groupInfo;
}





@end
