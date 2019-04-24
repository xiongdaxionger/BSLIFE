//
//  WMConfirmOrderCustomerTableViewCell.m
//  StandardShop
//
//  Created by Hank on 16/11/8.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMConfirmOrderCustomerTableViewCell.h"

@implementation WMConfirmOrderCustomerTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.tipLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    [self.needSwitch addTarget:self action:@selector(changeSwitchStatus:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model{

    
}

- (void)changeSwitchStatus:(UISwitch *)sender{
    
    if (self.switchCallBack) {
        
        self.switchCallBack(sender.isOn);
    }
}

@end
