//
//  WMShippingMethodInfo.m
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippingMethodInfo.h"

@implementation WMShippingMethodInfo

/**批量初始化
 */
+ (NSArray *)returnShippingMethodInfoWithDictsArr:(NSArray *)dictsArr{
    
    NSMutableArray *infosArr = [NSMutableArray new];
    
    for (NSDictionary *dict in dictsArr) {
        
        WMShippingMethodInfo *methodInfo = [WMShippingMethodInfo new];
        
        methodInfo.methodExpressMessage = [dict sea_stringForKey:@"text"];
        
        methodInfo.methodID = [dict sea_stringForKey:@"dt_id"];
        
        methodInfo.methodJsonValue = [dict sea_stringForKey:@"value"];
        
        methodInfo.methodName = [dict sea_stringForKey:@"dt_name"];
        
        methodInfo.methodPrice = [dict sea_stringForKey:@"money"];
        
        NSNumber *expressProtect = [dict numberForKey:@"protect"];
        
        if (expressProtect) {
            
            methodInfo.isExpressProtect = [[dict numberForKey:@"protect"] boolValue];
            
            methodInfo.isExpressSelect = [[dict numberForKey:@"protect_checked"] boolValue];
        }
        else{
            
            methodInfo.isExpressProtect = NO;
                        
            methodInfo.isExpressSelect = NO;
        }
        
        [infosArr addObject:methodInfo];
    }
    
    return infosArr;
}

@end
