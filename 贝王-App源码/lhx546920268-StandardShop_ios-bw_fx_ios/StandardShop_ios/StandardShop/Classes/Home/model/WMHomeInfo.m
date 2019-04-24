//
//  WMHomeInfo.m
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/16.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMHomeInfo.h"
#import "WMServerTimeOperation.h"
#import "WMHomeFlashAdCell.h"
#import "WMHomeAdInfo.h"
#import "WMGoodInfo.h"
#import "WMHomeGoodListCell.h"

@implementation WMHomeInfo

- (NSInteger)numberOfCells
{
    NSInteger count = self.infos.count;
    switch (self.type)
    {
        case WMHomeInfoTypeFlashAd :
        case WMHomeInfoTypeLetters :
        case WMHomeInfoTypeGoodSecondKill:
        {
            count = self.infos.count > 0 ? 1 : 0;
        }
            break;
        default:
            break;
    }
    return count;
}

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic
{
    NSString *typeString = [dic sea_stringForKey:@"widgets_type"];
    WMHomeInfoType type = [WMHomeInfo typeFromString:typeString];
    if(type == WMHomeInfoTypeNotknow)
        return nil;
    
    WMHomeInfo *info = [[WMHomeInfo alloc] init];
    info.type = type;
    
    NSDictionary *params = [dic dictionaryForKey:@"params"];
    if(params.count == 0)
        return nil;
    
    switch (type)
    {
        case WMHomeInfoTypeFlashAd :
        {
            NSArray *pic = [params arrayForKey:@"pic"];
            
            if(pic.count == 0)
                return nil;
            
            ///宽高比例
            CGFloat scale = [[params numberForKey:@"scale"] floatValue];
            if(scale == 0)
            {
                info.size = WMHomeFlashAdCellSize; ///后台没返回，使用默认大小
            }
            else
            {
                info.size = CGSizeMake(_width_, _width_ / scale);
            }
            
            info.infos = [NSMutableArray arrayWithCapacity:pic.count];
            for(NSDictionary *dict in pic)
            {
                [info.infos addObject:[WMHomeAdInfo infoFromDictionary:dict]];
            }
        }
            break;
        case WMHomeInfoTypeHomeCatgory :
        {
            NSArray *nav = [params arrayForKey:@"nav"];
            if(nav.count == 0)
                return nil;
            
            info.infos = [NSMutableArray arrayWithCapacity:nav.count];
            for(NSDictionary *dict in nav)
            {
                NSDictionary *urlDic = [dict dictionaryForKey:@"url"];
                WMHomeAdInfo *adInfo = [WMHomeAdInfo infoFromDictionary:urlDic];
                adInfo.text = [dict sea_stringForKey:@"name"];
                adInfo.imageURL = [dict sea_stringForKey:@"img"];
                [info.infos addObject:adInfo];
            }
        }
            break;
        case WMHomeInfoTypeLetters :
        {
            NSArray *articles = [params arrayForKey:@"articles"];
            if(articles.count == 0)
                return nil;
            
            info.infos = [NSMutableArray arrayWithCapacity:articles.count];
            for(NSDictionary *dict in articles)
            {
                WMHomeAdInfo *adInfo = [[WMHomeAdInfo alloc] init];
                adInfo.adType = WMHomeAdTypeArticle;
                adInfo.text = [dict sea_stringForKey:@"title"];
                adInfo.Id = [dict sea_stringForKey:@"article_id"];
                [info.infos addObject:adInfo];
            }
        }
            break;
        case WMHomeInfoTypeImageAd :
        {
            NSDictionary *banTypeDic = [params dictionaryForKey:@"bantype"];
            NSArray *array = [banTypeDic arrayForKey:@"url"];

            ///屏幕宽度
            CGFloat screenWidth = [[banTypeDic numberForKey:@"window_width"] floatValue];
            NSDictionary *titleDic = [banTypeDic dictionaryForKey:@"title"];
            
            info.shouldDisplaySeparator = [[banTypeDic numberForKey:@"title_unline"] boolValue];
            info.shouldDisplayFooter = [[banTypeDic numberForKey:@"node_unline"] boolValue];
            
            ///标题
            info.shouldDisplayTitle = [[titleDic sea_stringForKey:@"show_title"] boolValue];
            if(info.shouldDisplayTitle)
            {
                info.title = [titleDic sea_stringForKey:@"title_name"];
                info.titleColor = [UIColor colorFromHexadecimal:[titleDic sea_stringForKey:@"color"]];
                info.backgroundColor = [UIColor colorFromHexadecimal:[titleDic sea_stringForKey:@"bgcolor"]];
                info.showLine = [[titleDic numberForKey:@"show_line"] boolValue];
                
                NSString *align = [titleDic sea_stringForKey:@"text_align"];
                if([align isEqualToString:@"right"])
                {
                    info.titleAlignment = NSTextAlignmentRight;
                }
                else if ([align isEqualToString:@"left"])
                {
                    info.titleAlignment = NSTextAlignmentLeft;
                }
                else
                {
                    info.titleAlignment = NSTextAlignmentCenter;
                }
            }
            else if (array.count == 0 && !info.shouldDisplaySeparator && !info.shouldDisplayFooter)
            {
                return nil;
            }
            
            CGFloat scale = _width_ / screenWidth;
            ///间距
            CGFloat margin = [[banTypeDic numberForKey:@"spacing"] floatValue] * scale;
            
            if(margin < 1.0 && margin > 0.0)
            {
                info.minimumLineSpacing = 0.5;
                info.minimumInteritemSpacing = 0.5;
            }
            else
            {
                info.minimumLineSpacing = margin;
                info.minimumInteritemSpacing = margin;
            }
            
            
            
            CGSize size = CGSizeZero;
            size.height = [[banTypeDic numberForKey:@"size_y"] floatValue] * scale;
            size.width = [[banTypeDic numberForKey:@"size_x"] floatValue] * scale;
            
            info.infos = [NSMutableArray array];
            for(NSDictionary *dict in array)
            {
                WMHomeAdInfo *adInfo = [WMHomeAdInfo infoFromDictionary:dict];
                
                if(size.width > 0)
                {
                    adInfo.imageURL = [dict sea_stringForKey:@"img"];
                    adInfo.itemSize = size;
                    [info.infos addObject:adInfo];
                }
                else
                {
                    if(adInfo.itemSize.width > 0 && adInfo.itemSize.height > 0)
                    {
                        adInfo.imageURL = [dict sea_stringForKey:@"img"];
                        adInfo.itemSize = CGSizeMake(adInfo.itemSize.width * scale, adInfo.itemSize.height * scale);
                        [info.infos addObject:adInfo];
                    }
                }
            }
        }
            break;
        case WMHomeInfoTypeGoodList :
        {
            NSArray *array = [params arrayForKey:@"goodsRows"];
            if(array.count == 0)
                return nil;
            
            info.minimumLineSpacing = WMHomeGoodListCellInterval;
            info.minimumInteritemSpacing = WMHomeGoodListCellInterval;
            info.infos = [NSMutableArray arrayWithCapacity:array.count];
            
            for(NSDictionary *dict in array)
            {
                WMGoodInfo *goodInfo = [[WMGoodInfo alloc] init];
                goodInfo.goodId = [dict sea_stringForKey:@"goodsId"];
                goodInfo.productId = [dict sea_stringForKey:@"productId"];
                goodInfo.goodName = [dict sea_stringForKey:@"goodsName"];
                goodInfo.price = [dict sea_stringForKey:@"goodsSalePrice"];
                goodInfo.marketPrice = [dict sea_stringForKey:@"goodsMarketPrice"];
                goodInfo.imageURL = [dict sea_stringForKey:@"goodsPicM"];
                
                [info.infos addObject:goodInfo];
            }
        }
            break;
        case WMHomeInfoTypeGoodSecondKill :
        {
            NSArray *array = [params arrayForKey:@"goodsRows"];
            
            if(array.count == 0)
                return nil;
            
            WMHomeSecondKillInfo *secondKillInfo = [[WMHomeSecondKillInfo alloc] init];
            
            info.infos = [NSMutableArray arrayWithCapacity:1];
            secondKillInfo.infos = [NSMutableArray arrayWithCapacity:array.count];
            
            for(NSDictionary *dict in array)
            {
                WMGoodInfo *goodInfo = [[WMGoodInfo alloc] init];
                goodInfo.goodId = [dict sea_stringForKey:@"goods_id"];
                goodInfo.productId = [dict sea_stringForKey:@"product_id"];
                goodInfo.goodName = [dict sea_stringForKey:@"name"];
                goodInfo.price = [dict sea_stringForKey:@"promotion_price"];
                goodInfo.marketPrice = [dict sea_stringForKey:@"price"];
                goodInfo.imageURL = [dict sea_stringForKey:@"goodsPicM"];
                
                [secondKillInfo.infos addObject:goodInfo];
            }
            
            NSDictionary *promotionDic = [params dictionaryForKey:@"pro"];
            secondKillInfo.Id = [promotionDic sea_stringForKey:@"special_id"];
            secondKillInfo.subtitle = [params sea_stringForKey:@"title_right"];
            secondKillInfo.imageURL = [params sea_stringForKey:@"title_left"];
            secondKillInfo.subTitleColor = [UIColor colorFromHexadecimal:[params sea_stringForKey:@"title_right_color"]];
            secondKillInfo.beginTime = [[promotionDic numberForKey:@"begin_time"] doubleValue];
            secondKillInfo.endTime = [[promotionDic numberForKey:@"end_time"] doubleValue];
            
            [info.infos addObject:secondKillInfo];

        }
            break;
        default:
            break;
    }
    
    return info;
}

///通过字符串类型获取数字类型
+ (WMHomeInfoType)typeFromString:(NSString*) string
{
    WMHomeInfoType type = WMHomeInfoTypeNotknow;
    if([string isEqualToString:@"main_slide"])
    {
        type = WMHomeInfoTypeFlashAd;
    }
    else if ([string isEqualToString:@"wap_index_nav"])
    {
        type = WMHomeInfoTypeHomeCatgory;
    }
    else if ([string isEqualToString:@"article"])
    {
        type = WMHomeInfoTypeLetters;
    }
    else if ([string isEqualToString:@"wap_index_banner"] || [string isEqualToString:@"wap_index_banner2"])
    {
        type = WMHomeInfoTypeImageAd;
    }
    else if ([string isEqualToString:@"goods_shopmax_starbuy"])
    {
        type = WMHomeInfoTypeGoodSecondKill;
    }
    else if ([string isEqualToString:@"index_tab_goods"])
    {
        type = WMHomeInfoTypeGoodList;
    }
    
    return type;
}

@end


@implementation WMHomeSecondKillInfo

/**秒杀是否已经开始
 */
- (BOOL)isSecondKillBegan
{
    return self.beginTime <= [WMServerTimeOperation sharedInstance].time;
}

/**秒杀是否已结束
 */
- (BOOL)isSecondKillEnded
{
    return self.endTime <= [WMServerTimeOperation sharedInstance].time;
}

@end
