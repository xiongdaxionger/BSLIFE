//
//  WMShippingAddressDelegate.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMShippingAddressInfo.h"

/**收货地址操作完成通知 ，主要用于订单确认 和 收货地址列表 userInfo 中有两个值, WMShippingAddressInfo， key 是 WMShippingAddressOperaionInfo , [NSNumber numberWithInteger:WMShippingAddressOperationStyle], key;
 */
static NSString* const WMShippingAddressOperaionDidFinishNotification = @"WMShippingAddressOperaionDidFinishNotification";

/**收货地址信息
 */
static NSString* const WMShippingAddressOperaionInfo = @"info";

/**操作类型
 */
static NSString* const WMShippingAddressOperationType = @"type";


/**收货地址操作类型
 */
typedef NS_ENUM(NSInteger, WMShippingAddressOperationStyle)
{
    WMShippingAddressOperationSelected = 0, ///选择收货地址
    WMShippingAddressOperationDeleted, ///删除收货地址
    WMShippingAddressOperationModified, ///修改收货地址
    WMShippingAddressOperationAdded ///新增收货地址
};

