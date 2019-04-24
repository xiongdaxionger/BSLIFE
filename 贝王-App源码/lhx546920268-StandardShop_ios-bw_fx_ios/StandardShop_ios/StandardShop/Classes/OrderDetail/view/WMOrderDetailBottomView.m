//
//  WMOrderDetailBottomView.m
//  AKYP
//
//  Created by 罗海雄 on 16/1/20.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMOrderDetailBottomView.h"
#import "UIView+XQuickControl.h"

#import "WMOrderdetailInfo.h"

#define WMButtonWidth 74.0
#define WMButtonHeight 26.0
#define WMButtonMargin 8.0

typedef void(^buttonActionCallBack)(void);

@implementation WMOrderDetailBottomView
- (instancetype)initWithFrame:(CGRect)frame orderInfo:(WMOrderDetailInfo *)info{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
        
        lineView.backgroundColor = _separatorLineColor_;
        
        [self addSubview:lineView];
        
        WeakSelf(self);
        
        UIButton *cancelButton = [self returnButtonWithTitle:@"取消订单" titleColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] actionCallBakc:^{
            
            if (weakSelf.cancelOrderButtonClick) {
                
                weakSelf.cancelOrderButtonClick();
            }
        }];
        
        cancelButton.hidden = YES;
        
        
        UIButton *payButton = [self returnButtonWithTitle:info.mainButtonTitle titleColor:WMRedColor backgroundColor:[UIColor colorWithR:254 G:238 B:238 a:1.0] actionCallBakc:^{
            
            if (self.payOrderButtonClick) {
                
                self.payOrderButtonClick();
            }
        }];
        
        payButton.hidden = YES;
        
        UIButton *confirmButton = [self returnButtonWithTitle:@"确认订单" titleColor:WMRedColor backgroundColor:[UIColor colorWithR:254 G:238 B:238 a:1.0] actionCallBakc:^{
            
            if (self.confirmOrderButtonClick) {
                
                self.confirmOrderButtonClick();
            }
        }];
        
        confirmButton.hidden = YES;
        
        UIButton *checkExpressButton = [self returnButtonWithTitle:@"查看物流" titleColor:WMRedColor backgroundColor:[UIColor colorWithR:254 G:238 B:238 a:1.0] actionCallBakc:^{
            
            if (self.checkExpressButtonClick) {
                
                self.checkExpressButtonClick();
            }
        }];
        
        checkExpressButton.hidden = YES;
        
        UIButton *deleteButton = [self returnButtonWithTitle:@"删除订单" titleColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] actionCallBakc:^{
            
            if (self.deleteOrderButtonClick) {
                
                self.deleteOrderButtonClick();
            }
        }];
        
        deleteButton.hidden = YES;
        
        UIButton *buyAgainButton = [self returnButtonWithTitle:@"再次购买" titleColor:WMRedColor backgroundColor:[UIColor colorWithR:254 G:238 B:238 a:1.0] actionCallBakc:^{
            
            if (self.buyAgainButtonClick) {
                
                self.buyAgainButtonClick();
            }
        }];
        
        buyAgainButton.hidden = YES;
        
        UIButton *checkCodeButton = [self returnButtonWithTitle:@"我要取货" titleColor:WMRedColor backgroundColor:[UIColor colorWithR:254 G:238 B:238 a:1.0] actionCallBakc:^{
            
            if (self.checkSinceQRCodeClick) {
                
                self.checkSinceQRCodeClick();
            }
        }];
        
        checkCodeButton.hidden = YES;
        
        CGFloat buttonY = (frame.size.height - WMButtonHeight) / 2.0;
        
        if ([info.orderStatus isEqualToString:@"finish"] || info.status == OrderStatusComment) {
            
            buyAgainButton.hidden = NO;
            
            buyAgainButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth,buttonY , WMButtonWidth, WMButtonHeight);
        }
        else if ([info.orderStatus isEqualToString:@"dead"]){
            
            buyAgainButton.hidden = NO;
            
            deleteButton.hidden = NO;
            
            buyAgainButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth,buttonY , WMButtonWidth, WMButtonHeight);
            
            deleteButton.frame = CGRectMake(buyAgainButton.left - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
        }
        else{
            
            if (info.status == OrderStatusWaitPay || info.status == OrderStatusPartPay) {
                
                CGFloat payButtonWidth = [info.mainButtonTitle stringSizeWithFont:[UIFont fontWithName:MainFontName size:15.0] contraintWith:_width_].width + 20.0;
                
                if (info.isPrepare) {
                    
                    cancelButton.hidden = YES;
                    
                    payButton.hidden = NO;
                    
                    payButton.frame = CGRectMake(_width_ - WMButtonMargin - payButtonWidth, buttonY, payButtonWidth, WMButtonHeight);
                }
                else{
                    
                    if (info.canCancelOrder) {
                        
                        cancelButton.hidden = NO;
                        
                        if ([info.payAppID isEqualToString:@"-1"]) {
                            
                            cancelButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth,buttonY , WMButtonWidth, WMButtonHeight);
                        }
                        else{
                            
                            cancelButton.hidden = NO;
                            
                            payButton.hidden = NO;
                            
                            payButton.frame = CGRectMake(_width_ - WMButtonMargin - payButtonWidth, buttonY, payButtonWidth, WMButtonHeight);
                            
                            cancelButton.frame = CGRectMake(payButton.left - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
                        }
                    }
                    else{
                        
                        cancelButton.hidden = YES;
                        
                        buyAgainButton.hidden = NO;
                        
                        payButton.hidden = NO;
                        
                        payButton.frame = CGRectMake(_width_ - WMButtonMargin - payButtonWidth, buttonY, payButtonWidth, WMButtonHeight);
                        
                        buyAgainButton.frame = CGRectMake(payButton.left - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
                    }
                }
            }
            else if (info.status == OrderStatusWaitSend){
                
                BOOL showCheckCode = NO;
                
                if (info.isStoreAutoOrder && [info.selfMentionStatus isEqualToString:@"waiting"]) {
                    
                    checkCodeButton.hidden = NO;
                    
                    showCheckCode = YES;
                    
                    checkCodeButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth,buttonY , WMButtonWidth, WMButtonHeight);
                }
                
                buyAgainButton.hidden = NO;
                
                buyAgainButton.frame = CGRectMake(showCheckCode ? _width_ - 2 * WMButtonMargin - 2 * WMButtonWidth : _width_ - WMButtonMargin - WMButtonWidth,buttonY , WMButtonWidth, WMButtonHeight);
            }
            else if (info.status == OrderStatusWaitReceive || info.status == OrderStatusPartSend){
                
                confirmButton.hidden = NO;
                
                checkExpressButton.hidden = NO;
                
                buyAgainButton.hidden = info.isInitPointOrder;
                
                confirmButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
                
                checkExpressButton.frame = CGRectMake(confirmButton.left - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
                
                buyAgainButton.frame = CGRectMake(checkExpressButton.left - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
            }
            else if (info.status == OrderStatusAllGoodRefund || info.status == OrderStatusPartGoodRefund || info.status == OrderStatusShipFinish){
                
                checkExpressButton.hidden = [NSString isEmpty:info.deliveryID] ? YES : NO;
                
                checkExpressButton.frame = CGRectMake(_width_ - WMButtonMargin - WMButtonWidth, buttonY, WMButtonWidth, WMButtonHeight);
            }
        }
    }
    
    return self;
}

- (UIButton *)returnButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgrounColor actionCallBakc:(buttonActionCallBack)buttonAction{
    
    UIButton *button = [self addSystemButtonWithFrame:CGRectMake(0, 0, WMButtonWidth, WMButtonHeight) tittle:title action:^(id button) {
        
        buttonAction();
    }];
    
    button.backgroundColor = backgrounColor;
    
    button.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    button.layer.borderColor = titleColor.CGColor;
    
    button.layer.borderWidth = 1.0;
    
    button.layer.cornerRadius = WMLongButtonCornerRaidus;
    
    return  button;
}




@end
