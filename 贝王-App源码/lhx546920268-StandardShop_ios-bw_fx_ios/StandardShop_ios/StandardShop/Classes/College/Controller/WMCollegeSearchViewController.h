//
//  WMCollegeSearchViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMPushSearchViewController.h"

@class WMCollegeCategoryInfo;

///学院信息搜索
@interface WMCollegeSearchViewController : WMPushSearchViewController

///分类Id , 传全部分类
@property(nonatomic,strong) WMCollegeCategoryInfo *categoryInfo;

@end
