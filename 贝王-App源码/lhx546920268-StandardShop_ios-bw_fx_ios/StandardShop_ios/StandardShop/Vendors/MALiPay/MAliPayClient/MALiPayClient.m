//
//  MALiPayClient.m
//  WuMei
//
//  Created by qsit on 15/7/29.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "MALiPayClient.h"
#import "Order.h"
#import "WMDoPayInfoModel.h"

@interface MALiPayClient ()

@property (strong,nonatomic) WMDoPayInfoModel *resModel;

@end

@implementation MALiPayClient

- (instancetype)initPayWithModel:(WMDoPayInfoModel *)resModel{
    self = [super init];
    if (self) {
        
        _resModel = resModel;
    }
    return self;
}
- (void)usingMAiLiPayToPayOrder{
    
    Order *order = [[Order alloc] init];
    order.partner = _resModel.mer_id;
    order.seller = _resModel.seller_account_name;
    order.tradeNO = _resModel.payment_id;
    order.productName = _resModel.body;
    order.productDescription = _resModel.body;
    order.amount = [NSString stringWithFormat:@"%.2f",_resModel.total_amount.doubleValue];
    
    order.notifyURL =  _resModel.callback_url;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"beiwang";
    
//    NSString *orderSpec = [order description];
    
//    id<DataSigner> signer = CreateRSADataSigner(_resModel.key);
//    NSString *signedString = [signer signString:orderSpec];
    
//    NSString *orderString = nil;
    if (_resModel.payStr != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
    
        [[AlipaySDK defaultService] payOrder:_resModel.payStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            [self checkResultDict:resultDic];
        }];
    }
    else{
        
        [[AppDelegate instance] alertMsg:@"参数错误，请重试"];
    }
}
- (void)checkResultDict:(NSDictionary *)dict{
    
    NSString *resultStatus = dict[MALiPayResultKey];
    
    NSInteger statusType = DoPayCallBackTypeUnkonw;
    
    if ([resultStatus isEqualToString:MALiPaySuccess]) {
        
        statusType = DoPayCallBackTypeSuccess;
    }
    else if ([resultStatus isEqualToString:MALiPayFail]){
        
        statusType = DoPayCallBackTypeFail;
    }
    else if ([resultStatus isEqualToString:MALiPayCancel]){
        
        statusType = DoPayCallBackTypeCancel;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(statusType)}];
}

- (void)checkResultWithStatusType:(NSNumber *)type{
    
    NSInteger index = 0;

    if (type.integerValue == DoPayCallBackTypeSuccess) {
        
        [self performSelector:@selector(alertOrderMsg:) withObject:@{@"msg":@"支付成功"} afterDelay:0.8];
        
        index = 2;
    }
    else if (type.integerValue == DoPayCallBackTypeCancel){
    
        index = 1;
        
        [self performSelector:@selector(alertOrderMsg:) withObject:@{@"msg":@"支付取消"} afterDelay:0.8];
        
    }
    else if (type.integerValue == DoPayCallBackTypeFail){
            
        index = 1;
        
        [self performSelector:@selector(alertOrderMsg:) withObject:@{@"msg":@"支付失败"} afterDelay:0.8];
        
    }
}


- (void)alertOrderMsg:(NSDictionary *)dict{
    
    [[AppDelegate instance] alertMsg:[dict sea_stringForKey:@"msg"]];
}
@end
