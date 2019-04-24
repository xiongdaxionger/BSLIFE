//
//  WMShippingTipViewCell.m
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippingTipViewCell.h"
#import "WMShippingMethodInfo.h"
@implementation WMShippingTipViewCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tittleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    
    self.expressProtectInfoLabel.font = [UIFont fontWithName:MainFontName size:13.0];
    
    self.expressProtectInfoLabel.textColor = MainTextColor;
    
    [self.expressProtectButton addTarget:self action:@selector(selectExpressProtect) forControlEvents:UIControlEventTouchUpInside];
    
    self.expressProtectInfoLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectExpressProtect)];
    
    [self.expressProtectInfoLabel addGestureRecognizer:tap];
    
    [self.expressProtectButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [self.expressProtectButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
}

- (void)configureWithString:(WMShippingMethodInfo *)model{
    
    self.tittleLabel.text = model.methodName;
    
    self.rightArrowImage.hidden = YES;
    
    self.expressProtectButton.hidden = YES;
    
    self.expressProtectInfoLabel.hidden = YES;
}

- (void)selectExpressProtect{
    
    if (self.expressProtectButton.selected) {
        
        if ([self.delegate respondsToSelector:@selector(unSelectExpressProtectCell:)]) {
            
            [self.delegate unSelectExpressProtectCell:self];
        }
    }
    else{
        
        if ([self.delegate respondsToSelector:@selector(selectExpressProtectSelectCell:)]) {
            
            [self.delegate selectExpressProtectSelectCell:self];
        }
    }
}

@end
