//
//  WMOrderWaitPayViewCell.m
//  AKYP
//
//  Created by mac on 15/11/28.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMOrderWaitPayViewCell.h"
#import "WMOrderInfo.h"
#import "WMOrderCenterViewController.h"

@interface WMOrderWaitPayViewCell ()
/**订单模型
 */
@property (strong,nonatomic) WMOrderInfo *viewModel;
/**订单列表
 */
@property (weak,nonatomic) WMOrderCenterViewController *orderController;
@end

@implementation WMOrderWaitPayViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyAgainButton addTarget:self action:@selector(buyAgainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_payButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    [_buyAgainButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    _cancelButton.layer.borderWidth = 1.0;
    
    _cancelButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    _payButton.layer.borderColor = WMPriceColor.CGColor;
    
    _payButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    _payButton.layer.borderWidth = 1.0;
    
    _buyAgainButton.layer.borderColor = WMPriceColor.CGColor;
    
    _buyAgainButton.layer.borderWidth = 1.0;
    
    _buyAgainButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
}

- (void)configureCellWithModel:(id)model{
    
    _viewModel = [model objectForKey:kModelKey];
    
    _orderController = [model objectForKey:kControllerKey];
    
    [self.payButton setTitle:self.viewModel.mainButtonTitle forState:UIControlStateNormal];
    
    _payButton.hidden = NO;
    
    if (_viewModel.isPrepareOrder) {
        
        if (_viewModel.status == OrderStatusWaitPay || _viewModel.status == OrderStatusPartPay) {
            
            _cancelButton.hidden = YES;
            
            _buyAgainButton.hidden = YES;
            
            _payButton.hidden = NO;
            
            self.payButtonRight.constant = 8.0;
            
            self.payButtonWidth.constant = MAX(74.0, [self.viewModel.mainButtonTitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - 2 * 8.0].width + 20.0);
        }
        else{
            
            _cancelButton.hidden = YES;
            
            _buyAgainButton.hidden = YES;
            
            _payButton.hidden = YES;
        }
    }
    else{
        
        if (_viewModel.canCancelOrder) {
            
            _buyAgainButton.hidden = YES;
            
            _cancelButton.hidden = NO;
            
            if ([_viewModel.payAppID isEqualToString:@"-1"]) {
                
                self.payButtonWidth.constant = CGFLOAT_MIN;
                
                self.payButtonRight.constant = CGFLOAT_MIN;
            }
            else{
                
                self.payButtonRight.constant = 8.0;
                
                self.payButtonWidth.constant = MAX(74.0, [self.viewModel.mainButtonTitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - 2 * 8.0].width + 20.0);
            }
        }
        else{
            
            _cancelButton.hidden = YES;
            
            _buyAgainButton.hidden = NO;
            
            self.payButtonWidth.constant = MAX(74.0, [self.viewModel.mainButtonTitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_ - 2 * 8.0].width + 20.0);
        }
    }
}

- (void)payButtonClick:(UIButton *)button{
    
    [_orderController payOrderWithInfo:_viewModel Cell:self];
}
- (void)cancelButtonClick:(UIButton *)button{
    
    if (self.viewModel.canCancelOrder) {
        
        [_orderController cancelOrderWithInfo:_viewModel Cell:self];
    }
    else{
        
        [_orderController buyAgainWithInfo:_viewModel Cell:self];
    }
}

- (void)buyAgainButtonClick:(UIButton *)button{
    
    [_orderController buyAgainWithInfo:_viewModel Cell:self];
}



@end
