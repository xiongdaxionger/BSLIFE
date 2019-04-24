//
//  WeChatPayViewModel.m
//  WuMei
//
//  Created by qsit on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WeChatPayViewModel.h"

@implementation WeChatPayViewModel
+ (instancetype)createModelWithResModel:(NSDictionary *)model{
    
    WeChatPayViewModel *viewModel = [[WeChatPayViewModel alloc] init];
    viewModel.weChatPayAppId = [model sea_stringForKey:@"appid"];
    viewModel.weChatPayAppName = [model sea_stringForKey:@"appname"];
    viewModel.weChatPayBody = [model sea_stringForKey:@"body"];
    viewModel.weChatPayName = [model sea_stringForKey:@"pay_name"];
    NSDictionary *package = [model dictionaryForKey:@"package"];
    viewModel.weChatPayCallBackURL = [package sea_stringForKey:@"notify_url"];
    viewModel.weChatPayNonceStr = [model sea_stringForKey:@"noncestr"];
    viewModel.weChatPayOrderId = [model sea_stringForKey:@"order_id"];
    
    viewModel.weChatPayPartnerId = [model sea_stringForKey:@"partnerid"];
    viewModel.weChatPayAppSign = [model sea_stringForKey:@"app_signature"];
    viewModel.weChatPayTimeStamp = [NSString stringWithFormat:@"%@",[model numberForKey:@"timestamp"]];
    viewModel.weChatPayPackage = @"Sign=WXPay";
    viewModel.weChatPayIP = [model sea_stringForKey:@"ip"];
    NSString *money = [NSString stringWithFormat:@"%.2f",[[model sea_stringForKey:@"total_amount"] doubleValue]];
    
    viewModel.weChatPayTotalAmount = [NSString stringWithFormat:@"%.0f",(money.doubleValue * 100)];
    
    viewModel.weChatPaymentId = [model sea_stringForKey:@"payment_id"];
    
    viewModel.weChatPayPartnerKey = [model sea_stringForKey:@"partnerKey"];
    
    NSDictionary *returnDict = [model dictionaryForKey:@"return"];
    
    viewModel.weChatRealPayID = [returnDict sea_stringForKey:@"appid"];
    viewModel.weChatRealPayNoncestr = [returnDict sea_stringForKey:@"noncestr"];
    viewModel.weChatRealPayPack = [returnDict sea_stringForKey:@"package"];
    viewModel.weChatRealPayPartnerId = [returnDict sea_stringForKey:@"partnerid"];
    viewModel.weChatRealPayPrepayId = [returnDict sea_stringForKey:@"prepayid"];
    viewModel.weChatRealPayTime = [returnDict sea_stringForKey:@"timestamp"];
    viewModel.weChatRealPaySign = [returnDict sea_stringForKey:@"sign"];
    
    return viewModel;
}
@end
