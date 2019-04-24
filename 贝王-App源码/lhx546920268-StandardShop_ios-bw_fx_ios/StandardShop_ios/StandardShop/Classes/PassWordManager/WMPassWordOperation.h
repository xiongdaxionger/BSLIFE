//
//  WMPassWordOperation.h
//  WanShoes
//
//  Created by mac on 16/3/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置支付密码网络请求
#define WMSetPayPassWordIdentifier @"WMSetPayPassWordIdentifier"
//修改支付密码/忘记支付密码网络请求
#define WMVerifyPayPassWordIdentifier @"WMVerifyPayPassWordIdentifier"
//获取修改支付密码/忘记支付设置信息的网络请求
#define WMGetVerifyPayPassWordInfoIdentifier @"WMGetVerifyPayPassWordInfoIdentifier"

@interface WMPassWordOperation : NSObject

/**验证登陆密码 参数
 *@param 验证类型 verifyType
 *@param 验证码 code
 *@param 登陆密码 logInPassWord
 */
+ (NSDictionary *)returnVerifyLogInPassWordWithType:(NSString *)verifyType code:(NSString *)code logInPassWord:(NSString *)logInPassWord;
/**验证登陆密码 结果
 */
+ (id)returnVerifyLogInPassWordResultWithData:(NSData *)data;

/**设置支付密码 参数
 *@param 验证类型 verifyType
 *@param 验证码 code
 *@param 登陆密码 logInPassWord
 *@param 第一次的支付密码 firstPayPass
 *@param 第二次的支付密码 secondPayPass
 */
+ (NSDictionary *)returnSetPayPassWordWithType:(NSString *)type code:(NSString *)code logInPassWord:(NSString *)logInPassWord firstPayPass:(NSString *)firstPayPass secondPayPass:(NSString *)secondPayPass;
/**设置支付密码 结果
 */
+ (BOOL)returnSetPayPassWordReusltWithData:(NSData *)data;

/**修改支付密码/忘记支付密码判断用户是否绑定手机 参数
 */
+ (NSDictionary *)returnGetUserIsBindingPhoneWithType:(NSString *)type;
/**修改支付密码/忘记支付密码判断用户是否绑定手机 结果
 */
+ (NSDictionary *)returnGetUserIsBindingPhoneResultWithData:(NSData *)data;

/**修改支付密码/忘记支付密码 参数
 *@param 手机号码 phone--当用户绑定手机时通过手机验证修改支付密码
 *@param 手机验证码 phoneCode
 *@param 图形验证码 imageCode--用户没绑定手机使用登录密码修改支付密码，登录密码错误三次需要图形验证
 *@param 首次输入的支付密码 firstPayPass
 *@param 再次输入的支付密码 secPayPass
 *@param 登录密码 logInPass
 */
+ (NSDictionary *)returnVerifyPayPassWordWithPhone:(NSString *)phone phoneCode:(NSString *)phoneCode imageCode:(NSString *)imageCode firstPayPass:(NSString *)firstPayPass secPayPass:(NSString *)secPayPass logInPass:(NSString *)logInPass;
/**修改支付密码/忘记支付密码 结果
 */
+ (id)returnVerifyPayPassWordResultWithData:(NSData *)data;

/**修改密码 参数
 */
+ (NSDictionary*)modifyPasswdParamWithOrg:(NSString*) org news:(NSString*) news confirm:(NSString*) confirm;
/**修改密码 结果
 */
+ (BOOL)returnModifyPassWordReslutWithData:(NSData *)data;
@end
