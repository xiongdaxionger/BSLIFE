//
//  WMBalanceInfo.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///余额信息
@interface WMBalanceInfo : NSObject

///余额
@property(nonatomic,copy) NSString *balance;

///当前佣金
@property(nonatomic,copy) NSString *commission;

///累计佣金
@property(nonatomic,copy) NSString *cumulativeCommission;

///冻结佣金
@property(nonatomic,copy) NSString *freezeCommission;

///正在提现
@property(nonatomic,copy) NSString *withdrawing;

///正在提现说明
@property(nonatomic,copy) NSString *withdrawingInstruction;

///累计提现
@property(nonatomic,copy) NSString *cumulativeWithdraw;

///累计提现说明
@property(nonatomic,copy) NSString *cumulativeWithdrawInstruction;

///金钱符号
@property(nonatomic,copy) NSString *moneySymbol;

///是否需要显示佣金
@property(nonatomic,assign) BOOL showCommission;

///是否可以提现
@property(nonatomic,assign) BOOL enableWithdraw;

///通过字典创建
+ (instancetype)infoFromDictionary:(NSDictionary*) dic;

/**获取余额列表信息
 *@return 数组元素是 WMBalanceListInfo
 */
- (NSArray*)balanceList;

@end

///余额列表信息
@interface WMBalanceListInfo : NSObject

///标题
@property(nonatomic,copy) NSString *title;

///提示信息
@property(nonatomic,copy) NSString *msg;

///金额
@property(nonatomic,copy) NSString *amount;

@end
