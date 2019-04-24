//
//  WMPayMessageInfo.m
//  StandardShop
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPayMessageInfo.h"
#import "WMPayMethodModel.h"

@implementation WMPayUserDepositInfo

+ (instancetype)returnPayUserDepositInfoWithDict:(NSDictionary *)dict{
    
    WMPayUserDepositInfo *info = [WMPayUserDepositInfo new];
    
    info.hasSetPayPassWord = [[dict numberForKey:@"has_pay_password"] boolValue];
    
    info.depositMoeny = [dict sea_stringForKey:@"deposit_money"];
    
    info.formatDepostiMoney = [dict sea_stringForKey:@"deposit_money_format"];
    
    info.combinationMoney = [dict sea_stringForKey:@"cur_money"];
    
    info.firstCombinationMoeny = info.combinationMoney;
    
    info.formatCombinationMoney = [dict sea_stringForKey:@"cur_money_format"];
    
    return info;
}


@end

@implementation WMPayMessageInfo

+ (instancetype)returnPayMessageInfoWithDict:(NSDictionary *)dict{
    
    WMPayMessageInfo *info = [WMPayMessageInfo new];
    
    NSDictionary *orderDict = [dict dictionaryForKey:@"order"];
    
    info.formatTotalMoney = [orderDict sea_stringForKey:@"current_amount_text"];
    
    info.totalMoney = [orderDict sea_stringForKey:@"cur_money"];
    
    info.isPrepare = [[orderDict sea_stringForKey:@"promotion_type"] isEqualToString:@"prepare"];
    
    NSDictionary *settingDict = [dict dictionaryForKey:@"setting"];
    
    info.canCombinationPay = [[settingDict sea_stringForKey:@"combination_pay"] isEqualToString:@"true"];
    
    info.payButtonTitle = [settingDict sea_stringForKey:@"pay_btn"];
    
    info.canPay = ![NSString isEmpty:info.payButtonTitle];
    
    info.payRejectReason = [settingDict sea_stringForKey:@"no_btn_message"];
    
    info.paymentsArr = [WMPayMethodModel returnPayInfoArrWith:[dict arrayForKey:@"payments"]];
    
    info.combinationPaymentsArr = [WMPayMethodModel returnPayInfoArrWith:[dict arrayForKey:@"combination_pay_payments"]];
    
    info.userDepositInfo = [WMPayUserDepositInfo returnPayUserDepositInfoWithDict:[dict dictionaryForKey:@"memberInfo"]];
    
    info.currency = [orderDict sea_stringForKey:@"currency"];
 
    info.orderID = [orderDict sea_stringForKey:@"order_id"];
    
    info.selectPayID = [[orderDict dictionaryForKey:@"payinfo"] sea_stringForKey:@"pay_app_id"];
    
    return info;
}















@end
