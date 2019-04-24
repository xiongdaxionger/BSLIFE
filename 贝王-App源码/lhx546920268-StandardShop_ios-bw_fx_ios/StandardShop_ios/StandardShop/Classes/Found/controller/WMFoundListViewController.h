//
//  WMFoundListViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/4/1.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaTableViewController.h"

@class WMFoundCategoryInfo;

///发现列表
@interface WMFoundListViewController : SeaTableViewController

///类目信息，数组元素是 WMFoundCategoryInfo
@property (strong, nonatomic) NSArray *infos;

///分类信息，如果不传，则查看所有发现信息
@property(nonatomic,strong) WMFoundCategoryInfo *categorInfo;

///下标
@property(nonatomic,assign) NSInteger index;

@end
