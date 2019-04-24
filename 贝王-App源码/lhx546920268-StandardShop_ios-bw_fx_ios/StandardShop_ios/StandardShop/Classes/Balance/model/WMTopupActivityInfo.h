//
//  WMTopupActivityInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///充值活动信息
@interface WMTopupActivityInfo : NSObject

///描述
@property(nonatomic,copy) NSString *desc;

///标题
@property(nonatomic,copy) NSAttributedString *name;

///金额
@property(nonatomic,copy) NSString *amount;

///赠送的东西
@property(nonatomic,copy) NSString *giving;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
