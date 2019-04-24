//
//  WMDistributionHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/19.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMDistributionInfo;

///大小
#define WMDistributionHeaderViewSize CGSizeMake(_width_, 100.0)

///我的分销首页头部
@interface WMDistributionHeaderView : UICollectionReusableView

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///账单按钮
@property (weak, nonatomic) IBOutlet UIButton *bill_btn;

///余额
@property (weak, nonatomic) IBOutlet UILabel *balance_label;

///分销信息
@property (strong, nonatomic) WMDistributionInfo *info;

///跳转导航
@property (weak, nonatomic) UINavigationController *navigationController;

@end
