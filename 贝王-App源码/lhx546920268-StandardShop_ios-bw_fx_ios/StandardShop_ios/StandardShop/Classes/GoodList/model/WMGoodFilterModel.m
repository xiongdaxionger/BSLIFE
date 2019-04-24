//
//  WMGoodFilterModel.m
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodFilterModel.h"

@implementation WMGoodFilterModel

+ (NSArray *)initWithArr:(NSArray *)arr{
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSDictionary *dict in arr) {
        
        [mutableArr addNotNilObject:[WMGoodFilterModel initWithDict:dict]];
    }
    
    return mutableArr;
}

+ (instancetype)initWithDict:(NSDictionary *)dict{
    
    NSArray *options = [dict arrayForKey:@"options"];
    if(options.count > 0)
    {
        WMGoodFilterModel *model = [[WMGoodFilterModel alloc] init];
        
        model.filterTypeName = [dict sea_stringForKey:@"screen_name"];
        
        model.filterField = [dict sea_stringForKey:@"screen_field"];
        
        model.isSingle = [[dict sea_stringForKey:@"screen_single"] boolValue];
        
        model.filterTypeArr = [WMGoodFilterOptionModel initWithArr:options];
        
        WMGoodFilterOptionModel *optionModel = [model.filterTypeArr firstObject];
        
        if (optionModel.filterLogo) {
            
            model.isLogo = YES;
        }
        else{
            
            model.isLogo = NO;
        }
        
        model.isDrop = NO;
        
        return model;
    }
   
    return nil;
}

@end


@implementation WMGoodFilterOptionModel

+ (NSArray *)initWithArr:(NSArray *)arr{
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSDictionary *dict in arr) {
        
        [mutableArr addObject:[WMGoodFilterOptionModel initWithDict:dict]];
    }
    
    return mutableArr;
}

+ (instancetype)initWithDict:(NSDictionary *)dict{
    
    WMGoodFilterOptionModel *model = [[WMGoodFilterOptionModel alloc] init];
    
    model.filterOptionID = [dict sea_stringForKey:@"val"];
    
    model.filterOptionName = [dict sea_stringForKey:@"name"];
    
    model.filterLogo = [dict sea_stringForKey:@"logo"];
    
    model.isSelect = NO;
    
    return model;
    
}











@end
