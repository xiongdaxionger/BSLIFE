//
//  WMWithDrawInfo.h
//  StandardFenXiao
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**提现的说明模型
 */
@interface WMWithDrawInfo : NSObject
/**提现的最大值
 */
@property (strong,nonatomic) NSNumber *maxWithDrawMoney;
/**提现的最小值
 */
@property (strong,nonatomic) NSNumber *minWithDrawMoney;
/**可提现的金额
 */
@property (strong,nonatomic) NSNumber *canWithDrawMoney;
/**税金的比例
 */
@property (strong,nonatomic) NSNumber *withDrawTax;
/**提现费率,手续费/平台服务费等
 */
@property (strong,nonatomic) NSNumber *withDrawPlatformMoney;
/**提示数据的数组
 */
@property (strong,nonatomic) NSArray *noticeInfoArr;
/**初始化
 */
+ (instancetype)returnWithDrawInfoWithArr:(NSArray *)arr;
@end
