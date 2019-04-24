//
//  WMTopupActivityViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMTopupInfo;

///充值活动，充值有礼
@interface WMTopupActivityViewController : SeaTableViewController

/**充值信息
 */
@property(nonatomic,strong) WMTopupInfo *topupInfo;

@end
