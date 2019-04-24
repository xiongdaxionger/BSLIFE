//
//  WMGoodDetailPromotionInfo.m
//  StandardShop
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodDetailPromotionInfo.h"
#import "WMGoodDetailOperation.h"

/**促销内容信息
 */
@implementation WMPromotionContentInfo
/**批量初始化
 */
+ (NSArray *)returnPromotionContentInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *infoArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [infoArr addObject:[WMPromotionContentInfo returnPromotionContentInfoWithDict:dict]];
    }
    
    return infoArr;
}

+ (instancetype)returnPromotionContentInfoWithDict:(NSDictionary *)dict{
    
    WMPromotionContentInfo *contentInfo = [WMPromotionContentInfo new];
    
    contentInfo.contentName = [dict sea_stringForKey:@"name"];
    
    contentInfo.contentTag = [NSString stringWithFormat:@"%@",[dict sea_stringForKey:@"tag"]];
    
    contentInfo.tagID = [dict sea_stringForKey:@"tag_id"];
    
    return contentInfo;
}

@end

/**促销详情信息
 */
@implementation WMPromotionDetailInfo

@end

/**赠品促销商品模型
 */
@implementation WMPromotionGoodInfo
/**批量初始化
 */
+ (NSArray *)returnPromotionGoodInfoArrWithDictArr:(NSArray *)dictArr{
    
    NSMutableArray *goodInfoArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictArr) {
        
        [goodInfoArr addObject:[WMPromotionGoodInfo returnPromotionGoodInfoWithDict:dict]];
    }
    
    return goodInfoArr;
}

+ (instancetype)returnPromotionGoodInfoWithDict:(NSDictionary *)dict{
    
    WMPromotionGoodInfo *goodInfo = [WMPromotionGoodInfo new];
    
    goodInfo.goodID = [dict sea_stringForKey:@"goods_id"];
    
    goodInfo.goodName = [dict sea_stringForKey:@"name"];
    
    goodInfo.goodStore = [dict sea_stringForKey:@"store"];
    
    goodInfo.productID = [dict sea_stringForKey:@"product_id"];
    
    return goodInfo;
}

@end

/**商品详情促销信息
 */
@implementation WMGoodDetailPromotionInfo
/**初始化
 */
+ (instancetype)returnGoodDetailPromotionInfoWithDict:(NSDictionary *)dict{
    
    WMGoodDetailPromotionInfo *info = [WMGoodDetailPromotionInfo new];
    
    NSMutableArray *titlesArr = [NSMutableArray new];
    
    info.promotionContentInfosArr = [NSMutableArray new];
    
    NSArray *goodsArr = [dict arrayForKey:@"goods"];
    
    if (goodsArr) {
        
        WMPromotionDetailInfo *goodPromotionInfo = [WMPromotionDetailInfo new];
        
        goodPromotionInfo.type = PromotionTypeGood;
        
        goodPromotionInfo.promotionContentArr = [WMPromotionContentInfo returnPromotionContentInfoArrWithDictArr:goodsArr];
        
        info.goodPromotionInfo = goodPromotionInfo;
        
        for (WMPromotionContentInfo *contentInfo in info.goodPromotionInfo.promotionContentArr) {
            
            [titlesArr addObject:contentInfo.contentTag];
            
            [info.promotionContentInfosArr addObject:contentInfo];
        }
    }
    
    NSArray *ordersArr = [dict arrayForKey:@"order"];
    
    if (ordersArr) {
        
        WMPromotionDetailInfo *orderPromotionInfo = [WMPromotionDetailInfo new];
        
        orderPromotionInfo.type = PromotionTypeOrder;
        
        orderPromotionInfo.promotionContentArr = [WMPromotionContentInfo returnPromotionContentInfoArrWithDictArr:ordersArr];
        
        info.orderPromotionInfo = orderPromotionInfo;
        
//        for (WMPromotionContentInfo *contentInfo in info.orderPromotionInfo.promotionContentArr) {
//            
//            [titlesArr addObject:contentInfo.contentTag];
//            
//            [info.promotionContentInfosArr addObject:contentInfo];
//        }
    }
    
    NSArray *giftsArr = [dict arrayForKey:@"gift"];
    
    if (giftsArr) {
        
        NSArray *giftsGoodArr = [WMPromotionGoodInfo returnPromotionGoodInfoArrWithDictArr:giftsArr];
        
        WMPromotionDetailInfo *giftPromotionInfo = [WMPromotionDetailInfo new];
        
        giftPromotionInfo.type = PromotionTypeGift;
        
        giftPromotionInfo.promotionContentArr = giftsGoodArr;
        
        info.giftPromotionInfo = giftPromotionInfo;
        
        [titlesArr addObject:@" 赠品 "];
        
        NSMutableString *goodsNameString = [NSMutableString new];
        
        NSMutableArray *rangesArr = [NSMutableArray new];
        
        NSInteger rangeBegin = 0;

        for (NSInteger i = 0; i < info.giftPromotionInfo.promotionContentArr.count; i++) {
                        
            WMPromotionGoodInfo *goodInfo = [info.giftPromotionInfo.promotionContentArr objectAtIndex:i];
            
            [rangesArr addObject:[NSValue valueWithRange:NSMakeRange(rangeBegin, goodInfo.goodName.length)]];
            
            if (i == info.giftPromotionInfo.promotionContentArr.count - 1) {
                
                [goodsNameString appendString:[NSString stringWithFormat:@"%@",goodInfo.goodName]];
            }
            else{
                
                [goodsNameString appendString:[NSString stringWithFormat:@"%@\n",goodInfo.goodName]];
            }
            
            rangeBegin += goodInfo.goodName.length + 1;
        }
        
        WMPromotionContentInfo *giftContentInfo = [WMPromotionContentInfo new];
        
        giftContentInfo.contentTag = @"赠品";
        
        giftContentInfo.contentName = goodsNameString;
        
        giftContentInfo.rangeArr = [NSArray arrayWithArray:rangesArr];
        
        [info.promotionContentInfosArr addObject:giftContentInfo];
    }
    
    info.promotionTagTitlesArr = titlesArr;
    
    info.promotionContentHeight = [WMGoodDetailOperation returnTagContentHeightWithMaxWidth:_width_ - WMTagExtraWidth titlesArr:titlesArr extraWidth:WMTagContentExtraWidth tagCellHeight:20.0];
    
    return info;
}
@end














