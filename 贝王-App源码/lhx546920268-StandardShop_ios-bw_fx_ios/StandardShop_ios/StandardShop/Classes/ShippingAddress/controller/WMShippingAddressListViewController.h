//
//  WMShippingAddressListViewController.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/22.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMShippingAddressDelegate.h"
#import "WMShippingAddressOperation.h"


@interface WMShippingAddressListViewController : SeaTableViewController

/**选中的收货地址信息
 */
@property(nonatomic,strong) WMShippingAddressInfo *selectedAddrInfo;

/**是否可以选中收货地址，default is 'NO'
 */
@property(nonatomic,assign) BOOL wantSelectInfo;

/**收货地址信息，数组元素是 WMShippingAddressInfo
 * 在确认订单中选择收货地址时，最好保存已加载的收货地址信息，防止第二次选择时重新加载，可传一个 strong的属性
 */
@property(nonatomic,strong) NSMutableArray *shippingInfos;
/**会员ID
 */
@property (copy,nonatomic) NSString *memberID;

@end
