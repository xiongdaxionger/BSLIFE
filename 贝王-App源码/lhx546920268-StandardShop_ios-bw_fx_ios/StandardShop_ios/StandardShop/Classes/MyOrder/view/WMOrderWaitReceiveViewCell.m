//
//  WMOrderWaitReceiveViewCell.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderWaitReceiveViewCell.h"
#import "WMOrderInfo.h"
#import "WMOrderCenterViewController.h"

@interface WMOrderWaitReceiveViewCell ()
/**订单模型
 */
@property (strong,nonatomic) WMOrderInfo *viewModel;
/**订单列表
 */
@property (weak,nonatomic) WMOrderCenterViewController *orderController;
@end

@implementation WMOrderWaitReceiveViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_orderReceiveButton addTarget:self action:@selector(confirmReceiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_orderReceiveButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    _orderReceiveButton.layer.borderWidth = 1.0;
    
    _orderReceiveButton.layer.borderColor = WMPriceColor.CGColor;
    
    _orderReceiveButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    _checkExpressButton.layer.borderColor = WMPriceColor.CGColor;

    _checkExpressButton.layer.borderWidth = 1.0;
    
    _checkExpressButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    [_checkExpressButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_checkExpressButton addTarget:self action:@selector(checkExpressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _buyAgainButton.layer.borderColor = WMPriceColor.CGColor;
    
    _buyAgainButton.layer.borderWidth = 1.0;
    
    _buyAgainButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    [_buyAgainButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_buyAgainButton addTarget:self action:@selector(buyAgainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureCellWithModel:(id)model{
    
    _viewModel = [model objectForKey:kModelKey];
    
    _orderController = [model objectForKey:kControllerKey];
    
    _buyAgainButton.hidden = _viewModel.isInitPointOrder;
    
    if ([_viewModel.payAppID isEqualToString:@"-1"]) {
        
        _orderReceiveButtonRight.constant = CGFLOAT_MIN;
        
        _orderReceiveButtonWidth.constant = CGFLOAT_MIN;
    }
    else{
        
        _orderReceiveButtonWidth.constant = 74.0;
        
        _orderReceiveButtonRight.constant = 8.0;
    }
}

- (void)confirmReceiveButtonClick:(UIButton *)button{
    
    [_orderController confirmOrderWithInfo:self.viewModel Cell:self];
}

- (void)checkExpressButtonClick:(UIButton *)button{
    
    [_orderController checkOrderExpressWithInfo:self.viewModel Cell:self];
}

- (void)buyAgainButtonClick:(UIButton *)button{
    
    [_orderController buyAgainWithInfo:self.viewModel Cell:self];
}

@end
