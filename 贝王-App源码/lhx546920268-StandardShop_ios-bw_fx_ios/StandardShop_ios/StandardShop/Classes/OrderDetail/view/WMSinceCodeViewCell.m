//
//  WMSinceCodeViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/6/20.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMSinceCodeViewCell.h"

@implementation WMSinceCodeViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.quantityLabel makeBorderWidth:0.0 Color:nil CornerRadius:self.quantityLabel.height / 2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model {
    
    NSDictionary *dict = (NSDictionary *)model;
    
    self.sinceCodeLabel.text = [NSString stringWithFormat:@"自提码:%@",[dict sea_stringForKey:@"code"]];
    
    self.quantityLabel.text = [dict sea_stringForKey:@"quantity"];
    
    NSString *status = [dict sea_stringForKey:@"status"];
            
    if ([status isEqualToString:@"stockup"]) {
        
        [self.outingButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.outingLabel.textColor = WMRedColor;
        
        [self.havePrepareButton makeBorderWidth:1.0 Color:[UIColor blackColor] CornerRadius:self.waitGetButton.height / 2.0];
        
        [self.havePrepareButton setTitle:@"2" forState:UIControlStateNormal];
        
        [self.waitGetButton makeBorderWidth:1.0 Color:[UIColor blackColor] CornerRadius:self.waitGetButton.height / 2.0];
        
        [self.waitGetButton setTitle:@"3" forState:UIControlStateNormal];
        
        [self.haveGetButton makeBorderWidth:1.0 Color:[UIColor blackColor] CornerRadius:self.haveGetButton.height / 2.0];

        [self.haveGetButton setTitle:@"4" forState:UIControlStateNormal];

        self.stepOneView.backgroundColor = [UIColor lightGrayColor];
        
        self.stepSecondView.backgroundColor = [UIColor lightGrayColor];
        
        self.stepThirdView.backgroundColor = [UIColor lightGrayColor];
        
    }
    else if ([status isEqualToString:@"waiting"]) {
        
        [self.outingButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.outingLabel.textColor = WMRedColor;
        
        [self.havePrepareButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.havePrepareLabel.textColor = WMRedColor;
        
        [self.waitGetButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.waitGetLabel.textColor = WMRedColor;
        
        [self.haveGetButton makeBorderWidth:1.0 Color:[UIColor blackColor] CornerRadius:self.haveGetButton.height / 2.0];
        
        [self.haveGetButton setTitle:@"4" forState:UIControlStateNormal];
        
        self.stepOneView.backgroundColor = WMRedColor;
        
        self.stepSecondView.backgroundColor = WMRedColor;
        
        self.stepThirdView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        
        [self.outingButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.outingLabel.textColor = WMRedColor;
        
        [self.havePrepareButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.havePrepareLabel.textColor = WMRedColor;
        
        [self.waitGetButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.waitGetLabel.textColor = WMRedColor;
        
        [self.haveGetButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateNormal];
        
        self.haveGetLaebl.textColor = WMRedColor;
        
        self.stepOneView.backgroundColor = WMRedColor;
        
        self.stepSecondView.backgroundColor = WMRedColor;
        
        self.stepThirdView.backgroundColor = WMRedColor;
    }
}

@end
