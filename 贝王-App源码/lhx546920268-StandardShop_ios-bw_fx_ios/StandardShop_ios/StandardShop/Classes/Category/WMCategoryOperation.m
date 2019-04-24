//
//  WMCategoryOperation.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMCategoryOperation.h"
#import "WMCategoryInfo.h"
#import "WMUserOperation.h"

@implementation WMCategoryOperation

/**获取商品分类 参数
 */
+ (NSDictionary*)goodCategoryParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.gallery.cat", WMHttpMethod, nil];
}

/**从返回的数据获取商品分类
 *@return 数组元素是 WMCategoryInfo
 */
+ (NSMutableArray*)goodCategoryFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        ///分类
        NSDictionary *catDic = [dataDic dictionaryForKey:@"cat"];
        NSDictionary *infoDic = [catDic dictionaryForKey:@"info"];

        ///0 是一级分类
        NSDictionary *treeDic = [catDic dictionaryForKey:@"tree"];
        NSArray *items = [treeDic objectForKey:@"0"];

        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:items.count];
        
        ///一级分类
        for(NSString *Id in items)
        {
            NSDictionary *dict = [infoDic objectForKey:Id];
            if(dict)
            {
                WMCategoryInfo *info = [WMCategoryInfo infoFromDictionary:dict];
                [infos addObject:info];

                ///拿二级分类
                NSArray *items2 = [treeDic objectForKey:Id];
                if(items2.count > 0)
                {
                    info.categoryInfos = [NSMutableArray arrayWithCapacity:items2.count];
                    for(NSString *Id2 in items2)
                    {
                        NSDictionary *dict2 = [infoDic objectForKey:Id2];
                        if(dict2)
                        {
                            WMCategoryInfo *info2 = [WMCategoryInfo infoFromDictionary:dict2];
                            [info.categoryInfos addObject:info2];

                            ///拿3级分类
                            NSArray *items3 = [treeDic objectForKey:Id2];
                            if(items3.count > 0)
                            {
                                info.existThreeCategory = YES;
                                info2.categoryInfos = [NSMutableArray arrayWithCapacity:items3.count];
                                for(NSString *Id3 in items3)
                                {
                                    NSDictionary *dict3 = [infoDic objectForKey:Id3];
                                    if(dict3)
                                    {
                                        WMCategoryInfo *info3 = [WMCategoryInfo infoFromDictionary:dict3];
                                        [info2.categoryInfos addObject:info3];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ///拿虚拟分类
        catDic = [dataDic dictionaryForKey:@"vcat"];
        infoDic = [catDic dictionaryForKey:@"info"];

        ///0 是一级分类
        treeDic = [catDic dictionaryForKey:@"tree"];
        items = [treeDic objectForKey:@"0"];

        ///一级分类
        for(NSString *Id in items)
        {
            NSDictionary *dict = [infoDic objectForKey:Id];
            if(dict)
            {
                WMCategoryInfo *info = [WMCategoryInfo infoFromDictionary:dict];
                info.isVirtualCategory = YES;
                [infos addObject:info];

                ///拿二级分类
                NSArray *items2 = [treeDic objectForKey:Id];
                if(items2.count > 0)
                {
                    info.categoryInfos = [NSMutableArray arrayWithCapacity:items2.count];
                    for(NSString *Id2 in items2)
                    {
                        NSDictionary *dict2 = [infoDic objectForKey:Id2];
                        if(dict2)
                        {
                            WMCategoryInfo *info2 = [WMCategoryInfo infoFromDictionary:dict2];
                            info2.isVirtualCategory = YES;
                            info2.pInfo = info;
                            [info.categoryInfos addObject:info2];

                            ///拿3级分类
                            NSArray *items3 = [treeDic objectForKey:Id];
                            if(items3.count > 0)
                            {
                                info.existThreeCategory = YES;
                                info2.categoryInfos = [NSMutableArray arrayWithCapacity:items3.count];
                                for(NSString *Id3 in items3)
                                {
                                    NSDictionary *dict3 = [infoDic objectForKey:Id3];
                                    if(dict3)
                                    {
                                        WMCategoryInfo *info3 = [WMCategoryInfo infoFromDictionary:dict3];
                                        info3.isVirtualCategory = YES;
                                        info3.pInfo = info2;
                                        [info2.categoryInfos addObject:info3];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return infos;
    }
    
    return nil;
}

@end
