//
//  SettingPageViewController.h
//  WuMei
//
//  Created by qsit on 15/7/30.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "SeaViewController.h"

//设置类型
typedef NS_ENUM(NSInteger, SettingType){
    
    //修改登录密码
    SettingTypeChangeLogIn = 0,
    
    //修改支付密码
    SettingTypeChangePayPass = 1,
    
    //忘记支付密码
    SettingTypeForgetPayPass = 2,
    
    //设置支付密码
    SettingTypeSetPayPass = 3,
    
    //帮助中心
    SettingTypeHelpCenter = 4,
    
    //关于我们
    SettingTypeAboutMe = 5,
    
    //清除缓存
    SettingTypeClearCache = 6
};
/**设置
 */
@interface WMSettingPageViewController : SeaViewController

@end
