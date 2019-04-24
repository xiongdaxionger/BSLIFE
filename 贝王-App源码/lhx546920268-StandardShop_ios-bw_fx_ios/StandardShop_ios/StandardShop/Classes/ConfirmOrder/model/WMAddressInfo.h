//
//  WMAddressModel.h
//  StandardFenXiao
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMShippingAddressInfo;
/**确认订单的地址信息模型
 */
@interface WMAddressInfo : NSObject
/**地址的ID
 */
@property (copy,nonatomic) NSString *addressID;
/**地址的区域ID
 */
@property (copy,nonatomic) NSString *addressAreaID;
/**地址的区域信息
 */
@property (copy,nonatomic) NSString *addressAreaInfo;
/**地址的收货人名称
 */
@property (copy,nonatomic) NSString *addressName;
/**地址的详细信息
 */
@property (copy,nonatomic) NSString *addressDetail;
/**地址的收货人电话
 */
@property (copy,nonatomic) NSString *addressMobile;
/**地址的JSON字符串
 */
@property (copy,nonatomic) NSString *addressJsonValue;
/**批量初始化
 */
+ (NSMutableArray *)returnAddressInfosArrWithDictArr:(NSArray *)dictArr;
/**初始化
 */
+ (instancetype)returnAddressInfoWithDict:(NSDictionary *)dict;
/**订单详情的地址初始化
 */
+ (instancetype)returnOrderDetailAddressInfoWithDict:(NSDictionary *)dict;
/**通过ShippingInfo初始化
 */
+ (instancetype)createModelWithShipInfo:(WMShippingAddressInfo *)info;
/**初始化WMShippingAddressInfo
 */
- (WMShippingAddressInfo *)createInfo;
@end
