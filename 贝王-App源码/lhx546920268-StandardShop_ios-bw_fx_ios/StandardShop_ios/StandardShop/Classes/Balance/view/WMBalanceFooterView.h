//
//  WMBalanceFooterView.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/5.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBalanceInfo;

///大小
#define WMBalanceFooterViewSize CGSizeMake(_width_, 75.0)

@class WMBalanceFooterView;

///余额、钱包底部代理
@protocol WMBalanceFooterViewDelegate <NSObject>

///充值
- (void)balanceFooterViewDidTopup:(WMBalanceFooterView*) view;

///提现
- (void)balanceFooterViewDidWithdraw:(WMBalanceFooterView*) view;

@end

///余额、钱包底部
@interface WMBalanceFooterView : UICollectionReusableView

///提现
@property (weak, nonatomic) IBOutlet UIButton *withdraw_btn;

///提现宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withdraw_btn_widthLayoutConstraint;

///充值
@property (weak, nonatomic) IBOutlet UIButton *topup_btn;

///充值宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topup_btn_widthLayoutConstraint;

///余额信息
@property (strong, nonatomic) WMBalanceInfo *info;

@property (weak, nonatomic) id<WMBalanceFooterViewDelegate> delegate;

@end
