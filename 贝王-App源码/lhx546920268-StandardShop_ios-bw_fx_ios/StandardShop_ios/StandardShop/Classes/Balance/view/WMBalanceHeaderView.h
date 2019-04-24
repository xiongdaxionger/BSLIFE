//
//  WMBalanceHeaderView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBalanceInfo;

///高度
#define WMBalanceHeaderViewSize(arg) CGSizeMake(_width_, (arg ? 135.0 : 100.0))

///余额、钱包头部
@interface WMBalanceHeaderView : UICollectionReusableView

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///账单按钮
@property (weak, nonatomic) IBOutlet UIButton *bill_btn;

///余额
@property (weak, nonatomic) IBOutlet UILabel *balance_label;

///佣金
@property (weak, nonatomic) IBOutlet UILabel *commission_label;

///余额信息
@property (strong, nonatomic) WMBalanceInfo *info;

@property (weak, nonatomic) UINavigationController *navigationController;

///过渡动画
@property(nonatomic,strong) SeaPresentTransitionDelegate *presentTransitionDelegate;

@end
