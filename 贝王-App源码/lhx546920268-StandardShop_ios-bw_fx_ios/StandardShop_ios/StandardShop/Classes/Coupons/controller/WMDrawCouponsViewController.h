//
//  WMDrawCouponsViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/1.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

///领券中心
@interface WMDrawCouponsViewController : SeaTableViewController

/**领取成功后的回调
 */
@property (copy,nonatomic) void(^getCouponSuccess)(void);

@end
