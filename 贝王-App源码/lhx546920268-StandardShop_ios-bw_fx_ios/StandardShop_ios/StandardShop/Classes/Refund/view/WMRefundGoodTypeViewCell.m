//
//  WMRefundGoodTypeViewCell.m
//  WanShoes
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMRefundGoodTypeViewCell.h"

#import "UITableViewCell+addLineForCell.h"
@implementation WMRefundGoodTypeViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.typeNameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
}


- (void)configureCellWithModel:(id)model{
    
    _selectButton.enabled = NO;
    
    _typeNameLabel.text = [model objectForKey:@"typeName"];
    
    NSNumber *isSelect = [model objectForKey:@"isSelect"];
    
    if (isSelect.boolValue) {
        
        [_selectButton setBackgroundImage:[WMImageInitialization tickingIcon] forState:UIControlStateDisabled];
    }
    else{
        
        [_selectButton setBackgroundImage:[WMImageInitialization untickIcon] forState:UIControlStateDisabled];
    }
}

@end
