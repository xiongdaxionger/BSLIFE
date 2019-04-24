//
//  WMPartnerOrderTimeHeader.m
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMPartnerOrderTimeHeader.h"

#import "WMOrderInfo.h"
@implementation WMPartnerOrderTimeHeader

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)configureWithOrderInfo:(WMOrderInfo *)info {
    
    self.timeLabel.text = info.orderCreateTime;
    
    self.statusLabel.text = info.orderStatusTitle;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"实付款:%@",info.orderTotalMoney];
}
@end
