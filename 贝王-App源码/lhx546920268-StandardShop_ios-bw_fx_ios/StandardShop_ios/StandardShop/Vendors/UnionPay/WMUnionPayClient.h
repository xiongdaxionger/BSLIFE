//
//  WMUnionPayClient.h
//  WanShoes
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPPaymentControl.h"
@interface WMUnionPayClient : NSObject

@property (weak,nonatomic) SeaViewController *controller;

- (void)callClientToPayOrderWithPayMemtDict:(NSDictionary *)dict;

@end
