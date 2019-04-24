//
//  WeiCharPayClient.m
//  WuMei
//
//  Created by qsit on 15/7/31.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WeiCharPayClient.h"
#import "payRequsestHandler.h"
#import "WeChatPayViewModel.h"

@interface WeiCharPayClient ()

@property (strong,nonatomic) WeChatPayViewModel *weChatViewModel;

@end

@implementation WeiCharPayClient

- (instancetype)initPayWithModel:(WeChatPayViewModel *)resModel{
    
    self = [super init];
    
    if (self) {
        
        _weChatViewModel = resModel;
    }
    
    return self;
}

- (void)usingWeChatPayToPayOrder{
    
//        //创建支付签名对象
//        payRequsestHandler *req = [payRequsestHandler alloc];
//        //初始化支付签名对象
//        [req init:_weChatViewModel.weChatPayAppId mch_id:_weChatViewModel.weChatPayPartnerId];
//        //设置密钥
//        [req setKey:_weChatViewModel.weChatPayPartnerKey];
//    
//        //获取到实际调起微信支付的参数后，在app端调起支付
//        NSMutableDictionary *dict = [req sendPayWithModel:_weChatViewModel];
//    
//        if(dict == nil){
//            //错误提示
//            NSString *debug = [req getDebugifo];
//    
//            NSLog(@"错误提示debug %@",debug);
//    
//            NSLog(@"%@\n\n",debug);
//        }else{
//            NSLog(@"%@\n\n",[req getDebugifo]);
//    
//            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//    
//            //调起微信支付
//            PayReq* req             = [[PayReq alloc] init];
//            req.openID              = [dict objectForKey:@"appid"];
//            req.partnerId           = [dict objectForKey:@"partnerid"];
//            req.prepayId            = [dict objectForKey:@"prepayid"];
//            req.nonceStr            = [dict objectForKey:@"noncestr"];
//            req.timeStamp           = stamp.intValue;
//            req.package             = [dict objectForKey:@"package"];
//            req.sign                = [dict objectForKey:@"sign"];
//    
//            [WXApi sendReq:req];
//        }
    /*    req.openID = @"wx20f8041f3bb7ee2e";
     req.partnerId = @"1310272601";
     req.prepayId = @"wx20160125143713f6cc80c2f90489631686";
     req.nonceStr = @"9cx2P2Siz59u";
     req.timeStamp = 1453702073;
     req.package = @"Sign=WXPay";
     req.sign = @"81A05D8A55B12BFA16045CF1E9DBE42A";
     */
    
    PayReq *req = [[PayReq alloc] init];
    req.openID = _weChatViewModel.weChatRealPayID;
    req.partnerId = _weChatViewModel.weChatRealPayPartnerId;
    req.prepayId = _weChatViewModel.weChatRealPayPrepayId;
    req.nonceStr = _weChatViewModel.weChatRealPayNoncestr;
    req.timeStamp = [_weChatViewModel.weChatRealPayTime intValue];
    req.package = _weChatViewModel.weChatRealPayPack;
    req.sign = _weChatViewModel.weChatRealPaySign;
    [WXApi sendReq:req];

}

#pragma 微信支付回调
-(void) onResp:(BaseResp*)resp
{
    NSInteger statusType;
    
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:{
                statusType = DoPayCallBackTypeSuccess;
                
            }
                break;
                
            default:
            {
                statusType = DoPayCallBackTypeFail;
            }
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OrderDoPayCallBackResultNotification object:nil userInfo:@{OrderDoPayStatusKey:@(statusType)}];
    }
}

- (void)checkResultWithStatusType:(NSNumber *)type{
    
    NSInteger index = 0;
    
    if (type.integerValue == DoPayCallBackTypeSuccess) {
        
        index = 2;
        
        [self performSelector:@selector(alertOrderMsg:) withObject:@{@"msg":@"支付成功"} afterDelay:0.8];
        

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
