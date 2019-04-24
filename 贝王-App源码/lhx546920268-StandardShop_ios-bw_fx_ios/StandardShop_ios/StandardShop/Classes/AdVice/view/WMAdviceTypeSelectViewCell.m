//
//  WMAdviceTypeSelectViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMAdviceTypeSelectViewCell.h"

#import "WMAdviceTypeInfo.h"
@implementation WMAdviceTypeSelectViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _adviceTypeNameLabel.font = [UIFont fontWithName:MainFontName size:15];
    
    _adviceSelectButton.enabled = NO;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureAdviceTypeInfo:(WMAdviceTypeInfo *)info{
    
    _adviceTypeNameLabel.text = info.adviceTypeName;
    
    if (info.adviceTypeIsSelect) {
        
        [_adviceSelectButton setBackgroundImage:[WMImageInitialization tickingIcon] forState:UIControlStateDisabled];
    }
    else{
        
        [_adviceSelectButton setBackgroundImage:[WMImageInitialization untickIcon] forState:UIControlStateDisabled];
    }
}










@end
