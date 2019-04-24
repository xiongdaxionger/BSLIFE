//
//  WMPayPageBottomView.m
//  StandardShop
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMPayPageBottomView.h"

@implementation WMPayPageBottomView

- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString isCombinationPay:(BOOL)isCombinationPay{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = _SeaViewControllerBackgroundColor_;
        
        self.payButton = [[UIButton alloc] initWithFrame:CGRectMake(WMBottomContentContentMargin, WMBottomTopMargin, _width_ - 2 * WMBottomContentContentMargin, WMBottomViewHeight - 2 * WMBottomTopMargin)];
        
        [self.payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self updateButtonTitleStatusWithTitle:titleString isCombinationPay:isCombinationPay];
        
        self.payButton.titleLabel.font = WMLongButtonTitleFont;
        
        self.payButton.layer.cornerRadius = WMLongButtonCornerRaidus;
        
        [self addSubview:self.payButton];
    }
    
    return self;
}

- (void)layOutUI{
    
    
}

- (void)payButtonClick:(UIButton *)button{
    
    if ([NSString isEmpty:self.titleString]) {
        
        return;
    }
    
    if (self.payButtonClick) {
        
        self.payButtonClick();
    }
}

- (void)updateButtonTitleStatusWithTitle:(NSString *)title isCombinationPay:(BOOL)isCombinationPay{
    
    self.titleString = title;
    
    self.isCombinationPay = isCombinationPay;
    
    if ([NSString isEmpty:self.titleString]) {
        
        if (isCombinationPay) {
            
            self.titleString = @"组合支付";
            
            self.payButton.enabled = YES;
        }
        else{
            
            self.payButton.enabled = NO;
        }
    }
    else{
        
        self.payButton.enabled = YES;
    }
    
    [self.payButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
    
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    self.payButton.backgroundColor = [NSString isEmpty:self.titleString] ? MainLightGrayColor : WMButtonBackgroundColor;
    
    [self.payButton setTitle:self.titleString forState:UIControlStateNormal];
    
    [self.payButton setTitle:@"无法支付" forState:UIControlStateDisabled];
}



@end
