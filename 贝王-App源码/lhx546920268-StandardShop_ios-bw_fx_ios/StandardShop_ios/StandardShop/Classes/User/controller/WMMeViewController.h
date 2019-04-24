//
//  WMMeViewController.h
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "SeaCollectionViewController.h"

///我，个人中心
@interface WMMeViewController : SeaCollectionViewController

///是否需要改变状态栏样式 状态栏样式切换时会影响viewController的过度动画 default is 'YES'
@property(nonatomic,assign) BOOL shouldChangeStatusBarStyle;

@end
