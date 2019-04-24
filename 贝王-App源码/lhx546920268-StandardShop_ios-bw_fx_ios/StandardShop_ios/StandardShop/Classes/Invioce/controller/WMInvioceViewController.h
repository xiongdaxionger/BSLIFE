//
//  WMInvioceViewController.h
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

///下单发票
@interface WMInvioceViewController : SeaTableViewController
/**配置类数组
 */
@property (strong,nonatomic) NSArray *configArr;
/**是否开发票
 */
@property (assign,nonatomic) BOOL isOpenInvioce;
/**发票的内容
 */
@property (copy,nonatomic) NSString *invioceContent;
/**发票的抬头
 */
@property (copy,nonatomic) NSString *invioceHeader;
/**发票的类型数组
 */
@property (strong,nonatomic) NSArray *invioceTypeArr;
/**选中状态
 */
@property (strong,nonatomic) NSDictionary *selectStatus;
/**选中下标
 */
@property (assign,nonatomic) NSInteger selectIndex;
/**回调
 */
@property (copy,nonatomic) void(^commitButtonClick)(NSString *invioceHeader,NSString *invioceContent,BOOL isOpenInvioce,NSInteger selectIndex);
/**选择发票内容
 */
- (void)selectInvioceType;
@end
