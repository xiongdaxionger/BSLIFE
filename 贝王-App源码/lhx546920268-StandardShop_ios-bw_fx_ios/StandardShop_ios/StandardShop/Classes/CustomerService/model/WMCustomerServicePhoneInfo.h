//
//  WMCustomerServicePhoneInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/11/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///客服电话信息
@interface WMCustomerServicePhoneInfo : NSObject

///客服电话
@property(nonatomic,copy) NSString *servicePhoneNumber;

///上线电话
@property(nonatomic,copy) NSString *uplinePhoneNumber;

///简介
@property(nonatomic,copy) NSString *intro;

///客服类型
@property(nonatomic,copy) NSString *type;

///客服联系方式
@property(nonatomic,copy) NSString *contact;

///要拨打的电话
@property(nonatomic,readonly) NSString *call;

///是否正在加载
@property(nonatomic,readonly) BOOL loading;

///初始化
- (void)infoFromDictionary:(NSDictionary*) dic;

///单例
+ (instancetype)shareInstance;

///清除信息
- (void)clear;

///取消加载
- (void)cancel;

///加载客服信息
- (void)loadInfoWithCompletion:(void(^)(void)) completion;

@end
