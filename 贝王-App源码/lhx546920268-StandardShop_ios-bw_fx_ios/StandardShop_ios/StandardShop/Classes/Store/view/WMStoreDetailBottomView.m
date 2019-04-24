//
//  WMStoreDetailBottomView.m
//  StandardShop
//
//  Created by Hank on 2018/6/12.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreDetailBottomView.h"

@implementation WMStoreDetailBottomView

- (instancetype)init {
    
    WMStoreDetailBottomView *view = [[[NSBundle mainBundle] loadNibNamed:@"WMStoreDetailBottomView" owner:nil options:nil] lastObject];
    
    view.autoresizingMask = UIViewAutoresizingNone;
    
    view.frame = CGRectMake(0, 0, _width_, 64.0);
    
    return view;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.shopLogo makeBorderWidth:1.0 Color:_SeaViewControllerBackgroundColor_ CornerRadius:6.0];
}

@end
