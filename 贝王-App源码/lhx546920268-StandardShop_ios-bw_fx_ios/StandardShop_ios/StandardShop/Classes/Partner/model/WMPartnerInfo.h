//
//  WMPartnerInfo.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/2.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMUserInfo.h"

/**会员信息
 */
@interface WMPartnerInfo : NSObject

///用户信息
@property(nonatomic,strong) WMUserInfo *userInfo;

///带来收益金额
@property(nonatomic,copy) NSString *earnAmount;

///收益富文本
@property(nonatomic,copy) NSAttributedString *earnAmountAttributedString;

///订单数量
@property(nonatomic,assign) int orderCount;

///订单数量富文本
@property(nonatomic,copy) NSAttributedString *orderCountAttributedString;

///下线人数
@property(nonatomic,assign) int referral;

///收货地址
@property(nonatomic,copy) NSString *area;

///注册时间
@property(nonatomic,copy) NSString *registerTime;

///从字典中创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

@end
