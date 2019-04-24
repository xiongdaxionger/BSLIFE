//
//  WMFilterCollectionNameViewCell.m
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFilterCollectionNameViewCell.h"

@implementation WMFilterCollectionNameViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.filterNameLabel.font = WMFilterCollectionNameViewCellFont;
}

- (void)configureWithFilterName:(NSString *)name{
    
    self.filterNameLabel.text = name;
}

- (void)setSelectStatus:(BOOL)selectStatus{
    
    self.contentView.backgroundColor = selectStatus ? WMButtonBackgroundColor : [UIColor clearColor];
    self.filterNameLabel.textColor = selectStatus ? WMButtonTitleColor : [UIColor blackColor];
}

@end
