//
//  WMStoreSelectedViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreSelectedViewCell.h"

#import "WMStoreListInfo.h"
@implementation WMStoreSelectedViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = _SeaViewControllerBackgroundColor_;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model {
    
    WMStoreListInfo *info = (WMStoreListInfo *)model;
    
    self.nameLabel.text = info.name;
    
    self.addressLabel.text = info.completeAddress;
    
}

@end
