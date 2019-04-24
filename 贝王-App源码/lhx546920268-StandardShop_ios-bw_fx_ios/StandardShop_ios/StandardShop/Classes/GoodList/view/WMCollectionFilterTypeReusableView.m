//
//  WMCollectionFilterTypeReusableView.m
//  StandardFenXiao
//
//  Created by mac on 16/1/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMCollectionFilterTypeReusableView.h"

#import "WMGoodFilterModel.h"

@implementation WMCollectionFilterTypeReusableView

- (void)awakeFromNib {

    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownButtonAction:)];
    
    [self addGestureRecognizer:tap];
    
    [self.filterButton addTarget:self action:@selector(dropDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.filterTypeLabel.font = [UIFont fontWithName:MainFontName size:14.0];
    [self.filterButton setImage:[UIImage imageNamed:@"arrow_down_square"] forState:UIControlStateNormal];
    [self.filterButton setImage:[UIImage imageNamed:@"arrow_up_square"] forState:UIControlStateSelected];
}

- (void)dropDownButtonAction:(UITapGestureRecognizer *)tap{

    self.filterButton.selected = !self.filterButton.selected;
    self.model.isDrop = !self.model.isDrop;
    if ([self.delegate respondsToSelector:@selector(collectionFilterTypeReusableViewButtonClick:)]) {
        
        [self.delegate collectionFilterTypeReusableViewButtonClick:self];
    }
}

- (void)configureFilterType:(WMGoodFilterModel *)model{
    
    self.filterTypeLabel.text = model.filterTypeName;
    self.filterButton.selected = model.isDrop;
    self.model = model;
}




@end
