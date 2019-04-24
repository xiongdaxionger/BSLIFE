//
//  WMAdviceTypeInfo.h
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**咨询类型数据模型
 */
@interface WMAdviceTypeInfo : NSObject
/**咨询类型名称
 */
@property (copy,nonatomic) NSString *adviceTypeName;
/**咨询类型ID
 */
@property (copy,nonatomic) NSString *adviceTypeID;
/**当前咨询类型包含的咨询数目
 */
@property (copy,nonatomic) NSString *adviceTypeNumber;
/**咨询是否选择
 */
@property (assign,nonatomic) BOOL adviceTypeIsSelect;
/**批量初始化
 */
+ (NSArray *)returnAdviceTypeInfoArrWithDataArr:(NSArray *)dataArr;
@end
