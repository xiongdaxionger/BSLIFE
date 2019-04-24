//
//  WMStoreListViewController.h
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMStoreListInfo;
///选择门店
@interface WMStoreListViewController : SeaTableViewController

///选择门店的回调
@property (copy,nonatomic) void(^selectStoreAddrCallBack)(WMStoreListInfo *info);
@end
