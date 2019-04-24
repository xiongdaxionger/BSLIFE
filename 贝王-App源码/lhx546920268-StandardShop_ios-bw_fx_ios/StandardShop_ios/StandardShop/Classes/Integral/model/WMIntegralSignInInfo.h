//
//  WMIntegralSignInInfo.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///积分签到结果
typedef NS_ENUM(NSInteger, WMIntegralSignInResult)
{
    ///活动已结束
    WMIntegralSignInResultActivityEnd = 1,
    
    ///首次签到获得积分
    WMIntegralSignInResultFirst = 3,
    
    ///今天已签到
    WMIntegralSignInResultAlready = 4,
    
    ///没有连续签到，重新签到
    WMIntegralSignInResultAgain = 5,
    
    ///连续签到送积分
    WMIntegralSignInResultContinuous = 6,
    
    ///签到成功
    WMIntegralSignInResultSuccess = 7,
};

///积分签到信息
@interface WMIntegralSignInInfo : NSObject

///顶部背景图
@property(nonatomic,copy) NSString *topImageURL;

///签到规则
@property(nonatomic,copy) NSString *rule;

///已签到天数
@property(nonatomic,copy) NSString *signInDay;

///签到的天数接近 的规则 天数
@property(nonatomic,copy) NSString *signInNearDay;

///签到的天数接近 的规则 积分
@property(nonatomic,copy) NSString *signInNearIntegral;

///连续签到的天数信息
@property(nonatomic,copy) NSString *continuousSignInDay;

///分享链接
@property(nonatomic,copy) NSString *shareURL;

///提示信息
@property(nonatomic,copy) NSString *message;

///签到结果
@property(nonatomic,assign) WMIntegralSignInResult result;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
