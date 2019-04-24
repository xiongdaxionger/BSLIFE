//
//  ConfirmOrderPayHeaderViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ConfirmOrderCommonHeaderViewCell.h"

#import "WMShippingMethodInfo.h"
#import "WMCouponsInfo.h"

@implementation ConfirmOrderCommonHeaderViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderInfoLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    _contentLabel.font = [UIFont fontWithName:MainFontName size:15];
}

- (void)configureCellWithModel:(id)model{
    
    if ([model isKindOfClass:[WMShippingMethodInfo class]]) {
        
        self.contentLabel.textColor = WMPriceColor;
        
        WMShippingMethodInfo *selectModel = (WMShippingMethodInfo *)model;
        
        self.orderInfoLabel.text = @"配送方式";
        
        if (selectModel.isExpressSelect) {
            
            self.contentLabel.text = [NSString stringWithFormat:@"%@(保价)",selectModel.methodName];
        }
        else{
            
            self.contentLabel.text = selectModel.methodName;
        }
        
        self.leftArrowImage.hidden = YES;
        
        self.contentLabel.hidden = NO;
    }
    else if ([model isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dict = (NSDictionary *)model;
        
        NSNumber *isContent = [dict numberForKey:@"isContent"];
        
        if (isContent.boolValue) {
            
            self.contentLabel.text = [dict sea_stringForKey:@"content"];
            
            self.leftArrowImage.hidden = NO;
            
            self.contentLabel.hidden = NO;
        }
        else{
            
            self.contentLabel.hidden = YES;
            
            self.leftArrowImage.hidden = YES;
        }
        
        NSString *tittle = [dict sea_stringForKey:@"tittle"];
        
        self.orderInfoLabel.text = tittle;
        
        if ([tittle isEqualToString:@"自提时间"] || [tittle isEqualToString:@"配送时间"]) {
            
            [self.leftArrowImage setImage:[UIImage imageNamed:@"arrow_down_square"]];
        }
        else{
            
            [self.leftArrowImage setImage:[UIImage imageNamed:@"arrow_gray"]];
        }
        
        if ([tittle isEqualToString:@"配送方式"]) {
            
            self.contentLabel.textColor = WMPriceColor;
        }
        else{
            
            self.contentLabel.textColor = [UIColor blackColor];
        }
    }
    else if ([model isKindOfClass:[WMCouponsInfo class]]){
        
        WMCouponsInfo *coupon = (WMCouponsInfo *)model;
        
        [self.leftArrowImage setImage:[UIImage imageNamed:@"arrow_gray"]];
        
        self.contentLabel.text = coupon.name;
        
        self.contentLabel.textColor = WMPriceColor;
        
        self.orderInfoLabel.text = @"优惠券";
    }
}










@end
