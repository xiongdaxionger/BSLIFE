//
//  WMShippingMethodView.m
//  WanShoes
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShippingMethodView.h"

@interface WMShippingMethodView ()

@end

@implementation WMShippingMethodView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (44 - 21) / 2.0, 80, 21)];
        
        titleLabel.textColor = MainTextColor;
        
        titleLabel.text = @"配送方式";
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        
        [self addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(_width_ - 88, (44 - 21) / 2.0, 80, 21)];
        
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [cancelButton setTitleColor:WMPriceColor forState:UIControlStateNormal];
        
        cancelButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        
        [cancelButton addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelButton];
    }
    
    return self;
}

- (void)cancelSelect:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(shippingMethodViewCancelSelect)]) {
        
        [self.delegate shippingMethodViewCancelSelect];
    }
}














@end
