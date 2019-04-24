//
//  WMStoreListViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreListViewCell.h"

#import "WMStoreListInfo.h"
@implementation WMStoreListViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setInfo:(WMStoreListInfo *)info {
    
    if (_info != info) {
        
        _info = info;
        
        self.storeNameLabel.text = info.name;
        
        self.addressLabel.text = info.completeAddress;
        
        self.distanceLabel.text = [NSString isEmpty:info.distance] ? @"无距离信息" : info.distance;
        
        self.contactLabel.text = [NSString stringWithFormat:@"%@ %@",info.uname,info.mobile];
    }
}

#pragma mark - 点击事件
- (IBAction)locationButtonAction:(UIButton *)sender {
    
    !self.locationCallBack ? : self.locationCallBack(self.info);
}

- (IBAction)phoneButtonAction:(UIButton *)sender {
    
    !self.phoneCallBack ? : self.phoneCallBack(self.info);
}
@end
