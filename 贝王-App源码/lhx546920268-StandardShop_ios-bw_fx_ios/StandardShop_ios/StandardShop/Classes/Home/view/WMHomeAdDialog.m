//
//  WMHomeAdDialog.m
//  StandardShop
//
//  Created by Hank on 2018/6/6.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMHomeAdDialog.h"

@implementation WMHomeAdDialog

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.adImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdAction)];
    
    [self.adImageView addGestureRecognizer:tap];
}

- (instancetype)init {
    
    WMHomeAdDialog *view = [[[NSBundle mainBundle] loadNibNamed:@"WMHomeAdDialog" owner:nil options:nil] lastObject];
    
    CGFloat imageHeight = (4 * (_width_ - 100.0) / 3.0);
    
    CGFloat dialogHeight = imageHeight + 54.0;
    
    view.frame = CGRectMake(50.0, (_height_ - dialogHeight) / 2.0, _width_ - 100.0, dialogHeight);
    
    view.showAnimate = SeaDialogAnimateScale;
    
    view.dismissAnimate = SeaDialogAnimateNone;
    
    return view;
}

///点击事件
- (void)tapAdAction {
    
    WeakSelf(self);
    
    self.dialogViewController.previousPresentViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.dialogViewController dismissViewControllerAnimated:NO completion:^{
        
        !weakSelf.tapCallBack ? : weakSelf.tapCallBack();

    }];
}

- (IBAction)closeAction:(id)sender {
    
    [self setDismissCompletionHandler:nil];
    
    [self dismiss];
}

@end
