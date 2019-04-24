//
//  WMTopupInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMTopupActivityInfo;

///充值信息
@interface WMTopupInfo : NSObject

///支付方式信息 数组元素是 WMPayMethodModel
@property(nonatomic,strong) NSArray *payInfos;

///充值活动 数组元素是 WMTopupActivityInfo
@property(nonatomic,strong) NSArray *activitys;

///选中的充值活动
@property(nonatomic,strong) WMTopupActivityInfo *selectedActivityInfo;

///充值金额
@property(nonatomic,copy) NSString *amount;

///金钱符号
@property(nonatomic,copy) NSString *amountSymbol;

///是否可以编辑金额
@property(nonatomic,assign) BOOL editable;

///充值规则
@property(nonatomic,copy) NSString *rule;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
