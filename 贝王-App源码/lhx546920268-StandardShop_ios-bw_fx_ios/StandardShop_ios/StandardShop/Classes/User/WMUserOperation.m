//
//  WMUserOperation.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMUserOperation.h"
#import "WMUserInfo.h"
#import "WMsettingInfo.h"
#import "WMInputInfo.h"
#import "WMAccountSecurityInfo.h"
//#import "WMHelpCenterInfo.h"
#import "WMSocialLoginOperation.h"
#import "WMLoginPageInfo.h"

@implementation WMUserOperation

#pragma mark- 登录注册

/**获取登录所需信息 参数
 */
+ (NSDictionary*)loginNeedParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.login", WMHttpMethod, nil];
}

/**获取登录所需信息 结果
 *@return 如果需要，则返回登录页面信息，否则返回nil
 */
+ (WMLoginPageInfo*)loginNeedResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [WMLoginPageInfo infoFromDictionary:dataDic];
    }

    return nil;
}

/**登录 参数
 *@param account 账号
 *@param password 密码
 *@param code 图形验证码
 */
+ (NSDictionary*)loginParamWithAccout:(NSString*) account password:(NSString*) password code:(NSString*) code
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.post_login", WMHttpMethod, account, @"uname", password, @"password", code, @"verifycode", nil];
}

/**登录 结果
 *@param flag 是否提示登录失败的信息
 *@param errorMsg 错误信息
 *@param codeURL 如果需要验证码，则传对应的值
 *@return 登录结果
 */
+ (WMLoginResult)loginResultFromData:(NSData*)data alertFailMsg:(BOOL) flag errorMsg:(NSString**) errorMsg codeURL:(NSString**) codeURL
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        [WMUserInfo sharedUserInfo].isSocailLogin = NO;
        [WMUserInfo infoFromDictionary:dataDic isLoginUser:YES];
        return WMLoginResultSuccess;
    }
    else
    {
        NSString *errMsg = [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:flag];
        if(errorMsg != nil)
        {
            *errorMsg = errMsg;
        }

        ///判断是否需要验证码
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        BOOL needCode = [[dataDic numberForKey:@"needVcode"] boolValue];
        if(needCode)
        {
            if(codeURL != nil)
            {
                *codeURL = [dataDic sea_stringForKey:@"code_url"];
            }

            return WMLoginResultNeedVerifyCode;
        }
    }
    
    return WMLoginResultOther;
}

/**社交账号登录 参数
 *@param user 授权用户
 */
+ (NSDictionary*)socialLoginWithUser:(WMSocialUser*) user
{
    NSString *provider_code = @"";
    switch (user.platformType)
    {
        case WMPlatformTypeQQ :
        {
            provider_code = @"qq";
        }
            break;
        case WMPlatformTypeWeixin :
        {
            provider_code = @"weixin";
        }
            break;
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:provider_code forKey:@"provider_code"];
    [dic setObject:@"b2c.passport.trust_login" forKey:WMHttpMethod];
    
    if(user.uid)
    {
        [dic setObject:user.uid forKey:@"openid"];
        [dic setObject:user.nickname forKey:@"nickname"];
        
        switch (user.platformType)
        {
            case WMPlatformTypeWeixin :
            {
                if(user.unionid)
                {
                    [dic setObject:user.unionid forKey:@"unionid"];
                }
            }
                break;
                
            default:
                break;
        }
        
        if(user.sex)
        {
            [dic setObject:user.sex forKey:@"gender"];
        }
    }
    
    return dic;
}

/**社交账号登录 结果
 *@param flag 是否提示登录失败的信息
 *@return 是否登录成功
 */
+ (WMLoginResult)socialLoginResultFromData:(NSData*) data alertFailMsg:(BOOL) flag
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSLog(@"%@", dic);
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        NSString *userId = [dataDic sea_stringForKey:WMUserInfoId];
        
        if(userId)
        {
            [WMUserInfo sharedUserInfo].isSocailLogin = YES;
            [WMUserInfo infoFromDictionary:dataDic isLoginUser:YES];
            return WMLoginResultSuccess;
        }
        else
        {
            return WMLoginResultNeedAssociateAccount;
        }
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:flag];
    }
    
    return WMLoginResultOther;
}

/**社交账号登录关联账号所需信息 参数
 */
+ (NSDictionary*)socialoginAssociateAccountNeedsParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"trustlogin.trustlogin.bind_login", WMHttpMethod, nil];
}

/**社交账号登录关联账号所需信息 结果
 *@return 图形验证码
 */
+ (NSString*)socialoginAssociateAccountNeedsFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        if([[dataDic sea_stringForKey:@"show_varycode"] boolValue])
        {
            return [dataDic sea_stringForKey:@"code_url"];
        }
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**社交账号登录关联账号 参数
 *@param account 账号
 *@param password 密码
 *@param code 短信验证码
 *@param user 授权用户
 *@param flag 是否是关联已注册账号
 */
+ (NSDictionary*)socialoginAssociateAccount:(NSString*) account password:(NSString*) password code:(NSString*) code SSDKUser:(WMSocialUser *)user exist:(BOOL) flag
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(flag)
    {
        [dic setObject:@"trustlogin.trustlogin.check_login" forKey:WMHttpMethod];
        [dic setObject:account forKey:@"uname"];
        [dic setObject:password forKey:@"password"];
    }
    else
    {
        [dic setObject:@"trustlogin.trustlogin.set_login" forKey:WMHttpMethod];
        [dic setObject:password forKey:@"pam_account[psw_confirm]"];
        [dic setObject:password forKey:@"pam_account[login_password]"];
        [dic setObject:account forKey:@"pam_account[login_name]"];
    }
    
    [dic setObject:code forKey:@"vcode"];
    
    //平台代码
    NSString *provider_code = @"";
    switch (user.platformType)
    {
        case WMPlatformTypeQQ :
        {
            provider_code = @"trustlogin_plugin_qq";
        }
            break;
        case WMPlatformTypeWeixin :
        {
            provider_code = @"trustlogin_plugin_weixin";
        }
            break;
        default:
            break;
    }
    
    [dic setObject:provider_code forKey:@"data[trust_source]"];
    
    if(user.uid)
    {
        [dic setObject:user.uid forKey:@"data[openid]"];
        
        if(user.nickname)
        {
            [dic setObject:user.nickname forKey:@"data[nickname]"];
        }
        
        if(user.icon)
        {
            [dic setObject:user.icon forKey:@"data[avatar]"];
        }
        
        if(user.sex)
        {
            [dic setObject:user.sex forKey:@"data[gender]"];
        }
        
        if(user.unionid)
        {
            [dic setObject:user.unionid forKey:@"data[unionid]"];
        }
    }
    
    return dic;
}

/**社交账号登录关联账号 结果
 *@return 是否关联成功
 */
+ (BOOL)socialoginAssociateAccountFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        [WMUserInfo infoFromDictionary:dataDic isLoginUser:YES];
        
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取注册所需信息 参数
 */
+ (NSDictionary*)registerInfosParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.signup", WMHttpMethod, nil];
}

/**获取注册所需信息 结果
 *@return 数组元素是 WMRegisterInfo
 */
+ (NSArray*)registerInfosFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        return [WMInputInfo inputInfosFromDictionary:dataDic];
    }

    return nil;
}

/**检测账号是否存在 参数
 *@param account 账号
 */
+ (NSDictionary*)detectAccountExist:(NSString*) account
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.signup_ajax_check_name", WMHttpMethod, @"trustlogin", @"type", account, @"pam_account[login_name]", nil];
}

/**检测账号是否存在 结果
 *@return 存在则返回nil，否则返回提示信息
 */
+ (NSString*)detectAccountExistResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {

    }
    else
    {
        return [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**注册 参数
 *@param phoneNumber 手机号码
 *@param code 短信验证码
 *@param password 密码
 */
+ (NSDictionary*)registerParamsWithPhoneNumber:(NSString*) phoneNumber code:(NSString*) code password:(NSString*) password
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.create", WMHttpMethod, @"on", @"license", @"ios", @"source", nil];

    [dic setObject:password forKey:@"pam_account[psw_confirm]"];
    [dic setObject:phoneNumber forKey:@"pam_account[login_name]"];
    [dic setObject:password forKey:@"pam_account[login_password]"];
    [dic setObject:code forKey:@"vcode"];

    return dic;
}

/**注册结果
 *@return 是否成功
 */
+ (BOOL)registerResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**注销 参数
 */
+ (NSDictionary*)logoutParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.logout", WMHttpMethod, nil];
}

/**注销结果
 *@return 是否退出成功
 */
+ (BOOL)logoutResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark- 个人信息

/**获取个人信息 参数
 *@param userId 用户Id
 */
+ (NSDictionary*)userInfoParams
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:@"b2c.member.index" forKey:WMHttpMethod];

    return dic;
}

/**从返回的数据中获取个人信息
 */
+ (WMUserInfo*)userInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        return [WMUserInfo infoFromDictionary:dataDic isLoginUser:YES];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }
    
    return nil;
}

/**会员等级说明 参数
 */
+ (NSDictionary*)userLevelInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.lv_explain", WMHttpMethod, nil];
}

/**会员等级说明 结果
 *@return html字符串
 */
+ (NSString*)userLevelInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        NSString *html = [dataDic sea_stringForKey:@"explain"];
        return [NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], html];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

/**账户安全信息 参数
 */
+ (NSDictionary*)accountSecurityParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.security", WMHttpMethod, nil];
}

/**账户安全信息 结果
 *@return 账户安全信息 会保存在
 */
+ (WMAccountSecurityInfo*)accountSecurityInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    if([WMUserOperation resultFromDictionary:dic])
    {
        WMAccountSecurityInfo *info = [WMAccountSecurityInfo infoFromDictionary:[dic dictionaryForKey:WMHttpData]];
        [WMUserInfo sharedUserInfo].accountSecurityInfo = info;
        
        return info;
    }
    
    return nil;
}

#pragma mark- 修改个人资料

/**上传图片，参数
 */
+ (NSDictionary*)uploadImageParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.save_setting", WMHttpMethod, nil];
}

/**上传图片结果
 *@return 图片路径
 */
+ (NSString*)uploadImageResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        return [dataDic sea_stringForKey:@"image_src"];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}

/**修改个人资料 参数
 *@param dic value 修改的内容, key 修改的字段
 */
+ (NSDictionary*)modifyUserInfoParamWithDictionary:(NSDictionary*) dic
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:dic];
    [param setObject:@"b2c.member.save_setting" forKey:WMHttpMethod];
    
    return param;
}

/**修改个人资料结果
 *@return 是否修改成功
 */
+ (BOOL)modifyUserInfoResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**设置用户名 参数
 *@param username 用户名
 */
+ (NSDictionary*)setupUsernameParams:(NSString*) username
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.save_local_uname", WMHttpMethod, username, @"local_name", nil];
}

/**设置用户名 结果
 *@return 是否成功
 */
+ (BOOL)setupUsernameResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**修改密码 参数
 *@param org 原密码
 *@param news 新密码
 */
+ (NSDictionary*)modifyPasswdParamWithOrg:(NSString*) org news:(NSString*) news
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.setting.saveSecurity", WMHttpMethod, org, @"old_passwd", news, @"passwd", nil];
}

/**修改密码结果
 *@return 是否修改成功
 */
+ (BOOL)modifyPasswdFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    if([result isEqualToString:WMHttpSuccess])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**重置登陆密码 参数
 *@param code 短信验证码
 */
+(NSDictionary *)resetLogInPassWordWithPhone:(NSString *)phone newPassWord:(NSString *)newPassWord code:(NSString*) code
{
    return @{@"psw_confirm":newPassWord,@"account":phone,@"login_password":newPassWord,WMHttpMethod:@"b2c.passport.resetpassword", @"key":code};
}

/**重置登陆密码 结果
 */
+ (BOOL)resetLogInPassWordResultWithData:(NSData *)data{
    
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if ([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
    
}

/**重置登录密码 获取所需信息 参数
 */
+ (NSDictionary*)resetLoginPasswordNeedParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.sendPSW", WMHttpMethod, nil];
}

/**重置登录密码 获取所需信息 结果
 *@return 如果需要，则返回验证码链接，否则返回nil，key为code
 *@return 客服电话，key为phone
 */
+ (NSDictionary*)resetLoginPasswordNeedResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        NSString *code;
        
        if([[dataDic numberForKey:@"site_sms_valide"] boolValue])
        {
            code = [dataDic sea_stringForKey:@"code_url"];
        }
        else{
            
            code = @"";
        }
        
        NSString *phone = [dataDic sea_stringForKey:@"tel"];
        
        return @{@"phone":[NSString isEmpty:phone] ? @"" : phone,@"code":code};
    }

    return nil;
}

/**获取手机验证码 参数
 *@param phoneNumber 手机号
 *@param type 类型 通过宏 WMUserInterface.h头文件中
 *@param code 验证码
 */
+ (NSDictionary*)getPhoneCodeParamWithPhoneNumber:(NSString*) phoneNumber type:(NSString*) type code:(NSString*) code
{
    if ([NSString isEmpty:code]) {
        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.send_vcode_sms", WMHttpMethod, phoneNumber, @"uname", type, @"type", nil];
    }
    else{
        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.send_vcode_sms", WMHttpMethod, phoneNumber, @"uname", type, @"type", code, @"sms_vcode", nil];
    }
}

/**获取手机验证码结果
 *@return 是否获取成功
 */
+ (BOOL)getPhoneCodeResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**获取已发送的短信验证码 参数
 *@param phoneNumber 手机号
 *@param type 类型 通过宏 WMUserInterface.h头文件中
 */
+ (NSDictionary*)getSendedCodeParamWithPhoneNumber:(NSString*) phoneNumber type:(NSString*) type
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.get_vcode", WMHttpMethod, phoneNumber, @"uname", type, @"type", nil];
}

/**获取已发送的短信验证码 结果
 *@return 短信验证码
 */
+ (NSString*)getSendedCodeFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return [[dic dictionaryForKey:WMHttpData] sea_stringForKey:@"vcode"];
    }
    
    return nil;
}

/**绑定手机号界面所需信息 参数
 */
+ (NSDictionary*)changeBindPhoneNeedsParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.verify", WMHttpMethod, @"verifymobile", @"verifyType", nil];
}

/**绑定手机号界面所需信息 结果
 *@return 图形验证码链接，返回nil则不需要
 */
+ (NSString*)changeBindPhoneNeedsFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        if([[dataDic sea_stringForKey:@"show_varycode"] boolValue])
        {
            return [dataDic sea_stringForKey:@"code_url"];
        }
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return nil;
}


/**更改绑定手机号码 参数
 *@param phone 手机号码
 *@param code 短信验证码
 */
+ (NSDictionary *)changeBindPhoneParam:(NSString *) phone vcode:(NSString *)code
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"b2c.member.verify_vcode2", WMHttpMethod, phone, @"uname", code, @"vcode", @"reset", @"send_type", nil];
    
    return dic;
}

/**更改绑定手机号码 结果
 */
+ (BOOL)changeBindPhoneResult:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }
    
    return NO;
}

/**验证手机验证码是否正确 参数
 *@param code 验证码
 *@param phoneNumber 手机号码
 */
+ (NSDictionary*)verifyPhoneCodeParam:(NSString*) code phoneNumber:(NSString*) phoneNumber
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.resetpwd_code", WMHttpMethod, @"mobile", @"send_type", code, @"mobilevcode", phoneNumber, @"mobile", nil];
}

/**验证手机验证码是否正确 结果
 *@return 是否正确
 */
+ (BOOL)verifyPhoneCodeResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return YES;
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:YES];
    }

    return NO;
}

/**获取可编辑的个人信息 参数
 */
+ (NSDictionary*)editableUserInfoParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.member.setting", WMHttpMethod, nil];
}

/**获取可编辑的个人信息 结果
 *@return 数组元素是 WMSettingInfo
 */
+ (NSArray*)editableUserInfoFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        return [WMSettingInfo myInfosFromDictionary:dic];
    }
    else
    {
        [WMUserOperation errorMsgFromDictionary:dic alertErrorMsg:NO];
    }

    return nil;
}

#pragma mark- 文章

/**获取用户协议
 */
+ (NSDictionary*)userProtocolParam
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.license", WMHttpMethod, nil];
}

/**获取用户协议结果
 *@return html用户协议内容
 */
+ (NSString*)userProtocolResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];
        
        return [dataDic sea_stringForKey:@"reg_license"];
    }
    
    return nil;
}

/**隐私保护政策 参数
 */
+ (NSDictionary*)privacyPolicyParams
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.privacy", WMHttpMethod, nil];
}

/**隐私保护政策 结果
 *@return html 隐私政策
 */
+ (NSString*)privacyPolicyFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];

    if([WMUserOperation resultFromDictionary:dic])
    {
        NSDictionary *dataDic = [dic dictionaryForKey:WMHttpData];

        return [dataDic sea_stringForKey:@"reg_privacy"];
    }

    return nil;
}

#pragma mark- 其他

/**意见反馈 参数
 *@param content 反馈内容
 *@param contact 联系方式
 */
+ (NSDictionary*)feedbackParamWithContent:(NSString*) content contact:(NSString*) contact
{
    if(contact == nil)
        contact = @"";
    return [NSDictionary dictionaryWithObjectsAndKeys:@"mobileapi.member.send_msg", WMHttpMethod, content, @"comment", contact, @"contact", @"反馈内容", @"subject", nil];
}

/**意见反馈结果
 *@return 是否反馈成功
 */
+ (BOOL)feedBackResultFromData:(NSData*) data
{
    NSDictionary *dic = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *result = [dic sea_stringForKey:WMHttpResult];
    
    NSLog(@"%@",dic);
    if([result isEqualToString:WMHttpSuccess])
    {
        return YES;
    }
    else
    {
        [AppDelegate needLoginFromDictionary:dic];
    }
    
    return NO;
}

/**保存设备token 参数
 *@param token
 */
+ (NSDictionary*)saveTokenParam:(NSString*) token
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"b2c.passport.save_token", WMHttpMethod, token, @"token",@"ios",@"tag_type",nil];
}

/**实名认证 参数
 *@param 身份证号码 NSString
 *@param 身份证姓名 NSString
 */
+ (NSDictionary *)commitRealNameWithName:(NSString *)name identityCardID:(NSString *)cardID{
    
    return @{WMHttpMethod:@"mobileapi.setting.updateUserInfo",@"real_name":name,@"card_num":cardID};
}
/**实名认证的结果
 */
+ (BOOL)commitRealNameWithData:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:WMHttpResult];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

/**设置支付密码 参数
 *@param NSString 第一次支付密码
 *@param NSString 第二次支付密码
 */
+ (NSDictionary *)setPayPassWordFirstPay:(NSString *)firstPay comfirmPay:(NSString *)confirmPay phoneCode:(NSString *)code{
    
    return @{WMHttpMethod:@"mobileapi.setting.verifyPayPassword",@"pay_password":firstPay,@"vcode":code,@"verify_type":@"code"};
}

/**更改支付密码 参数
 *@param NSString 旧密码
 *@param NSString 新密码
 */
+ (NSDictionary *)changePayPassWordWith:(NSString *)oldPayPass newPayPass:(NSString *)newPayPass{
    
    return @{WMHttpMethod:@"mobileapi.setting.verifyPayPassword",@"verify_type":@"password",@"pay_password":newPayPass,@"old_pay_password":oldPayPass};
}

/**设置支付密码 结果
 */
+ (BOOL)setPayPassWordResult:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:WMHttpResult];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}



/**核实旧手机的验证码 参数
 *@param NSString 验证码
 *@param NSString 旧手机号码
 */
+ (NSDictionary *)verifyOldPhoneWithPhone:(NSString *)phone codeStr:(NSString *)codeStr{
    
    return @{WMHttpMethod:@"mobileapi.setting.verifyCode",@"vcode":codeStr,@"anumber":phone
             };
}
/**核实旧手机的验证码 结果
 */
+ (BOOL)returnVerifyOldPhoneResultWith:(NSData *)data{
    
    NSDictionary *dict = [NSJSONSerialization JSONDictionaryWithData:data];
    
    NSString *rspStr = [dict sea_stringForKey:WMHttpResult];
    
    if ([rspStr isEqualToString:WMHttpSuccess]) {
        
        return YES;
    }
    else{
        
        [WMUserOperation errorMsgFromDictionary:dict alertErrorMsg:YES];
    }
    
    return NO;
}

#pragma mark- other

/**接口请求失败处理
 *@param dic 原始的josn 最外层的字典
 *@param flag 是否提示错误信息
 *@return 错误信息，没有则返回nil
 */
+ (NSString*)errorMsgFromDictionary:(NSDictionary*) dic alertErrorMsg:(BOOL) flag
{
    NSString *errMsg = nil;
    if(![AppDelegate needLoginFromDictionary:dic])
    {
        errMsg = [dic sea_stringForKey:WMHttpMessage];
        if([NSString isEmpty:errMsg])
        {
            errMsg = [dic sea_stringForKey:WMHttpData];
        }

        if(flag && errMsg)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }

    return errMsg;
}

/**获取列表的总数，
 *@param dic 包含有pager 字段的字典，一般是放在data 里面的
 *@return 列表总数
 */
+ (long long)totalSizeFromDictionary:(NSDictionary*) dic
{
    NSDictionary *pageDic = [dic dictionaryForKey:@"pager"];
    return [[pageDic numberForKey:@"dataCount"] longLongValue];
}

/**获取接口响应结果
 *@param dic 包含接口响应结果的字典
 *@return 是否成功
 */
+ (BOOL)resultFromDictionary:(NSDictionary*) dic
{
    NSString *result = [dic sea_stringForKey:WMHtppErrorCode];
    return [result isEqualToString:WMHttpSuccess];
}

@end
