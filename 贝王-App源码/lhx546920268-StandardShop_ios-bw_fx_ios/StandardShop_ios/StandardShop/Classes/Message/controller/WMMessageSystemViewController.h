//
//  WMMessageSystemViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMMessageCenterInfo;

///系统消息
@interface WMMessageSystemViewController : SeaTableViewController

///消息中心信息
@property(nonatomic,strong) WMMessageCenterInfo *info;

@end
