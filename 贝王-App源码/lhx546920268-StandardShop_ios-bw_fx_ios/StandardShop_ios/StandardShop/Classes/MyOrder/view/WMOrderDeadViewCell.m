//
//  WMOrderDeadViewCell.m
//  StandardShop
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMOrderDeadViewCell.h"

#import "WMOrderInfo.h"
#import "WMOrderCenterViewController.h"

@interface WMOrderDeadViewCell ()
/**订单模型
 */
@property (strong,nonatomic) WMOrderInfo *orderInfo;
/**订单列表
 */
@property (weak,nonatomic) WMOrderCenterViewController *orderController;
@end

@implementation WMOrderDeadViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyAgainButton addTarget:self action:@selector(buyAgainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyAgainButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
    
    _deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _deleteButton.layer.borderWidth = 1.0;
    
    _buyAgainButton.layer.borderWidth = 1.0;
    
    _buyAgainButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    _buyAgainButton.layer.borderColor = WMPriceColor.CGColor;
    
    _buyAgainButton.layer.borderWidth = 1.0;
    
    _deleteButton.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)configureCellWithModel:(id)model{
    
    _orderInfo = [model objectForKey:kModelKey];
    
    _orderController = [model objectForKey:kControllerKey];
}

- (void)deleteButtonClick:(UIButton *)button{
    
    [_orderController deleteOrderWithInfo:self.orderInfo Cell:self];
}

- (void)buyAgainButtonClick:(UIButton *)button{
    
    [_orderController buyAgainWithInfo:self.orderInfo Cell:self];
}





@end
