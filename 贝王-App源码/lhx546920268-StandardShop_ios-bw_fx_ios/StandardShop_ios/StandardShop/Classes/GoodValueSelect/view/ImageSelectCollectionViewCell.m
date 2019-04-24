//
//  ImageSelectCollectionViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ImageSelectCollectionViewCell.h"

#import "UIView+XQuickStyle.h"
#import "WMGoodDetailSpecInfo.h"

@implementation ImageSelectCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    [_valuesImage makeCornerRadiusWithValue:_valuesImage.frame.size.height / 2];
    
//    _valuesImage.clipsToBounds = YES;
    
    _valuesImage.layer.cornerRadius = _valuesImage.frame.size.height / 2;
    
    _valuesNameLabel.font = [UIFont fontWithName:MainFontName size:12];
    
    _valuesImage.sea_originContentMode = UIViewContentModeScaleAspectFit;
}
- (void)configureWithModel:(id)model{
    
    WMGoodDetailSpecValueInfo *viewModel = (WMGoodDetailSpecValueInfo *)model;
    
    [_valuesImage sea_setImageWithURL:viewModel.valueSpecImage];
    
    _valuesNameLabel.text = viewModel.valueSpecName;
}



@end
