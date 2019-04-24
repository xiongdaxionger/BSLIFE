//
//  WMSinceQRCodeView.m
//  StandardShop
//
//  Created by Hank on 2018/6/20.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMSinceQRCodeView.h"

@implementation WMSinceQRCodeView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)init {
    
    WMSinceQRCodeView *view = [[[NSBundle mainBundle] loadNibNamed:@"WMSinceQRCodeView" owner:nil options:nil] lastObject];
    
    view.frame = CGRectMake(50.0, (_height_ - 340.0) / 2.0, _width_ - 100.0, 340.0);
    
    view.showAnimate = SeaDialogAnimateScale;
    
    view.dismissAnimate = SeaDialogAnimateNone;
    
    return view;
}

///点击事件
- (IBAction)closeButtonAction:(id)sender {
    
    [self dismiss];
}



@end
