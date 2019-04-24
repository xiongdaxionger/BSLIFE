//
//  WMStoreListInfo.m
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreListInfo.h"

@implementation WMStoreListInfo

+ (NSArray<WMStoreListInfo *> *)parseInfosArrWithDictsArr:(NSArray *)dictsArr {
    
    NSMutableArray *infosArr = [NSMutableArray arrayWithCapacity:dictsArr.count];
    
    for (NSDictionary *dict in dictsArr) {
        
        WMStoreListInfo *info = [WMStoreListInfo new];
        
        info.branchID = [dict sea_stringForKey:@"branch_id"];
        
        info.name = [dict sea_stringForKey:@"name"];
        
        info.province = [dict sea_stringForKey:@"province"];
        
        info.city = [dict sea_stringForKey:@"city"];
        
        info.area = [dict sea_stringForKey:@"area"];
        
        info.address = [dict sea_stringForKey:@"address"];
        
        info.memo = [dict sea_stringForKey:@"memo"];
        
        info.uname = [dict sea_stringForKey:@"uname"];
        
        info.mobile = [dict sea_stringForKey:@"mobile"];
        
        info.distance = [dict sea_stringForKey:@"distance"];
        
        info.latitude = [NSString isEmpty:[dict sea_stringForKey:@"store_lat"]] ? @"" : [dict sea_stringForKey:@"store_lat"];
        
        info.longitude = [NSString isEmpty:[dict sea_stringForKey:@"store_lnt"]] ? @"" : [dict sea_stringForKey:@"store_lnt"];
        
        info.storeLogo = [dict sea_stringForKey:@"stroelogo"];
        
        info.openTime = [dict sea_stringForKey:@"opentime"];
        
        info.areaValueID = [dict sea_stringForKey:@"value"];
        
        info.completeAddress = [NSString stringWithFormat:@"地址:%@%@%@%@",info.province,info.city,info.area,info.address];


        [infosArr addObject:info];
    }
    
    return infosArr;
}
@end
