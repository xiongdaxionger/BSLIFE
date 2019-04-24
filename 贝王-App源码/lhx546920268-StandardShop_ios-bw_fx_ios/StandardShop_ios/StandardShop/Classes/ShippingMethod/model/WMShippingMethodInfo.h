//
//  WMShippingMethodInfo.h
//  StandardShop
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**配送方式模型
 */
@interface WMShippingMethodInfo : NSObject
/**配送方式的JSON字符串
 */
@property (copy,nonatomic) NSString *methodJsonValue;
/**配送方式的ID
 */
@property (copy,nonatomic) NSString *methodID;
/**配送方式的名称
 */
@property (copy,nonatomic) NSString *methodName;
/**配送价格
 */
@property (copy,nonatomic) NSString *methodPrice;
/**是否开启物流保价
 */
@property (assign,nonatomic) BOOL isExpressProtect;
/**物流保价的信息
 */
@property (copy,nonatomic) NSString *methodExpressMessage;
/**物流保价是否选中--当isExpressCanSelect为否时，isExpressSelect永远为否
 */
@property (assign,nonatomic) BOOL isExpressSelect;
/**自提时间的时间戳
 */
@property (copy,nonatomic) NSString *branchTime;
/**批量初始化
 */
+ (NSArray *)returnShippingMethodInfoWithDictsArr:(NSArray *)dictsArr;

@end
