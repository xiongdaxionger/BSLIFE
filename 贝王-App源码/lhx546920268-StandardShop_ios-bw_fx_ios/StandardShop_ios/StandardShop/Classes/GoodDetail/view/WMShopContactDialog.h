//
//  WMShopContactDialog.h
//  StandardShop
//
//  Created by Hank on 16/11/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaDialogViewController.h"
@class WMShopContactInfo;
/**联系人弹窗
 */
@interface WMShopContactDialog : SeaDialog
/**控制器
 */
@property (weak,nonatomic) SeaViewController *controller;
/**回调
 */
@property (copy,nonatomic) void(^contactCallBack)(BOOL isExist);
/**初始化
 */
- (instancetype)init;
@end
