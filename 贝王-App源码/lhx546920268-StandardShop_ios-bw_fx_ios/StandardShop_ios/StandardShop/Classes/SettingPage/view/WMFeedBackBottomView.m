//
//  WMFeedBackBottomView.m
//  WanShoes
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFeedBackBottomView.h"

@implementation WMFeedBackBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, _separatorLineWidth_)];
        
        lineView.backgroundColor = _separatorLineColor_;
        
        [self addSubview:lineView];
        
        CGFloat margin = 10.0;
        
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(margin,(frame.size.height - WMLongButtonHeight) / 2.0, _width_ - 2 * margin, WMLongButtonHeight)];
        
        [commitButton setTitleColor:WMButtonTitleColor forState:UIControlStateNormal];
        
        commitButton.backgroundColor = WMButtonBackgroundColor;
        
        commitButton.layer.cornerRadius = WMLongButtonCornerRaidus;
                
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        
        [commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:commitButton];
    }
    
    return self;
}

- (void)commitButtonAction:(UIButton *)button{
    
    if (self.actionCallBack) {
        
        self.actionCallBack();
    }
    
}
@end
