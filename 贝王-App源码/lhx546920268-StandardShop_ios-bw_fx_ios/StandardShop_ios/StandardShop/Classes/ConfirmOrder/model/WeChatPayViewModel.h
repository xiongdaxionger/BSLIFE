//
//  WeChatPayViewModel.h
//  WuMei
//
//  Created by qsit on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatPayViewModel : NSObject
@property (copy,nonatomic) NSString *weChatPayAppSign;
@property (copy,nonatomic) NSString *weChatPayPartnerId;
@property (copy,nonatomic) NSString *weChatPayAppId;
@property (copy,nonatomic) NSString *weChatPayAppName;
@property (copy,nonatomic) NSString *weChatPayBody;
@property (copy,nonatomic) NSString *weChatPayNonceStr;
@property (copy,nonatomic) NSString *weChatPayOrderId;
@property (copy,nonatomic) NSString *weChatPayPackage;
@property (copy,nonatomic) NSString *weChatPayName;
@property (strong,nonatomic) NSString *weChatPayTimeStamp;
@property (copy,nonatomic) NSString *weChatPayTotalAmount;
@property (copy,nonatomic) NSString *weChatPaymentId;
@property (copy,nonatomic) NSString *weChatPayIP;
@property (copy,nonatomic) NSString *weChatPayCallBackURL;
@property (copy,nonatomic) NSString *weChatPayPartnerKey;

@property (copy,nonatomic) NSString *weChatRealPayID;
@property (copy,nonatomic) NSString *weChatRealPayNoncestr;
@property (copy,nonatomic) NSString *weChatRealPayPack;
@property (copy,nonatomic) NSString *weChatRealPayPartnerId;
@property (copy,nonatomic) NSString *weChatRealPayPrepayId;
@property (copy,nonatomic) NSString *weChatRealPaySign;
@property (copy,nonatomic) NSString *weChatRealPayTime;

/**初始化
 */
+ (instancetype)createModelWithResModel:(NSDictionary *)model;
@end
