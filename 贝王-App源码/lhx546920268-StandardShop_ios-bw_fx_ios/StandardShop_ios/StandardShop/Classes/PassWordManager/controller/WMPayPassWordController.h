//
//  WMVerifyIdentityViewController.h
//  StandardShop
//
//  Created by mac on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

/**设置支付密码、修改支付密码/忘记支付密码
 */
@interface WMPayPassWordController : SeaTableViewController
/**设置完成支付密码后的回调
 */
@property (copy,nonatomic) void(^setPayPassWordSuccess)(NSString *payPass);
/**是否修改支付密码
 */
@property (assign,nonatomic) BOOL isChangePayPass;
/**是否为设置支付密码
 */
@property (assign,nonatomic) BOOL isSetPayPass;
@end
