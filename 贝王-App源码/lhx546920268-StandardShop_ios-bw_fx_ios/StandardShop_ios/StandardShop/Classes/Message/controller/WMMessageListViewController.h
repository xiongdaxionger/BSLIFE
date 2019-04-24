//
//  WMMessageListViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMMessageCenterInfo, WMMessageInfo;

///消息列表
@interface WMMessageListViewController : SeaTableViewController

///消息中心信息
@property(nonatomic,strong) WMMessageCenterInfo *info;

///消息 数组元素是 WMMessageInfo 或其子类
@property(nonatomic,strong) NSMutableArray *infos;

///消息标记成已读
- (void)markReadMessageInfo:(WMMessageInfo*) info;

@end
