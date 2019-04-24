//
//  WMUserInterface.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

/**有关用户的宏定义
 */

#ifndef WestMailDutyFee_WMUserInterface_h
#define WestMailDutyFee_WMUserInterface_h

/**登录成功通知，可通过WMUserInfo 中的 userInfoFromUserDefaults 获取登录用户的信息
 */
#define WMLoginSuccessNotification @"WMLoginSuccessNotification"

/**用户退出登录
 */
#define WMUserDidLogoutNotification @"WMUserDidLogoutNotification"

/**自动登录失败
 */
#define WMUserAutoLoginDidFailNotification @"WMUserAutoLoginDidFailNotification"

/**用户信息修改成功,可通过WMUserInfo 中的 userInfoFromUserDefaults 获取登录用户的信息
 */
#define WMUserInfoDidModifyNotification @"WMUserInfoDidModifyNotification"

/**添加获取用户信息成功通知,可通过WMUserInfo 中的 userInfoFromUserDefaults 获取登录用户的信息
 */
#define WMUserInfoDidGetNotification @"WMUserInfoDidGetNotification"

/**充值成功 
 */
#define WMDidTopupNotification @"WMUserInfoDidTopupNotification"

/**提现成功
 */
#define WMDidWithdrawNotification @"WMDidWithdrawNotification"

/**发布咨询成功
 */
#define WMCommitAdviceSuccessNotification @"WMCommitAdviceSuccessNotification"

/**注册成功
 */
#define WMUserDidRegisterSuccessNotification @"WMUserDidRegisterSuccessNotification"

/**保存在userDefaults 中的账号和密码
 */
#define WMLoginAccount @"WMLoginAccount"
#define WMLoginPassword @"WMLoginPassword"

/**保存在userDefaults 中的手势密码
 */
#define WMGesturePassword @"WMGesturePassword" ///字符串
#define WMGestureUseStatus @"WMGestureUseStatus" ///bool值

/**修改分类成功的通知
 */
#define WMChangeSpecialSuccess @"ChangeSpecialSuccess"

/**用户信息
 */
#define WMUserInfoId @"member_id" /**用户id*/
#define WMUserInfoName @"name" ///昵称
#define WMUserInfoHeadImageURL @"avatar" // 用户头像
#define WMUserInfoSignature @"descsign" ///个性签名


#define WMUserInfoSex @"sex" ///性别
#define WMUserInfoBoy @"male" ///男
#define WMUserInfoGirl @"female" ///女

#define WMUserInfoArea @"area" ///地区
#define WMUserInfoBirthday @"birthday" ///生日
#define WMUserInfoRecommender @"parent_account" ///推荐人

#define WMUserInfoShopForImageURL @"cover" ///店招背景
#define WMUserInfoPhoneNumber @"mobile" /**联系电话*/

#define WMUserInfoShopDecoration @"cover" ///店铺装饰背景
#define WMUserInfoBalance @"advance" ///用户余额




#define WMUserInfoShopLink @"shop_link" //店铺链接
#define WMUserInfoShopUrl @"shop_url"  //店铺主页


#define WMUserInfoShopName @"shop_name" /**店铺名称*/
#define WMUserInfoShopHeadImageURL @"shop_avatar" /**店铺头像*/
#define WMUserInfoWinxin @"wx_name" //微信号
#define WMUserInfoShopNotice @"shop_notice" ///店铺公告
#define WMUserInfoServiceTel @"service_tel" ///客服电话
#define WMUserInfoShopArea @"shop_area" ///店铺地区
#define WMUserInfoShopAddr @"shop_addr" ///店铺详细地址
#define WMUserInfoFreight @"cost_freight" ///运费



/**手机验证码
 */
#define WMPhoneNumberCodeTypeActivation @"activation" //其他类型
#define WMPhoneNumberCodeTypeForgot @"forgot" ///忘记密码
#define WMPhoneNumberCodeTypeRegister @"signup" ///注册
#define WMPhoneNumberCodeTypeSocialLogin @"trustlogin" ///第三方登录
#define WMPhoneNumberCodeTypeBindPhone @"reset" ///绑定手机号
#define WMPhoneNumberCodeTypeAddPartner @"invite" ///添加会员

///保存在userDefault 中token值
#define WMTokenKey @"WMTokenKey"



///客服电话
#define WMServiceTelPhone @"400-6396-392"

#pragma mark- user

//头像大小
#define WMHeadImageSize 320

//推荐图片大小
#define WMRecommendImageSize CGSizeMake(320, 320)

/////性别
//typedef NS_ENUM(NSInteger, WMUserSex)
//{
//    ///女
//    WMUserSexGirl = 0,
//    
//    ///男
//    WMUserSexBoy = 1,
//    
//    ///未知
//    WMUserSexNotknow = 2,
//};

///左右脚
typedef NS_ENUM(NSInteger, WMFootType)
{
    ///左脚
    WMFootTypeLeft = 1,
    
    ///右脚
    WMFootTypeRight = 2,
};

//核实身份类型
typedef NS_ENUM(NSInteger, VerifyIdentiType){
    
    ///核实旧手机
    VerifyIdentiTypeOldPhone = 1,
    
    ///核实新手机并绑定
    VerifyIdentiTypeNewPhone = 2,
};

///高德地图key
#define MAMapKey @"3311a49bb91b34703215981c5ecd7134"

#endif
