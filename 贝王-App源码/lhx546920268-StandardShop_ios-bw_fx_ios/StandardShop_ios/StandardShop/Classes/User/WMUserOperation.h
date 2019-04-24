//
//  WMUserOperation.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

//网络请求标识
#define WMUploadImageIdentifier @"WMUploadImageIdentifier" ///上传头像
#define WMModifyUserInfoIdentifier @"WMModifyUserInfoIdentifier" ///修改个人资料
#define WMEditableUserInfoIdentifier @"WMEditableUserInfoIdentifier" ///获取可编辑的个人资料
#define WMSetupUsernameIdentifier @"WMSetupUsernameIdentifier" ///设置用户名
#define WMGetPhoneCodeIdentifier @"WMGetPhoneCodeIdentifier" ///获取手机验证码
#define WMLogoutIdentifier @"WMLogoutIdentifier" ///退出登录
#define WMGetUserInfoIdentifier @"WMGetUserInfoIdentifier" ///获取个人信息
#define WMLoginIdentifier @"WMLoginIdentifier" ///登录
#define WMLoginNeedIdentifier @"WMLoginNeedIdentifier" ///登录所需信息
#define WMRegisterIdentifier @"WMRegisterIdentifier" ///注册
#define WMDetectAccountExistIdentifier @"WMDetectAccountExistIdentifier" ///账号是否存在检测
#define WMRegisterNeedIdentifier @"WMRegisterNeedIdentifier" ///注册所需信息
#define WMResetLogInPassWordIdentifier @"WMResetLogInPassWordIdentifier" ///重置登陆密码
#define WMResetLoginPasswordNeedIdentifier @"WMResetLoginPasswordNeedIdentifier" ///重置密码所需信息
#define WMSocialLoginIdentifier @"WMSocialLoginIdentifier" ///社交账号登录
#define WMGetShopCarListIdentifier @"WMGetShopCarListIdentifier" ///获取个人购物车数量
#define WMAccountSecurityIdentifier @"WMAccountSecurityIdentifier" ///账户安全信息

#define WMChangeBindPhoneNeedsIdentifier @"WMChangeBindPhoneNeedsIdentifier" ///绑定手机号界面
#define WMChangeBindPhoneIdentifier @"WMChangeBindPhoneIdentifier" ///绑定手机号
#define WMSocialoginAssociateAccountIdentifier @"WMSocialoginAssociateAccountIdentifier" ///第三方登录关联账号
#define WMSocialoginAssociateAccountNeedsIdentifier @"WMSocialoginAssociateAccountNeedsIdentifier" ///第三方登录关联账号所需信息
#define WMGetSendedCodeIdentifier @"WMGetSendedCodeIdentifier" ///获取已发送的短信验证码

@class WMUserInfo,WMAccountSecurityInfo,WMLoginPageInfo;

///登录结果
typedef NS_ENUM(NSInteger, WMLoginResult)
{
    ///登录成功
    WMLoginResultSuccess = 0,
    
    ///需要输入验证码
    WMLoginResultNeedVerifyCode,
    
    ///第三方登录需要关联账号
    WMLoginResultNeedAssociateAccount,
    
    ///其他
    WMLoginResultOther,
};

/**有关用户的网络操作
 */
@interface WMUserOperation : NSObject

#pragma mark- 登录注册

/**获取登录所需信息 参数
 */
+ (NSDictionary*)loginNeedParams;

/**获取登录所需信息 结果
 *@return 如果需要，则返回登录页面信息，否则返回nil
 */
+ (WMLoginPageInfo*)loginNeedResultFromData:(NSData*) data;

/**登录 参数
 *@param account 账号
 *@param password 密码
 *@param code 图形验证码
 */
+ (NSDictionary*)loginParamWithAccout:(NSString*) account password:(NSString*) password code:(NSString*) code;

/**登录 结果
 *@param flag 是否提示登录失败的信息
 *@param errorMsg 错误信息
 *@param codeURL 如果需要验证码，则传对应的值
 *@return 登录结果
 */
+ (WMLoginResult)loginResultFromData:(NSData*)data alertFailMsg:(BOOL) flag errorMsg:(NSString**) errorMsg codeURL:(NSString**) codeURL;

/**社交账号登录 参数
 *@param user 授权用户
 */
+ (NSDictionary*)socialLoginWithUser:(id) user;

/**社交账号登录 结果
 *@param flag 是否提示登录失败的信息
 *@return 是否登录成功
 */
+ (WMLoginResult)socialLoginResultFromData:(NSData*) data alertFailMsg:(BOOL) flag;

/**社交账号登录关联账号所需信息 参数
 */
+ (NSDictionary*)socialoginAssociateAccountNeedsParams;

/**社交账号登录关联账号所需信息 结果
 *@return 图形验证码
 */
+ (NSString*)socialoginAssociateAccountNeedsFromData:(NSData*) data;

/**社交账号登录关联账号 参数
 *@param account 账号
 *@param password 密码
 *@param code 短信验证码
 *@param user 授权用户
 *@param flag 是否是关联已注册账号
 */
+ (NSDictionary*)socialoginAssociateAccount:(NSString*) account password:(NSString*) password code:(NSString*) code SSDKUser:(id)user exist:(BOOL) flag;

/**社交账号登录关联账号 结果
 *@return 是否关联成功
 */
+ (BOOL)socialoginAssociateAccountFromData:(NSData*) data;

/**获取注册所需信息 参数
 */
+ (NSDictionary*)registerInfosParams;

/**获取注册所需信息 结果
 *@return 数组元素是 WMRegisterInfo
 */
+ (NSArray*)registerInfosFromData:(NSData*) data;

/**检测账号是否存在 参数
 *@param account 账号
 */
+ (NSDictionary*)detectAccountExist:(NSString*) account;

/**检测账号是否存在 结果
 *@return 存在则返回nil，否则返回提示信息
 */
+ (NSString*)detectAccountExistResultFromData:(NSData*) data;

/**注册 参数
 *@param phoneNumber 手机号码
 *@param code 短信验证码
 *@param password 密码
 */
+ (NSDictionary*)registerParamsWithPhoneNumber:(NSString*) phoneNumber code:(NSString*) code password:(NSString*) password;

/**注册结果
 *@return 是否成功
 */
+ (BOOL)registerResultFromData:(NSData*) data;

/**注销 参数
 */
+ (NSDictionary*)logoutParams;

/**注销结果
 *@return 是否退出成功
 */
+ (BOOL)logoutResultFromData:(NSData*) data;

#pragma mark- 个人信息

/**获取个人信息 参数
 */
+ (NSDictionary*)userInfoParams;

/**从返回的数据中获取个人信息
 */
+ (WMUserInfo*)userInfoFromData:(NSData*) data;

/**会员等级说明 参数
 */
+ (NSDictionary*)userLevelInfoParams;

/**会员等级说明 结果
 *@return html字符串
 */
+ (NSString*)userLevelInfoFromData:(NSData*) data;

/**账户安全信息 参数
 */
+ (NSDictionary*)accountSecurityParams;

/**账户安全信息 结果
 *@return 账户安全信息 会保存在
 */
+ (WMAccountSecurityInfo*)accountSecurityInfoFromData:(NSData*) data;

#pragma mark- 修改个人信息

/**上传图片，参数
 */
+ (NSDictionary*)uploadImageParams;

/**上传图片结果
 *@return 图片路径
 */
+ (NSString*)uploadImageResultFromData:(NSData*) data;

/**修改个人资料 参数
 *@param dic value 修改的内容, key 修改的字段
 */
+ (NSDictionary*)modifyUserInfoParamWithDictionary:(NSDictionary*) dic;

/**修改个人资料结果
 *@return 是否修改成功
 */
+ (BOOL)modifyUserInfoResultFromData:(NSData*) data;

/**设置用户名 参数
 *@param username 用户名
 */
+ (NSDictionary*)setupUsernameParams:(NSString*) username;

/**设置用户名 结果
 *@return 是否成功
 */
+ (BOOL)setupUsernameResultFromData:(NSData*) data;

/**修改密码 参数
 *@param org 原密码
 *@param news 新密码
 */
+ (NSDictionary*)modifyPasswdParamWithOrg:(NSString*) org news:(NSString*) news;

/**修改密码结果
 *@return 修改结果或错误信息
 */
+ (BOOL)modifyPasswdFromData:(NSData*) data;

/**获取手机验证码 参数
 *@param phoneNumber 手机号
 *@param type 类型 通过宏 WMUserInterface.h头文件中
 *@param code 验证码
 */
+ (NSDictionary*)getPhoneCodeParamWithPhoneNumber:(NSString*) phoneNumber type:(NSString*) type code:(NSString*) code;

/**获取手机验证码结果
 *@return 是否获取成功
 */
+ (BOOL)getPhoneCodeResultFromData:(NSData*) data;

/**获取已发送的短信验证码 参数
 *@param phoneNumber 手机号
 *@param type 类型 通过宏 WMUserInterface.h头文件中
 */
+ (NSDictionary*)getSendedCodeParamWithPhoneNumber:(NSString*) phoneNumber type:(NSString*) type;

/**获取已发送的短信验证码 结果
 *@return 短信验证码
 */
+ (NSString*)getSendedCodeFromData:(NSData*) data;

/**绑定手机号界面所需信息 参数
 */
+ (NSDictionary*)changeBindPhoneNeedsParams;

/**绑定手机号界面所需信息 结果
 *@return 图形验证码链接，返回nil则不需要
 */
+ (NSString*)changeBindPhoneNeedsFromData:(NSData*) data;

/**更改绑定手机号码 参数
 *@param phone 手机号码
 *@param code 短信验证码
 */
+ (NSDictionary *)changeBindPhoneParam:(NSString *) phone vcode:(NSString *)code;

/**更改绑定手机号码 结果
 */
+ (BOOL)changeBindPhoneResult:(NSData *)data;

/**重置登陆密码 参数
 *@param code 短信验证码
 */
+ (NSDictionary *)resetLogInPassWordWithPhone:(NSString *)phone newPassWord:(NSString *)newPassWord code:(NSString*) code;

/**重置登陆密码 结果
 */
+ (BOOL)resetLogInPassWordResultWithData:(NSData *)data;

/**重置登录密码 获取所需信息 参数
 */
+ (NSDictionary*)resetLoginPasswordNeedParams;

/**重置登录密码 获取所需信息 结果
 *@return 如果需要，则返回验证码链接，否则返回nil，key为code
 *@return 客服电话，key为phone
 */
+ (NSDictionary*)resetLoginPasswordNeedResultFromData:(NSData*) data;

/**获取可编辑的个人信息 参数
 */
+ (NSDictionary*)editableUserInfoParams;

/**获取可编辑的个人信息 结果
 *@return 数组元素是 WMSettingInfo
 */
+ (NSArray*)editableUserInfoFromData:(NSData*) data;

#pragma mark- 协议

/**获取用户协议
 */
+ (NSDictionary*)userProtocolParam;

/**获取用户协议 结果
 *@return html用户协议内容
 */
+ (NSString*)userProtocolResultFromData:(NSData*) data;

/**隐私保护政策 参数
 */
+ (NSDictionary*)privacyPolicyParams;

/**隐私保护政策 结果
 *@return html 隐私政策
 */
+ (NSString*)privacyPolicyFromData:(NSData*) data;

#pragma mark- 其他

/**意见反馈 参数
 *@param content 反馈内容
 *@param contact 联系方式
 */
+ (NSDictionary*)feedbackParamWithContent:(NSString*) content contact:(NSString*) contact;

/**意见反馈结果
 *@return 是否反馈成功
 */
+ (BOOL)feedBackResultFromData:(NSData*) data;


/**保存设备token 参数
 *@param token
 */
+ (NSDictionary*)saveTokenParam:(NSString*) token;

/**实名认证 参数
 *@param 身份证号码 NSString
 *@param 身份证姓名 NSString
 */
+ (NSDictionary *)commitRealNameWithName:(NSString *)name identityCardID:(NSString *)cardID;

/**实名认证的结果
 */
+ (BOOL)commitRealNameWithData:(NSData *)data;


/**设置支付密码 参数
 *@param NSString 第一次支付密码
 *@param NSString 第二次支付密码
 *@param NSString 验证码
 */
+ (NSDictionary *)setPayPassWordFirstPay:(NSString *)firstPay comfirmPay:(NSString *)confirmPay phoneCode:(NSString *)code;

/**更改支付密码 参数
 *@param NSString 旧密码
 *@param NSString 新密码
 */
+ (NSDictionary *)changePayPassWordWith:(NSString *)oldPayPass newPayPass:(NSString *)newPayPass;

/**设置支付密码 结果
 */
+ (BOOL)setPayPassWordResult:(NSData *)data;

/**核实旧手机的验证码 参数
 *@param NSString 验证码
 *@param NSString 旧手机号码
 */
+ (NSDictionary *)verifyOldPhoneWithPhone:(NSString *)phone codeStr:(NSString *)codeStr;

/**核实旧手机的验证码 结果
 */
+ (BOOL)returnVerifyOldPhoneResultWith:(NSData *)data;

#pragma mark- other

/**接口请求失败处理
 *@param dic 原始的josn 最外层的字典
 *@param flag 是否提示错误信息
 *@return 错误信息，没有则返回nil
 */
+ (NSString*)errorMsgFromDictionary:(NSDictionary*) dic alertErrorMsg:(BOOL) flag;

/**获取列表的总数，
 *@param dic 包含有pager 字段的字典，一般是放在data 里面的
 *@return 列表总数
 */
+ (long long)totalSizeFromDictionary:(NSDictionary*) dic;

/**获取接口响应结果
 *@param dic 包含接口响应结果的字典
 *@return 是否成功
 */
+ (BOOL)resultFromDictionary:(NSDictionary*) dic;

@end
