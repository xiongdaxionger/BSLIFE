//
//  WMShippingAddressInfo.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMAreaInfo.h"
/**收货地址信息
 */
@interface WMShippingAddressInfo : NSObject<NSCopying>

/**地址 id
 */
@property(nonatomic,assign) long long Id;

/**确认订单需要的 区域id
 */
@property(nonatomic,readonly) NSString *areaId;

/**收货人
 */
@property(nonatomic,copy) NSString *consignee;

/**收货人联系号码
 */
@property(nonatomic,copy) NSString *phoneNumber;

/**固定电话
 */
@property(nonatomic,copy) NSString *telPhoneNumber;

/**显示的电话
 */
@property(nonatomic,readonly) NSString *displayPhoneNumber;

/**详细地址
 */
@property(nonatomic,copy) NSString *detailAddress;

/**地址组合
 */
@property(nonatomic,readonly) NSString *addressCombination;

/**省市区组合
 */
@property(nonatomic,copy) NSString *area;

/**用于上传的 省市区组合
 */
@property(nonatomic,copy) NSString *mainland;

/**是否是默认地址
 */
@property (assign,nonatomic) BOOL isDefaultAdr;

/**地址的JSON字符串
 */
@property (copy,nonatomic) NSString *jsonValue;


@end
