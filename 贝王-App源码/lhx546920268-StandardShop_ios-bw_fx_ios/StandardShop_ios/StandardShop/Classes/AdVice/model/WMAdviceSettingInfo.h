//
//  WMAdviceSettingInfo.h
//  StandardShop
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>
/**咨询的配置数据模型
 */
@interface WMAdviceSettingInfo : NSObject
/**能否回答咨询
 */
@property (assign,nonatomic) BOOL canReplyAdvice;
/**回复咨询或发表咨询后是否需要管理员审核
 */
@property (assign,nonatomic) BOOL needAdminVerify;
/**发布咨询成功提示语
 */
@property (copy,nonatomic) NSString *commitAdviceSuccessTip;
/**咨询疑问提示语
 */
@property (copy,nonatomic) NSString *adviceQuestionTip;
/**咨询客服电话
 */
@property (copy,nonatomic) NSString *adviceServicePhone;
/**回复验证码
 */
@property (copy,nonatomic) NSString *verifyCode;
/**发表验证码
 */
@property (copy,nonatomic) NSString *askVerifyCode;
/**初始化
 */
+ (instancetype)returnAdviceSettingInfoWithDict:(NSDictionary *)dict;
@end
