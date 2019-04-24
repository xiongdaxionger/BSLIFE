//
//  WMAccountSecurityInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///账户安全信息
@interface WMAccountSecurityInfo : NSObject

///已绑定的手机号
@property(nonatomic,copy) NSString *phoneNumber;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
