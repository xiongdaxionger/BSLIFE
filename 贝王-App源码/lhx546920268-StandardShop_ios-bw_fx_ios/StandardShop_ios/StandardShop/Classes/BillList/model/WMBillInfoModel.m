//
//  WMBillInfoModel.m
//  StandardFenXiao
//
//  Created by mac on 15/12/4.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMBillInfoModel.h"
#import "NSDate+Utilities.h"

@implementation WMBillInfoModel

/**批量初始化
 */
+ (NSMutableArray *)billListInfoArrWith:(NSArray *)dictArr{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:dictArr.count];

    for (NSDictionary *dict in dictArr) {
        
        [mutArr addObject:[WMBillInfoModel billListInfoWith:dict]];
    }
    
    return mutArr;
}

+ (instancetype)billListInfoWith:(NSDictionary *)dict{
    
    WMBillInfoModel *infoModel = [[WMBillInfoModel alloc] init];
    
    infoModel.billImageView = [dict sea_stringForKey:@"img"];
    
    NSString *import_money = [dict sea_stringForKey:@"import_money"];
    
    if ([NSString isEmpty:import_money]) {
        
        infoModel.billPriceStr = [dict sea_stringForKey:@"explode_money"];
        
        infoModel.billIsAdd = NO;
    }
    else{
        
        infoModel.billPriceStr = import_money;
        
        infoModel.billIsAdd = YES;
    }
    
    infoModel.billContentStr = [dict sea_stringForKey:@"message"];
    
    infoModel.billOrderID = [NSString isEmpty:[dict sea_stringForKey:@"order_id"]] ? [dict sea_stringForKey:@"memo"] : [dict sea_stringForKey:@"order_id"];
    
    infoModel.billTimeStr = [NSDate formatTimeInterval:[dict sea_stringForKey:@"mtime"] format:DateFormatYMdHms];
    
    return infoModel;
}




@end
