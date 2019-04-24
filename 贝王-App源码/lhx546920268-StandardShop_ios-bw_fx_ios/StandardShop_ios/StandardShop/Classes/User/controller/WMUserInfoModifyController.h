//
//  WMUserInfoModifyController.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMSettingInfo.h"

@class WMSettingInfo;

/**用户信息修改，输入框， 可修改店铺名称，微信号
 */
@interface WMUserInfoModifyController : SeaScrollViewController<UITextFieldDelegate>

/**设置信息
 */
@property(nonatomic,assign) WMSettingInfo *settingInfo;

@end
