//
//  WMPartnerOrderTimeHeader.h
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMOrderInfo;
///会员订单头部
@interface WMPartnerOrderTimeHeader : UITableViewHeaderFooterView

///订单时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

///状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

///实付款
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

///配置数据
- (void)configureWithOrderInfo:(WMOrderInfo *)info;

@end
