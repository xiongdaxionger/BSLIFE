//
//  WMWithDrawInfo.m
//  StandardFenXiao
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMWithDrawInfo.h"

@implementation WMWithDrawInfo

/**初始化
 */
+ (instancetype)returnWithDrawInfoWithArr:(NSArray *)arr{
    
    WMWithDrawInfo *info = [[WMWithDrawInfo alloc] init];
    
    NSMutableArray *noticesInfoArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *infoDict in arr) {
        
        NSString *type = [infoDict sea_stringForKey:@"type"];
        
        if ([type isEqualToString:@"money"]) {
            
            info.maxWithDrawMoney = [infoDict numberForKey:@"max"];
            
            info.minWithDrawMoney = [infoDict numberForKey:@"min"];
            
            info.canWithDrawMoney = [infoDict numberForKey:@"commision"];
        }
        else if ([type isEqualToString:@"tax"]){
            
            NSDictionary *taxDict = @{@"notice":[infoDict sea_stringForKey:@"notice"],@"type":@"notice"};
            
            info.withDrawTax = [infoDict numberForKey:@"val"];
            
            if (info.withDrawTax.doubleValue != 0.0) {
                
                [noticesInfoArr addObject:taxDict];
            }
        }
        else if ([type isEqualToString:@"fee"]){
            
            NSDictionary *platformDict = @{@"notice":[infoDict sea_stringForKey:@"notice"],@"type":@"notice"};
            
            info.withDrawPlatformMoney = [infoDict numberForKey:@"val"];
            
            if (info.withDrawPlatformMoney.doubleValue != 0.0) {
                
                [noticesInfoArr addObject:platformDict];
            }
        }
        else{
            
            [noticesInfoArr addObject:infoDict];
        }
    }
    
    info.noticeInfoArr = [[NSArray alloc] initWithArray:noticesInfoArr];
    
    return info;
}
@end
