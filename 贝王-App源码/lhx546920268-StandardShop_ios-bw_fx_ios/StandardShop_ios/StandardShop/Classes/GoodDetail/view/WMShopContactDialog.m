//
//  WMShopContactDialog.m
//  StandardShop
//
//  Created by Hank on 16/11/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShopContactDialog.h"

#import "WMShopContactInfo.h"

//边距
#define WMShopContactDialogMargin 15.0

@interface WMShopContactDialog()

@end

@implementation WMShopContactDialog
/**初始化
 */
- (id)init
{
    CGFloat margin = WMShopContactDialogMargin;
    
    CGFloat width = _width_ - margin * 2;
    
    CGFloat buttonHeight = 49.0;
    
    CGFloat buttonWidth = width / 2.0;
    
    WMShopContactInfo *info = [WMShopContactInfo shareInstance];
    
    CGFloat infoHegiht = [[AppDelegate instance].isLogin ? info.upLineAttrString : info.attrString boundsWithConstraintWidth:width - 2 * margin].height + 1.0;
    
    CGFloat height = infoHegiht + buttonHeight + 25.0 + 4 * margin;
    
    self = [super initWithFrame:CGRectMake(margin, (_height_ - height) / 2.0, width, height)];
    
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 5.0;
        
        self.layer.masksToBounds = YES;
        
        ///分段选择
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMShopContactDialogMargin * 2, WMShopContactDialogMargin, width - 4 * WMShopContactDialogMargin, 25.0)];
        headerLabel.text = @"上级联系信息";
        headerLabel.textColor = WMRedColor;
        headerLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:headerLabel];
        
        UIButton *closeDialog = [[UIButton alloc] initWithFrame:CGRectMake(width - 30.0, headerLabel.top, 25.0, 25.0)];
        [closeDialog setBackgroundImage:[UIImage imageNamed:@"close_dialog"] forState:UIControlStateNormal];
        closeDialog.contentMode = UIViewContentModeCenter;
        [closeDialog addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeDialog];
        
        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerLabel.bottom + margin, width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        //联系人信息
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(WMShopContactDialogMargin, line.bottom + margin, width - 2 * margin, infoHegiht)];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.numberOfLines = 0;
        infoLabel.attributedText = [AppDelegate instance].isLogin ? info.upLineAttrString : info.attrString;
        [self addSubview:infoLabel];

        //新建到联系人按钮
        UIButton *saveNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveNewButton setTitle:@"保存新联系人" forState:UIControlStateNormal];
        [saveNewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [saveNewButton addTarget:self action:@selector(createNewContact) forControlEvents:UIControlEventTouchUpInside];
        saveNewButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        saveNewButton.frame = CGRectMake(0, infoLabel.bottom + margin, buttonWidth, buttonHeight);
        [self addSubview:saveNewButton];
        
        ///保存现有联系人按钮
        UIButton *saveCurrentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveCurrentButton setTitle:@"保存现有联系人" forState:UIControlStateNormal];
        [saveCurrentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [saveCurrentButton addTarget:self action:@selector(saveCurrentContact) forControlEvents:UIControlEventTouchUpInside];
        saveCurrentButton.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
        saveCurrentButton.frame = CGRectMake(saveNewButton.right, infoLabel.bottom + margin, buttonWidth, buttonHeight);
        [self addSubview:saveCurrentButton];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, saveNewButton.top - _separatorLineWidth_, width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(saveNewButton.right, saveNewButton.top, _separatorLineWidth_, saveNewButton.height)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];

        self.showAnimate = SeaDialogAnimateScale;
    }
    
    return self;
}

- (void)createNewContact{
    
    [self dismiss];
    
    self.contactCallBack(NO);
}

- (void)saveCurrentContact{

    [self dismiss];
    
    self.contactCallBack(YES);
}















@end
