//
//  WMDoPaymemtClient.m
//  WestMailDutyFee
//
//  Created by qsit on 15/8/29.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMDoPaymemtClient.h"

#import "WMDoPayInfoModel.h"
#import "WeChatPayViewModel.h"
#import "WMUserInfo.h"
@interface WMDoPaymemtClient ()
/**支付信息
 */
@property (strong,nonatomic) NSDictionary *paymemtDict;
/**支付方式
 */
@property (copy,nonatomic) NSString *payAppID;
/**是否需要present
 */
@property (assign,nonatomic) BOOL needPresent;

@end

@implementation WMDoPaymemtClient

#pragma mark - 初始化
- (instancetype)initWithPaymemtDict:(NSDictionary *)paymentDict payAppID:(NSString *)appID{
    
    self = [super init];
    
    if (self) {
    
        _paymemtDict = paymentDict;
                
        _payAppID = appID;
        
    }
    return self;
}

#pragma mark - 调用支付
- (void)callClientToPay{

    if ([_payAppID isEqualToString:WMMAlipayID]) {
        
        WMDoPayInfoModel *doPayModel = [[WMDoPayInfoModel alloc] initWithDict:_paymemtDict];
        
        MALiPayClient *aLiPayClient = [[MALiPayClient alloc] initPayWithModel:doPayModel];
        
        [aLiPayClient usingMAiLiPayToPayOrder];
    }
    else if ([_payAppID isEqualToString:WMDepositID]){
        
        NSString *payMsg = [[_paymemtDict dictionaryForKey:@"order"] sea_stringForKey:@"pay_status"];
        
        NSInteger statusType;
        
        if ([payMsg isEqualToString:@"1"] || [payMsg isEqualToString:@"3"]) {
            
            statusType = DoPayCallBackTypeSuccess;
        }
        else{
            
            statusType = DoPayCallBackTypeFail;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(statusType),@"msg":payMsg}];
        
    }
    else if ([_payAppID isEqualToString:WMWxPayID]){
        
        WeChatPayViewModel *viewModel = [WeChatPayViewModel createModelWithResModel:_paymemtDict];
        
        WeiCharPayClient *weChatPayClient = [[WeiCharPayClient alloc] initPayWithModel:viewModel];
        
        [weChatPayClient usingWeChatPayToPayOrder];
    }
}

- (void)checkResultWithStatusType:(NSNumber *)type errorMsg:(NSString *)msg isCombinationPay:(BOOL)isCombinationPay needPresent:(BOOL)needPresent{

    NSInteger index = 0;
    
    self.needPresent = needPresent;
    
    if (type.integerValue == DoPayCallBackTypeSuccess) {
        
        [self performSelector:@selector(alertOrderMsg:) withObject:@{@"msg":@"支付成功"} afterDelay:0.8];
        
        index = 2;
        
    }
    else if (type.integerValue == DoPayCallBackTypeCancel){
        
        index = isCombinationPay ? 0 : 1;
    }
    else if (type.integerValue == DoPayCallBackTypeFail){
        
        index = isCombinationPay ? 0 : 1;
        
        if (!msg) {
            
            msg = @"支付失败";
        }
    }
}

- (void)alertOrderMsg:(NSDictionary *)dict{
    
    [[AppDelegate instance] alertMsg:[dict sea_stringForKey:@"msg"]];
}








@end
