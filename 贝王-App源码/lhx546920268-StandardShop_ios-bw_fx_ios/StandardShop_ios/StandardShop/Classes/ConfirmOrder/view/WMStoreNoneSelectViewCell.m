//
//  WMStoreNoneSelectViewCell.m
//  StandardShop
//
//  Created by Hank on 2018/6/11.
//  Copyright © 2018年 qianseit. All rights reserved.
//

#import "WMStoreNoneSelectViewCell.h"

@implementation WMStoreNoneSelectViewCell

- (void)awakeFromNib {

    [super awakeFromNib];

    self.contentView.backgroundColor = _SeaViewControllerBackgroundColor_;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCellWithModel:(id)model {
    
}

@end
