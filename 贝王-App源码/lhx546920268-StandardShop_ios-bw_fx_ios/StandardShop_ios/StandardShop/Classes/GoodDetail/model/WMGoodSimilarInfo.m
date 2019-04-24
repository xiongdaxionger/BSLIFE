//
//  GoodSimilarViewModel.m
//  SchoolBuy
//
//  Created by Hank on 15/6/25.
//  Copyright (c) 2015年 Hank. All rights reserved.
//

#import "WMGoodSimilarInfo.h"

@implementation WMGoodSimilarInfo

+ (instancetype)createViewModelWithModel:(NSDictionary *)dict{
    
    WMGoodSimilarInfo *viewModel = [WMGoodSimilarInfo new];
    
    viewModel.similarGoodsId = [dict sea_stringForKey:@"goods_id"];
    
    viewModel.similarImageUrl = [dict sea_stringForKey:@"image_default_id"];
    
    viewModel.similarGoodName = [dict sea_stringForKey:@"name"];
    
    viewModel.similarGoodPrice = [dict sea_stringForKey:@"price"];
    
    viewModel.marketable = [[dict sea_stringForKey:@"marketable"] isEqualToString:@"true"];
    
    return viewModel;
}
+ (NSArray *)createViewModelArryWithArry:(NSArray *)modelArry{
    
    NSMutableArray *viewArr = [[NSMutableArray alloc] initWithCapacity:modelArry.count];
    
    for (NSDictionary *dict in modelArry) {
        
        [viewArr addObject:[WMGoodSimilarInfo createViewModelWithModel:dict]];
    }
    return viewArr;
}




@end
