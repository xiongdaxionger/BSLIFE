//
//  WMFoundViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/21.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaViewController.h"

@class WMFoundCategoryInfo;

///发现
@interface WMFoundViewController : SeaViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

///要打开的发现栏目
@property(nonatomic,strong) WMFoundCategoryInfo *selectedFoundCategoryInfo;

///类目信息，数组元素是 WMFoundCategoryInfo
@property (strong, nonatomic) NSArray *infos;

@end
