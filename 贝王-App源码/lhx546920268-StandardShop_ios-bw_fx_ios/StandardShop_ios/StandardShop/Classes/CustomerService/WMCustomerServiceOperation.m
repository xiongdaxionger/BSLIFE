//
//  WMCustomerServiceOperation.m
//  StandardShop
//
//  Created by Hank on 16/9/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCustomerServiceOperation.h"
#import "WMUserOperation.h"
#import "WMCustomerServicePhoneInfo.h"

@implementation WMCustomerServiceOperation

/**获取在线客服 参数
 */
+ (NSDictionary *)returnCustomServiceParam{
    
    return @{WMHttpMethod:@"b2c.activity.cs"};
}
/**获取在线客服 结果
 */
+ (NSDictionary *)returnCustomServiceResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        NSDictionary *dataDic = [dict dictionaryForKey:WMHttpData];
        [[WMCustomerServicePhoneInfo shareInstance] infoFromDictionary:dataDic];
        
        return dataDic;
    }
    else{
        
        return nil;
    }
}



@end
