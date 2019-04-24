//
//  WMPartnerOrderListViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMPartnerDetailTableViewController.h"

/**会员 订单
 */
@interface WMPartnerOrderListViewController : WMPartnerDetailTableViewController

///是否是查看下线的下线
@property(nonatomic,assign) BOOL isSeeSecondReferral;

@end
