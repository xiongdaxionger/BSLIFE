//
//  WMInvioceTypeSelectViewCell.m
//  SuYan
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMInvioceTypeSelectViewCell.h"

#import "WMImageInitialization.h"

#import "WMInvioceViewController.h"

@interface WMInvioceTypeSelectViewCell ()
@property (weak,nonatomic) WMInvioceViewController *invioceController;
@end

@implementation WMInvioceTypeSelectViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    [self.unInvioceButton setTitleColor:WMPriceColor forState:UIControlStateSelected];
    
    [self.unInvioceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.personalButton setTitleColor:WMPriceColor forState:UIControlStateSelected];
    
    [self.personalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.companyButton setTitleColor:WMPriceColor forState:UIControlStateSelected];
    
    [self.companyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.unInvioceButton addTarget:self action:@selector(changeInvioceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.personalButton addTarget:self action:@selector(changeInvioceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.companyButton addTarget:self action:@selector(changeInvioceTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.unInvioceButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [self.unInvioceButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    [self.companyButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [self.companyButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
    
    [self.personalButton setImage:[WMImageInitialization tickingIcon] forState:UIControlStateSelected];
    
    [self.personalButton setImage:[WMImageInitialization untickIcon] forState:UIControlStateNormal];
}

- (void)configureCellWithModel:(id)model{
    
    _invioceController = [model objectForKey:kControllerKey];
    
    NSDictionary *dict = [model objectForKey:kModelKey];
    
    self.unInvioceButton.selected = [[dict numberForKey:@"un_invioce"] boolValue];
    
    self.companyButton.selected = [[dict numberForKey:@"company"] boolValue];
    
    self.personalButton.selected = [[dict numberForKey:@"person"] boolValue];
}

- (void)changeInvioceTypeButtonClick:(UIButton *)button{
    
    BOOL un_vioce = NO;
    
    BOOL person = NO;
    
    BOOL company = NO;
    
    if (button.tag == 1000) {
        
        self.unInvioceButton.selected = YES;
        
        self.companyButton.selected = NO;
        
        self.personalButton.selected = NO;
        
        un_vioce = YES;
        
        self.invioceController.isOpenInvioce = NO;
        
        self.invioceController.selectIndex = 0;
    }
    else if (button.tag == 1001){
        
        self.unInvioceButton.selected = NO;
        
        self.companyButton.selected = NO;
        
        self.personalButton.selected = YES;
        
        person = YES;
        
        self.invioceController.isOpenInvioce = YES;
        
        self.invioceController.selectIndex = 1;
    }
    else if (button.tag == 1002){
        
        self.unInvioceButton.selected = NO;
        
        self.companyButton.selected = YES;
        
        self.personalButton.selected = NO;
        
        company = YES;
        
        self.invioceController.isOpenInvioce = YES;
        
        self.invioceController.selectIndex = 2;
    }
    
    self.invioceController.selectStatus = @{@"un_invioce":@(un_vioce),@"person":@(person),@"company":@(company)};
    
    [self.invioceController.tableView reloadData];
}








@end
