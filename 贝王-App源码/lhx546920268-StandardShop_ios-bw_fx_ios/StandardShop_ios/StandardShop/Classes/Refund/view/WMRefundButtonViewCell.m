//
//  WMRefundButtonViewCell.m
//  WanShoes
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundButtonViewCell.h"
#import "WMRefundOrderViewController.h"
#import "WMRefundGoodRecordViewController.h"
#import "WMOrderInfo.h"
#import "WMRefundGoodRecordModel.h"

@interface WMRefundButtonViewCell ()
/**退货换/退款列表
 */
@property (weak,nonatomic) WMRefundOrderViewController *refundOrderController;
/**退货列表
 */
@property (weak,nonatomic) WMRefundGoodRecordViewController *goodRecordController;
/**订单号
 */
@property (copy,nonatomic) NSString *orderID;
@end

@implementation WMRefundButtonViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.refundButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    self.refundButton.layer.borderColor = WMPriceColor.CGColor;
    
    self.refundButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    [self.refundButton addTarget:self action:@selector(refundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusLabel.font = self.refundButton.titleLabel.font;
}

- (void)configureCellWithModel:(id)model{
    
    UIColor *pinkColor = [UIColor colorWithR:254 G:238 B:238 a:1.0];
    
    self.statusLabel.hidden = YES;
    
    if ([model isKindOfClass:[NSString class]]) {
        
        [self.refundButton setBackgroundColor:[UIColor clearColor]];
        
        self.refundButton.layer.borderWidth = CGFLOAT_MIN;
        
        NSString *status = (NSString *)model;
        
        [self.refundButton setTitle:status forState:UIControlStateNormal];
    }
    else if ([model isKindOfClass:[NSDictionary class]]){
        
        NSNumber *isRecord = [model objectForKey:@"isRecord"];
        
        if (isRecord.boolValue) {
            
            WMRefundGoodRecordModel *goodRecordModel = [model objectForKey:@"model"];
            
            _buttonWidth.constant = 95;
            
            _goodRecordController = (WMRefundGoodRecordViewController *)[model objectForKey:@"controller"];
            
            if (goodRecordModel.canInputDelivery) {
                
                self.statusLabel.hidden = NO;
                
                self.statusLabel.text = @"审核通过";
                
                self.refundButton.enabled = YES;
                
                [self.refundButton setTitle:@"填写退货信息" forState:UIControlStateNormal];
                
                [self.refundButton setBackgroundColor:pinkColor];
                
                self.refundButton.layer.borderWidth = 1.0;
            }
            else{
                
                [self.refundButton setBackgroundColor:[UIColor clearColor]];
                
                self.refundButton.layer.borderWidth = CGFLOAT_MIN;
                
                self.refundButton.enabled = YES;
                
                [self.refundButton setTitle:goodRecordModel.status forState:UIControlStateNormal];
            }
        }
        else{
            
            _refundOrderController = (WMRefundOrderViewController *)[model objectForKey:kControllerKey];
            
            WMOrderInfo *orderViewModel = (WMOrderInfo *)[model objectForKey:kModelKey];
            
            _orderID = orderViewModel.orderID;
            
            if (orderViewModel.canOrderAffter) {
                
                _refundButton.enabled = YES;
                
                _buttonWidth.constant = 74;
                
                [_refundButton setBackgroundColor:pinkColor];
                
                self.refundButton.layer.borderWidth = 1.0;
                
                if ([_refundOrderController.refundType isEqualToString:@"refund"]) {
                    
                    [_refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
                }
                else{
                    
                    [_refundButton setTitle:@"申请售后" forState:UIControlStateNormal];
                }
            }
            else{
                
                _buttonWidth.constant = 85;
                
                _refundButton.backgroundColor = [UIColor clearColor];
                
                self.refundButton.layer.borderWidth = CGFLOAT_MIN;
                
                if ([_refundOrderController.refundType isEqualToString:@"refund"]) {
                    
                    [_refundButton setTitle:@"已申请退款" forState:UIControlStateNormal];
                }
                else{
                    
                    [_refundButton setTitle:@"已申请售后" forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)refundButtonClick:(UIButton *)button{
    
    if (self.refundOrderController) {
        
        if ([button.titleLabel.text isEqualToString:@"申请退款"]) {
            
            [_refundOrderController refundOrderWithOrderID:_orderID cell:self isGood:NO];
        }
        else if([button.titleLabel.text isEqualToString:@"申请售后"]){
            
            [_refundOrderController refundOrderWithOrderID:_orderID cell:self isGood:YES];
        }
        else{
            
            return;
        }
    }
    else{
        
        if ([button.titleLabel.text isEqualToString:@"填写退货信息"]) {
            
            [_goodRecordController showDeliveryDialogSelectCell:self];
        }
        else{
            
            return;
        }
    }
}

@end
