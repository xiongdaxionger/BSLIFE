//
//  WMPayMethodModel.h
//  StandardFenXiao
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMPayMethodModel : NSObject
/**支付方式名称
 */
@property (copy,nonatomic) NSString *payInfoName;
/**支付方式ID
 */
@property (copy,nonatomic) NSString *payInfoID;
/**支付方式描述
 */
@property (copy,nonatomic) NSString *payInfoDesc;
/**支付方式的图标
 */
@property (copy,nonatomic) NSString *payInfoIcon;
/**支付方式JSON值
 */
@property (copy,nonatomic) NSString *payJsonString;
/**支付方式是否选中
 */
@property (assign,nonatomic) BOOL payIsSelect;
/**批量初始化
 */
+ (NSMutableArray *)returnPayInfoArrWith:(NSArray *)dataArr;
+ (instancetype)returnModelWith:(NSDictionary *)dict;





@end
