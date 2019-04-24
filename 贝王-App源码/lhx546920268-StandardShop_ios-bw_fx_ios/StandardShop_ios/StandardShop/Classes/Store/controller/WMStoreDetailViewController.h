//
//  WMStoreDetailViewController.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMStoreListInfo;

///实体店详情
@interface WMStoreDetailViewController : SeaViewController

///构造方法
- (instancetype)initWithInfo:(WMStoreListInfo*) info;

@end
