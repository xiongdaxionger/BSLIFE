//
//  WMUnionPayClient.m
//  WanShoes
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMUnionPayClient.h"

#import "ConfirmOrderPageController.h"

@implementation WMUnionPayClient

- (void)callClientToPayOrderWithPayMemtDict:(NSDictionary *)dict{
    
    [[UPPaymentControl defaultControl] startPay:[[dict dictionaryForKey:WMHttpData] sea_stringForKey:@"tn"] fromScheme:@"beiwang" mode:@"00" viewController:self.controller];
}
@end
