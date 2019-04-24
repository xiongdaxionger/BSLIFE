//
//  WMSearchAssociateViewController.h
//  StandardShop
//
//  Created by 罗海雄 on 16/8/18.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMSearchController;

///搜索联想控制器
@interface WMSearchAssociateViewController : SeaTableViewController

///关联的搜索控制器
@property(nonatomic,weak) WMSearchController *searchController;

///搜索联想 数组元素是 NSString
@property(nonatomic,strong) NSArray *infos;

///刷新关键字
- (void)refreshKey:(NSString*) key;

@end
