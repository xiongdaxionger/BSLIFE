//
//  WMRegisterViewController.h
//  AKYP
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**注册页面
 */
@interface WMRegisterViewController : SeaTableViewController

/**登录完成的回调
 */
@property (nonatomic, copy) void(^loginCompletionHandler)(void);

/**注册信息，数组元素是 WMInputInfo
 */
@property (strong,nonatomic) NSArray *infos;

///手机号码
@property (copy, nonatomic) NSString *phoneNumber;

///短信验证码
@property (copy, nonatomic) NSString *smsCode;

@end
