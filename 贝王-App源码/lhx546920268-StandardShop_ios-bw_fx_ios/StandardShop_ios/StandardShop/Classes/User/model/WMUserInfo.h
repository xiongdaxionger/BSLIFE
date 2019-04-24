//
//  WMUserInfo.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMPersonCenterInfo.h"
#import "WMAccountSecurityInfo.h"

/**用户信息
 */
@interface WMUserInfo : NSObject<NSCoding,NSCopying>

/**用户Id
 */
@property(nonatomic,copy) NSString *userId;

/**账户
 */
@property(nonatomic,copy) NSString *account;

/**用户头像
 */
@property(nonatomic,copy) NSString *headImageURL;

/**昵称
 */
@property(nonatomic,copy) NSString *name;

/**昵称前缀
 */
@property(nonatomic,copy) NSString *namePrefix;

/**是否设置支付密码
 */
@property (assign,nonatomic) BOOL has_pay_password;

/**显示的昵称
 */
@property(nonatomic,readonly) NSString *displayName;

///用户中心信息
@property (nonatomic,strong) WMPersonCenterInfo *personCenterInfo;

///账户安全信息
@property(nonatomic,strong) WMAccountSecurityInfo *accountSecurityInfo;

/**冻结积分
 */
@property (copy,nonatomic) NSString *freezeIntegral;

/**用户等级名称
 */
@property(nonatomic,copy) NSString *level;

/**用户等级
 */
@property(nonatomic,copy) NSString *levelNumber;

/**经验
 */
@property (copy,nonatomic) NSString *experience;

/**升级所需经验
 */
@property (copy,nonatomic) NSString *levelupExperience;

/**经验名称 有时候升级是通过积分，有时候通过成长点，这个后台可以设置
 */
@property (copy,nonatomic) NSString *experienceName;

/**下一等级名称
 */
@property (copy,nonatomic) NSString *nextLevel;

/**性别 0女, 1男，2其他
 */
@property(nonatomic,copy) NSString *sex;

/**性别字符串
 */
@property(nonatomic,readonly) NSString *sexString;

/**购物车数量
 */
@property(nonatomic,assign) int shopcartCount;


/**是否可以使用分销
 */
@property(nonatomic,readonly) BOOL enableUseFenXiao;

///是否是社交账号登录
@property(nonatomic,assign) BOOL isSocailLogin;

///是否需要绑定手机号
@property(nonatomic,readonly) BOOL shouldBindPhoneNumber;

/**从字典中获取数据
 *@param isLoginUser 是否是登录用户
 */
+ (id)infoFromDictionary:(NSDictionary*) dic isLoginUser:(BOOL) isLoginUser;

/**是否曾经已登录
 */
+ (BOOL)isOnceLogin;

/**从userDefaults 中获取已登录的用户信息
 */
//+ (WMUserInfo*)userInfoFromUserDefaults;

/**保存 登录的用户信息
 */
- (void)saveUserInfoToUserDefaults;

/**注销登录
 */
+ (void)logout;

/**当前登录用户信息，如果用户没登录，返回nil
 */
+ (instancetype)sharedUserInfo;

/**获取性别图标
 */
- (UIImage*)sexImage;

/**是否是当前登录用户
 */
- (BOOL)isCurrentLoginUser;

/**通过字段获取性别名称
 */
+ (NSString*)sexStringForKey:(NSString*) key;

/**购物车数量
 *@return 没登录时会读 cookie里面的
 */
+ (NSString*)displayShopcarCount;

@end
