//
//  WMPassWordOperation.m
//  WanShoes
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPassWordOperation.h"
#import "WMUserOperation.h"

@implementation WMPassWordOperation
/**验证登陆密码 参数
 *@param 验证类型 verifyType
 *@param 验证码 code
 *@param 登陆密码 logInPassWord
 */
+ (NSDictionary *)returnVerifyLogInPassWordWithType:(NSString *)verifyType code:(NSString *)code logInPassWord:(NSString *)logInPassWord{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.member.verify_vcode" forKey:WMHttpMethod];
    
    [param setObject:verifyType forKey:@"verifyType"];
    
    [param setObject:logInPassWord forKey:@"password"];
    
    if (code) {
        
        [param setObject:code forKey:@"verifycode"];
    }
    
    return param;
}
/**验证登陆密码 结果
 */
+ (id)returnVerifyLogInPassWordResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return @(YES);
    }
    else{
        
        NSDictionary *codeDict = [dict dictionaryForKey:WMHttpData];
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
        
        if (codeDict) {
            
            return [codeDict sea_stringForKey:@"code_url"];
        }
        else{
            
            return @(NO);
        }
    }
}

/**设置支付密码 参数
 *@param 验证类型 verifyType
 *@param 验证码 code
 *@param 登陆密码 logInPassWord
 *@param 第一次的支付密码 firstPayPass
 *@param 第二次的支付密码 secondPayPass
 */
+ (NSDictionary *)returnSetPayPassWordWithType:(NSString *)type code:(NSString *)code logInPassWord:(NSString *)logInPassWord firstPayPass:(NSString *)firstPayPass secondPayPass:(NSString *)secondPayPass{
    
    if ([NSString isEmpty:code]) {
        
        return @{WMHttpMethod:@"b2c.member.verify_vcode2",@"password":logInPassWord,@"pay_password":firstPayPass,@"re_pay_password":secondPayPass,@"verifyType":type}; 
    }
    
    return @{WMHttpMethod:@"b2c.member.verify_vcode2",@"password":logInPassWord,@"pay_password":firstPayPass,@"re_pay_password":secondPayPass,@"verifyType":type,@"verifycode":code};
}
/**设置支付密码 结果
 */
+ (BOOL)returnSetPayPassWordReusltWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**修改支付密码/忘记支付密码 参数
 *@param 手机号码 phone--当用户绑定手机时通过手机验证修改支付密码
 *@param 手机验证码 phoneCode
 *@param 图形验证码 imageCode--用户没绑定手机使用登录密码修改支付密码，登录密码错误三次需要图形验证
 *@param 首次输入的支付密码 firstPayPass
 *@param 再次输入的支付密码 secPayPass
 *@param 登录密码 logInPass
 */
+ (NSDictionary *)returnVerifyPayPassWordWithPhone:(NSString *)phone phoneCode:(NSString *)phoneCode imageCode:(NSString *)imageCode firstPayPass:(NSString *)firstPayPass secPayPass:(NSString *)secPayPass logInPass:(NSString *)logInPass{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    [param setObject:@"b2c.member.verify_vcode2" forKey:WMHttpMethod];
    
    if (![NSString isEmpty:phone]) {
        
        [param setObject:phone forKey:@"mobile"];
        
        [param setObject:phoneCode forKey:@"vcode[mobile]"];
        
        [param setObject:@"mobile" forKey:@"send_type"];
    }
    else{
        
        [param setObject:logInPass forKey:@"password"];
        
        if (![NSString isEmpty:imageCode]) {
            
            [param setObject:imageCode forKey:@"verifycode"];
        }
    }
    
    [param setObject:@"verifypaypassword" forKey:@"verifyType"];
    
    [param setObject:firstPayPass forKey:@"pay_password"];
    
    [param setObject:secPayPass forKey:@"re_pay_password"];
    
    return param;
}
/**修改支付密码/忘记支付密码 结果
 */
+ (id)returnVerifyPayPassWordResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return @(YES);
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
        
        NSDictionary *dataDict = [dict dictionaryForKey:WMHttpData];
        
        if (dataDict) {
            
            return dataDict;
        }
        else{
            
            return @(NO);
        }
    }
}

/**修改支付密码/忘记支付密码判断用户是否绑定手机 参数
 */
+ (NSDictionary *)returnGetUserIsBindingPhoneWithType:(NSString *)type{
    
    return @{WMHttpMethod:@"b2c.member.verify",@"verifyType":type};
}
/**修改支付密码/忘记支付密码判断用户是否绑定手机 结果
 */
+ (NSDictionary *)returnGetUserIsBindingPhoneResultWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dict]) {
        
        return [dict dictionaryForKey:WMHttpData];
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return nil;
}

/**修改密码 参数
 *@param org 原密码
 *@param news 新密码
 *@param confirm 确认密码
 */
+ (NSDictionary*)modifyPasswdParamWithOrg:(NSString*) org news:(NSString*) news confirm:(NSString*) confirm
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.save_security", WMHttpMethod, org, @"old_passwd", news, @"passwd", confirm, @"passwd_re", nil];
}
/**修改密码 结果
 */
+ (BOOL)returnModifyPassWordReslutWithData:(NSData *)data{
    
    NSDictionary *infoDict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:infoDict]) {
        
        return YES;
    }
    
    [WMUserOperation errorMsgFromDictionary:infoDict alertErrorMsg:YES];
    
    return NO;
}
@end
