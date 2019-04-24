//
//  WMBindPhoneNumberViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMSettingInfo,WMSocialUser;

///绑定手机号，主要用于第三方登录、不是手机注册的用户、或者换绑
@interface WMBindPhoneNumberViewController : SeaTableViewController

///授权的用户信息，在登录界面使用第三方登录完成时进入这里
@property(nonatomic,strong) WMSocialUser *authorizedUser;

///个人资料中绑定手机号
@property(nonatomic,strong) WMSettingInfo *settingInfo;

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

/**绑定完成回调
 */
@property (nonatomic, copy) void(^bindCompletionHandler)(void);

/**绑定完成是否需要返回 default is YES
 */
@property (nonatomic, assign) BOOL shouldBackAfterBindCompletion;

@end
