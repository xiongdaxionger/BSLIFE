//
//  WMDepositClient.m
//  WestMailDutyFee
//
//  Created by qsit on 15/9/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMDepositClient.h"

@interface WMDepositClient ()
@end

@implementation WMDepositClient


- (void)checkResultWithStatusType:(NSNumber *)type errorMsg:(NSString *)errorMsg{
    
    NSInteger index = 0;
    
    if (type.integerValue == DoPayCallBackTypeSuccess) {
            
        index = 2;
        
    }
    else if (type.integerValue == DoPayCallBackTypeCancel){
        
        index = 1;
        
    }
    else if (type.integerValue == DoPayCallBackTypeFail){
        
        if (errorMsg == nil) {
            
            errorMsg = @"支付失败";
        }
            
        index = 1;
        
    }
}

- (void)alertOrderMsg:(NSDictionary *)dict{
    
    [[AppDelegate instance] alertMsg:[dict sea_stringForKey:@"msg"]];
}
@end
