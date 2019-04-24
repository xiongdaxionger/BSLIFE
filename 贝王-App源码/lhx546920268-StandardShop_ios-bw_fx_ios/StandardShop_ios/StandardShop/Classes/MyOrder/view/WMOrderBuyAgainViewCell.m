//
//  WMOrderBuyAgainViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderBuyAgainViewCell.h"
#import "WMOrderInfo.h"
#import "WMOrderCenterViewController.h"

@interface WMOrderBuyAgainViewCell ()
/**订单模型
 */
@property (strong,nonatomic) WMOrderInfo *info;
/**订单类型
 */
@property (weak,nonatomic) WMOrderCenterViewController *orderController;
@end

@implementation WMOrderBuyAgainViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_buyAgainButton makeBorderWidth:1.0 Color:WMPriceColor CornerRadius:WMLongButtonCornerRaidus];
    
    [_buyAgainButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_sinceCodeButton makeBorderWidth:1.0 Color:WMPriceColor CornerRadius:WMLongButtonCornerRaidus];
    
    [_sinceCodeButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_buyAgainButton addTarget:self action:@selector(buyAgainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)configureCellWithModel:(id)model{
    
    _info = [model objectForKey:kModelKey];
    
    if (_info.isStoreAutoOrder && _info.status == OrderStatusWaitSend && [_info.selfMentionStatus isEqualToString:@"waiting"]) {
        
        self.sinceCodeRIght.constant = 8.0;
        
        self.sinceCodeWidth.constant = 74.0;
        
        self.sinceCodeButton.hidden = NO;
    }
    else {
        
        self.sinceCodeRIght.constant = 0.0;
        
        self.sinceCodeWidth.constant = 0.0;
        
        self.sinceCodeButton.hidden = YES;
    }
    
    _orderController = [model objectForKey:kControllerKey];
}

- (void)buyAgainButtonClick:(UIButton *)button{
    
    [_orderController buyAgainWithInfo:self.info Cell:self];
}

- (IBAction)sinceCodeButtonAction:(id)sender {
    
    [_orderController showSinceQRCodeWithSinceCode:_info.sinceCode];
    
}



@end
