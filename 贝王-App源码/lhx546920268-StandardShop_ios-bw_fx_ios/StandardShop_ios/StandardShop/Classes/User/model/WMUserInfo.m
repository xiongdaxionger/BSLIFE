//
//  WMUserInfo.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMUserInfo.h"
#import "WMUserOperation.h"
#import "WMSocialLoginOperation.h"

//保存在userdefault中的用户信息
#define WMLoginUserInfo @"WMLoginUserInfo"
static WMUserInfo *sharedUserInfo = nil;

@implementation WMUserInfo


#pragma mark- code

- (NSString*)experience
{
    if(!_experience)
    {
        return @"";
    }
    
    return _experience;
}

- (NSString*)levelupExperience
{
    if(!_levelupExperience)
    {
        return @"";
    }
    
    return _levelupExperience;
}

//归档序列化
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.headImageURL = [aDecoder decodeObjectForKey:@"headImageURL"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.namePrefix = [aDecoder decodeObjectForKey:@"namePrefix"];
        self.experience = [aDecoder decodeObjectForKey:@"experience"];
        self.freezeIntegral = [aDecoder decodeObjectForKey:@"freezeIntegral"];
        self.has_pay_password = [aDecoder decodeBoolForKey:@"setPayPass"];
        
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.levelupExperience = [aDecoder decodeObjectForKey:@"levelupExperience"];
        self.nextLevel = [aDecoder decodeObjectForKey:@"nextLevel"];

        self.personCenterInfo = [aDecoder decodeObjectForKey:@"personCenterInfo"];

        self.level = [aDecoder decodeObjectForKey:@"level"];
        self.experienceName = [aDecoder decodeObjectForKey:@"experienceName"];
        self.shopcartCount = [aDecoder decodeIntForKey:@"shopcartCount"];
    }
   
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.headImageURL forKey:@"headImageURL"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.namePrefix forKey:@"namePrefix"];
    [aCoder encodeObject:self.experience forKey:@"experience"];
    [aCoder encodeObject:self.freezeIntegral forKey:@"freezeIntegral"];
    [aCoder encodeBool:self.has_pay_password forKey:@"setPayPass"];
    
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.levelupExperience forKey:@"levelupExperience"];
    [aCoder encodeObject:self.nextLevel forKey:@"nextLevel"];

    [aCoder encodeObject:self.personCenterInfo forKey:@"personCenterInfo"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.experienceName forKey:@"experienceName"];
    [aCoder encodeInt:self.shopcartCount forKey:@"shopcartCount"];
}

#pragma mark- copy

- (instancetype)copyWithZone:(NSZone *)zone
{
    WMUserInfo *info = [[WMUserInfo allocWithZone:zone] init];
    info.nextLevel = self.nextLevel;
    info.levelupExperience = self.levelupExperience;
    info.userId = self.userId;
    info.account = self.account;
    info.headImageURL = self.headImageURL;
    info.name = self.name;
    info.experience = self.experience;
    info.level = self.level;
    info.has_pay_password = self.has_pay_password;
    info.sex = self.sex;
    info.experienceName = self.experienceName;
    info.shopcartCount = self.shopcartCount;
    
    return info;
}

#pragma mark- other

- (NSString*)displayName
{
    if(!self.personCenterInfo.openFenxiao && ![NSString isEmpty:self.account])
    {
        return self.account;
    }
    
    if([NSString isEmpty:_name])
    {
        if([self isCurrentLoginUser])
        {
            NSString *account = [SeaUserDefaults objectForKey:WMLoginAccount];
            if(account.length == 11)
            {
                account = [account stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"***"];
                return account;
            }
            else
            {
                return account;
            }
        }
        else
        {
            return @"未设置";
        }
    }
    else
    {
        if(![NSString isEmpty:self.namePrefix] && self.personCenterInfo.openFenxiao)
        {
            return [NSString stringWithFormat:@"%@%@", self.namePrefix, _name];
        }
    }
    
    return _name;
}

- (void)dealloc
{
    
}

/**从字典中获取数据
 *@param isLoginUser 是否是登录用户
 */
+ (id)infoFromDictionary:(NSDictionary*) dic isLoginUser:(BOOL) isLoginUser
{
    NSDictionary *memberDic = [dic dictionaryForKey:@"member"];
    WMUserInfo *info = [[WMUserInfo alloc] init];

    if(memberDic)
    {
        info.userId = [memberDic sea_stringForKey:WMUserInfoId];
        info.headImageURL = [memberDic sea_stringForKey:WMUserInfoHeadImageURL];
        info.name = [memberDic sea_stringForKey:WMUserInfoName];
        info.account = [memberDic sea_stringForKey:@"uname"];
        
        info.level = [memberDic sea_stringForKey:@"levelname"];
        info.has_pay_password = [[memberDic numberForKey:@"has_pay_password"] boolValue];

        info.experience = [memberDic sea_stringForKey:@"experience"];

        NSDictionary *levelDic = [dic dictionaryForKey:@"switch_lv"];
        if(levelDic)
        {
            info.nextLevel = [levelDic sea_stringForKey:@"lv_name"];
            info.levelupExperience = [levelDic sea_stringForKey:@"lv_data"];
            info.experienceName = [[levelDic numberForKey:@"switch_type"] boolValue] ? @"点成长值" : @"积分";
        }
        
        info.shopcartCount = [[memberDic numberForKey:@"cart_number"] intValue];

        info.namePrefix = [dic sea_stringForKey:@"shopname"];
    }
    else
    {
        info.userId = [dic sea_stringForKey:WMUserInfoId];
        
        ///同一个账号登录，不清除原来的信息
        if([sharedUserInfo.userId isEqualToString:info.userId] && isLoginUser)
        {
            return sharedUserInfo;
        }
    }

    if(isLoginUser)
    {
        info.personCenterInfo = [WMPersonCenterInfo infoFromDictionary:dic];
        info.accountSecurityInfo = sharedUserInfo.accountSecurityInfo;
        info.isSocailLogin = sharedUserInfo.isSocailLogin;
        sharedUserInfo = info;
        
        [info saveUserInfoToUserDefaults];
    }
    
    return info;
}

- (BOOL)shouldBindPhoneNumber
{
    //没有绑定手机号
    return [NSString isEmpty:self.accountSecurityInfo.phoneNumber];
}

/**获取性别字符串
 */
- (NSString*)sexString
{
    return [WMUserInfo sexStringForKey:self.sex];
}

/**通过字段获取性别名称
 */
+ (NSString*)sexStringForKey:(NSString*) key
{
    if([key isEqualToString:WMUserInfoBoy])
    {
        return @"男";
    }
    else if([key isEqualToString:WMUserInfoGirl])
    {
        return @"女";
    }
    return @"";
}

/**是否曾经已登录
 */
+ (BOOL)isOnceLogin
{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginAccount];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:WMLoginPassword];
    
    ///判断是否是注册用户登录
    return (![NSString isEmpty:account] && ![NSString isEmpty:password]) || [WMSocialLoginOperation socialAuth] != nil;
}

/**从userDefaults 中获取已登录的用户信息
 */
+ (WMUserInfo*)userInfoFromUserDefaults;
{
    NSData *data = [SeaUserDefaults objectForKey:WMLoginUserInfo];
    if(data)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

/**保存 登录的用户信息
 */
- (void)saveUserInfoToUserDefaults
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [SeaUserDefaults setObject:data forKey:WMLoginUserInfo];
}

/**注销登录
 */
+ (void)logout
{
    [SeaUserDefaults removeObjectForKey:WMLoginUserInfo];
    [SeaUserDefaults removeObjectForKey:WMLoginPassword];
    sharedUserInfo = nil;
    [AppDelegate instance].isLogin = NO;
    
    ///取消授权
    [WMSocialLoginOperation cancelSocialAuth];
    
    ///清除cookie
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", SeaNetworkDomainName]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    
    for (int i = 0; i < [cookies count]; i++)
    {
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
        if([cookie.name isEqualToString:@"UNAME"] || [cookie.name isEqualToString:@"S[MEMBER]"])
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

/**用户信息
 */
+ (instancetype)sharedUserInfo
{
    if(sharedUserInfo == nil)
    {
        sharedUserInfo = [WMUserInfo userInfoFromUserDefaults];
        
        if(sharedUserInfo == nil)
        {
            sharedUserInfo = [[WMUserInfo alloc] init];
            sharedUserInfo.personCenterInfo = [[WMPersonCenterInfo alloc] init];
        }
    }
    
    return sharedUserInfo;
}

/**是否是当前登录用户
 */
- (BOOL)isCurrentLoginUser
{
    return [self.userId isEqualToString:[WMUserInfo sharedUserInfo].userId];
}

/**是否可以使用分销
 */
- (BOOL)enableUseFenXiao
{
    return [AppDelegate instance].isLogin && self.personCenterInfo.openFenxiao;
}

/**获取性别图标
 */
- (UIImage*)sexImage
{
    if([self.sex isEqualToString:WMUserInfoBoy])
    {
        return [UIImage imageNamed:@"boy_icon"];
    }
    else if ([self.sex isEqualToString:WMUserInfoGirl])
    {
        return [UIImage imageNamed:@"girl_icon"];
    }

    return nil;
}

/**购物车数量
 *@return 没登录时会读 cookie里面的
 */
+ (NSString*)displayShopcarCount
{
    if([AppDelegate instance].isLogin)
    {
        return [NSString stringWithFormat:@"%d", (int)[WMUserInfo sharedUserInfo].shopcartCount];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", SeaNetworkDomainName]];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        
        for(NSHTTPCookie *cookie in cookies)
        {
            if([cookie.name isEqualToString:@"S[CART_NUMBER]"])
            {
                return cookie.value;
            }
        }
    }
    
    return @"0";
}

@end
