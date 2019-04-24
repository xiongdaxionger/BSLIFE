//
//  WMCategoryBrandViewController.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/3/31.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

///分类和品牌容器
@interface WMCategoryBrandViewController : SeaViewController<UISearchBarDelegate>

///跳到对应的界面 0分类，1品牌馆
- (void)showViewAtIndex:(NSInteger) index;

@end
