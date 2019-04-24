//
//  ConfirmOrderMinusMoneyViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//
#import "ConfirmOrderMinusMoneyViewCell.h"

#import "WMConfirmOrderInfo.h"
#import "ConfirmOrderPageController.h"
#import "WMUserInfo.h"

@interface ConfirmOrderMinusMoneyViewCell ()
/**控制器
 */
@property (weak,nonatomic) ConfirmOrderPageController *controller;
@end

@implementation ConfirmOrderMinusMoneyViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_orderMinusSwitch setOn:NO animated:YES];
        
    _orderMinusMoneyLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    [_orderMinusSwitch addTarget:self action:@selector(orderSwitchChange:) forControlEvents:UIControlEventValueChanged];
}



- (void)configureCellWithModel:(id)model{
    
    WMConfirmOrderInfo *info = [model objectForKey:@"model"];
    
    _controller = [model objectForKey:@"controller"];
    
    _orderMinusMoneyLabel.text = [NSString stringWithFormat:@"可用积分%@，可抵扣%@元",[info.orderPointSettingDict sea_stringForKey:@"max_discount_value_point"],[info.orderPointSettingDict sea_stringForKey:@"max_discount_value_money"]];
    
    [_orderMinusSwitch setOn:info.isUsePoint animated:NO];
    
    [_orderMinusMoneyLabel adjustsFontSizeToFitWidth];
}

- (void)orderSwitchChange:(UISwitch *)switchTouch{
    
    if (switchTouch.on) {
            
        [_controller usePointWithIsUse:YES];
    }
    else{
       
        [_controller usePointWithIsUse:NO];
    }
}

@end
