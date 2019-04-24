//
//  WMAdviceSettingInfo.m
//  StandardShop
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceSettingInfo.h"

@implementation WMAdviceSettingInfo
/**初始化
 */
+ (instancetype)returnAdviceSettingInfoWithDict:(NSDictionary *)dict{
    
    WMAdviceSettingInfo *settingInfo = [WMAdviceSettingInfo new];
    
    settingInfo.adviceQuestionTip = [dict sea_stringForKey:@"submit_comment_notice"];
    
    settingInfo.commitAdviceSuccessTip = [dict sea_stringForKey:@"submit_notice"];
    
    settingInfo.canReplyAdvice = [[dict sea_stringForKey:@"switch_reply"] isEqualToString:@"on"];
    
    settingInfo.verifyCode = [dict sea_stringForKey:@"verifyCode"];
    
    settingInfo.askVerifyCode = [dict sea_stringForKey:@"askVerifyCode"];
    
    settingInfo.needAdminVerify = [[dict sea_stringForKey:@"display"] isEqualToString:@"false"];
    
    settingInfo.adviceServicePhone = [dict sea_stringForKey:@"submit_comment_notice_tel"];
    
    return settingInfo;
}
@end
