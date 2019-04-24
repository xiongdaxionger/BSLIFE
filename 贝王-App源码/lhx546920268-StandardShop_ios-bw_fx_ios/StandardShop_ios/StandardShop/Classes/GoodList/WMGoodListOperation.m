//
//  WMGoodListOperation.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodListOperation.h"
#import "WMGoodInfo.h"
#import "WMServerTimeOperation.h"
#import "WMUserOperation.h"
#import "WMHomeAdInfo.h"
#import "WMSecondKillInfo.h"
#import "WMGoodFilterModel.h"
#import "WMGoodCollectionInfo.h"
#import "WMGoodListOrderByInfo.h"
#import "WMGoodListSettings.h"
#import "WMBrandDetailInfo.h"
#import "WMUserInfo.h"
#import "WMGoodsAccessRecordInfo.h"

@implementation WMGoodListOperation

/**获取商品列表 参数
 *@param categoryId 商品分类Id
 *@param virtualCategoryId 虚拟分类Id， 和商品分类Id只能二选1
 *@param brandId 品牌id
 *@param promotionTagId 促销标签id
 *@param order 排序方式
 *@param searchKey 搜索关键字
 *@param pageIndex 页码
 *@param filters 筛选参数
 *@param needSettings 是否需要配置信息
 *@param onlyPresell 是否只获取预售
 */
+ (NSDictionary*)goodListParamWithCategoryId:(long long) categoryId
                           virtualCategoryId:(long long) virtualCategoryId
                                     brandId:(NSString*) brandId
                              promotionTagId:(NSString*) promotionTagId
                                       order:(NSString*) order
                                   searchKey:(NSString*) searchKey
                                   pageIndex:(int) pageIndex
                                     filters:(NSDictionary *) filters
                                needSettings:(BOOL) needSettings
                                 onlyPresell:(BOOL) onlyPresell
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if(needSettings)
    {
        [dic setObject:@"b2c.gallery.index" forKey:WMHttpMethod];
    }
    else
    {
        [dic setObject:@"b2c.gallery.getList" forKey:WMHttpMethod];
    }

    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:WMHttpPageIndex];
    
    if(categoryId != 0)
    {
        [dic setObject:[NSNumber numberWithLongLong:categoryId] forKey:@"cat_id"];
    }
    else if (virtualCategoryId != 0)
    {
        [dic setObject:[NSNumber numberWithLongLong:virtualCategoryId] forKey:@"virtual_cat_id"];
    }

    if(brandId)
    {
        [dic setObject:brandId forKey:@"brand_id"];
    }

    if(![NSString isEmpty:order])
    {
        [dic setObject:order forKey:@"orderBy"];
    }
    
    if(searchKey)
    {
        [dic setObject:searchKey forKey:@"search_keywords"];
    }
    
    if(filters.count > 0)
    {
        [dic addEntriesFromDictionary:filters];
    }

    if(promotionTagId)
    {
        [dic setObject:promotionTagId forKey:@"pTag"];
    }
    
    if(onlyPresell)
    {
        [dic setObject:@"true" forKey:@"show_preparesell_goods"];
    }
    
    return dic;
}

/**从返回的数据获取商品信息
 *@param totalSize 商品总数
 *@return key是good,value是数组 数组元素是 WMGoodInfo
 第一页商品时，有排序信息，key是 orderBy，value是数组，数组元素是 WMGoodListOrderByInfo ，筛选信息key是filter,value 是NSString 用来获取筛选信息的分类id
 设置信息，key是setting，value是 WMGoodListSettings，品牌信息 key是 brand，value 是WMBrandDetailInfo
 */
+ (NSDictionary*)goodListFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        ///商品列表
        NSArray *goodItems = [dataDic arrayForKey:@"goodsData"];
        NSMutableArray *goods = [NSMutableArray arrayWithCapacity:goodItems.count];
        
        for(NSDictionary *dict in goodItems)
        {
            [goods addObject:[WMGoodInfo infoFromDictionary:dict]];
        }

        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result setObject:goods forKey:@"good"];

        NSDictionary *screenDic = [dataDic dictionaryForKey:@"screen"];
        ///排序信息
        NSArray *orderBys = [WMGoodListOrderByInfo infosFromDictionary:screenDic];
        if(orderBys)
        {
            [result setObject:orderBys forKey:@"orderBy"];
        }

        ///设置信息
        WMGoodListSettings *settings = [WMGoodListSettings infoFromDictionary:dataDic];
        if(settings)
        {
            [result setObject:settings forKey:@"setting"];
        }

        ///筛选信息
        NSString *categoryId = [screenDic sea_stringForKey:@"cat_id"];
        if(categoryId)
        {
            [result setObject:categoryId forKey:@"filter"];
        }

        ///品牌信息
        NSDictionary *brandDic = [dataDic dictionaryForKey:@"brand_data"];
        if(brandDic)
        {
            WMBrandDetailInfo *info = [WMBrandDetailInfo infoFromDictionary:brandDic];
            [result setObject:info forKey:@"brand"];
        }

        return  result;
    }
    
    return nil;
}

/**返回选中的筛选类型
 */
+ (NSDictionary *)returnGoodSelectFilterTypeStr:(NSArray *)filterArr{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    for (WMGoodFilterModel *model in filterArr) {

        int index = 0;
        for (WMGoodFilterOptionModel *optionModel in model.filterTypeArr) {
            
            if (optionModel.isSelect) {
                
                [dic setObject:optionModel.filterOptionID forKey:[NSString stringWithFormat:@"%@[%d]", model.filterField, index]];
                index ++;
            }
        }
    }
    
    return dic;
}

/**返回筛选商品的类型数组
 */
+ (NSArray *)returnGoodFilterTypeArrWithData:(NSData *)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSDictionary *screenDic = [dataDic dictionaryForKey:@"screen"];
        NSArray *filterArray = [screenDic arrayForKey:@"filter_entries"];
        
        return [WMGoodFilterModel initWithArr:filterArray];
    }
    
    return nil;
}

/**返回筛选商品的参数
 */
+ (NSDictionary *)returnGoodCateFilterParamWithCateID:(NSString *)cateID{
    
    return @{WMHttpMethod:@"b2c.gallery.filter_entries",@"cat_id":cateID};
}

/**获取秒杀商品列表 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)secondKillGoodListWithPageIndex:(int) pageIndex
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"starbuy.special.index", WMHttpMethod, [NSNumber numberWithInt:pageIndex], WMHttpPageIndex, @"2", @"type_id", nil];
}

/**获取秒杀商品列表 结果
 *@return key是 goods 秒杀商品列表 数组元素是 WMSecondKillInfo， key是 ads 轮播广告数组元素是 WMHomeAdInfo ，key是 adSize 轮播广告大小 NSValue CGSizeValue
 */
+ (NSDictionary*)secondKillGoodListFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSArray *items = [dataDic arrayForKey:WMHttpData];
        
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:items.count];
        
        for(NSDictionary *dict in items)
        {
            [infos addObject:[WMSecondKillInfo infoFromDictionary:dict]];
        }
        
        ///轮播广告
        NSDictionary *adDic = [[dataDic dictionaryForKey:@"slideBox"] dictionaryForKey:@"params"];
        items = [adDic arrayForKey:@"pic"];
        
        NSMutableArray *ads = [NSMutableArray arrayWithCapacity:items.count];
        
        for(NSDictionary *dict in items)
        {
            [ads addObject:[WMHomeAdInfo infoFromDictionary:dict]];
        }
        
        CGFloat scale = [[adDic numberForKey:@"scale"] floatValue];
        CGSize size = CGSizeMake(_width_, _width_ / scale);
        
        return [NSDictionary dictionaryWithObjectsAndKeys:infos, @"goods", ads, @"ads", [NSValue valueWithCGSize:size], @"adSize", nil];
    }
    
    return nil;
}

#pragma mark- 商品收藏

/**获取用户收藏信息 参数
 *@param pageIndex 页码
 */
+ (NSDictionary*)collectionListParamPageIndex:(int) pageIndex
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:[NSNumber numberWithInt:pageIndex] forKey:WMHttpPageIndex];
    [dic setObject:@"b2c.member.favorite" forKey:WMHttpMethod];

    return dic;
}

/**从返回的数据获取用户收藏信息
 *@param totalSize 列表数量
 *@return WMCollectionInfo
 */
+ (NSArray*)collectionListFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSArray *array = [dataDic arrayForKey:@"favorite"];
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

        for(NSDictionary *dict in array)
        {
            [infos addObject:[WMGoodCollectionInfo infoFromDictionary:dict]];
        }

        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }

        return infos;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**收藏或取消收藏商品
 *@param type 0 收藏商品，1取消收藏
 */
+ (NSDictionary*)goodCollectParamWithType:(int) type goodId:(NSString*)goodId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:goodId forKey:@"gid"];

    switch (type)
    {
        case 0 :
        {
            [dic setObject:@"b2c.member.ajax_fav" forKey:WMHttpMethod];
            [dic setObject:@"goods" forKey:@"type"];
        }
            break;
        case 1 :
        {
            [dic setObject:@"b2c.member.ajax_del_fav" forKey:WMHttpMethod];
        }
            break;
        default:
            break;
    }
    return dic;
}

/**收藏或取消收藏结果
 */
+ (BOOL)goodCollectResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }

    return NO;
}

#pragma mark- 订阅

/**秒杀商品取消订阅 参数
 *@param productId 货品id
 */
+ (NSDictionary*)secondKillGoodCancelSubscribleWithProductId:(NSString*) productId
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"starbuy.special.del_remind", WMHttpMethod, productId, @"product_id", nil];
}

/**秒杀商品取消订阅 结果
 *@return 是否取消订阅成功
 */
+ (BOOL)secondKillGoodCancelSubscribleFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**秒杀商品订阅 参数
 *@param productId 货品id
 *@param info 秒杀信息
 */
+ (NSDictionary*)secondKillGoodSubScribleWithProductId:(NSString*) productId secondKillInfo:(WMSecondKillInfo*) info
{
    WMUserInfo *userInfo = [WMUserInfo sharedUserInfo];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"starbuy.special.save_remind", WMHttpMethod, productId, @"product_id", @"2", @"type_id", [NSNumber numberWithDouble:info.remindTime], @"remind_time", [NSNumber numberWithDouble:info.beginTime], @"begin_time", userInfo.userId, WMUserInfoId, nil];
}

/**秒杀商品订阅 结果
 *@return 是否订阅成功
 */
+ (BOOL)secondKillGoodSubScribleFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取存列表
 */
+ (NSDictionary*)goodsStoreParamsWithPage:(int) page
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.access", WMHttpMethod, @(page), WMHttpPageIndex, nil];
}

/**获取存列表
 */
+ (NSArray<WMGoodsAccessRecordInfo*>*)goodsStoreFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        ///商品列表
        NSArray *goodItems = [dataDic arrayForKey:@"list"];
        NSMutableArray *goods = [NSMutableArray arrayWithCapacity:goodItems.count];
        
        for(NSDictionary *dict in goodItems)
        {
            [goods addObject:[WMGoodsAccessRecordInfo infoFromDictionary:dict]];
        }
        
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        return  goods;
    }
    
    return nil;
}

/**获取取列表
 */
+ (NSDictionary*)goodsPickParamsWithPage:(int) page
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.access_log", WMHttpMethod, @(page), WMHttpPageIndex, nil];
}

/**获取取列表
 */
+ (NSArray<WMGoodsAccessRecordInfo*>*)goodsPickFromData:(NSData*) data totalSize:(long long*) totalSize
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        ///商品列表
        NSArray *goodItems = [dataDic arrayForKey:@"list"];
        NSMutableArray *goods = [NSMutableArray arrayWithCapacity:goodItems.count];
        
        for(NSDictionary *dict in goodItems)
        {
            [goods addObject:[WMGoodsAccessRecordInfo infoFromDictionary:dict]];
        }
        
        if(totalSize)
        {
            *totalSize = [WMUserOperation totalSizeFromDictionary:dataDic];
        }
        
        return  goods;
    }
    
    return nil;
}

@end
