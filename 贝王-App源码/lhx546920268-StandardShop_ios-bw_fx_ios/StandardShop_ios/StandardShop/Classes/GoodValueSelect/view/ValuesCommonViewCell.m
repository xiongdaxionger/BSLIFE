//
//  ValuesCommonViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "ValuesCommonViewCell.h"
#import "JCTagListView.h"

#import "WMGoodDetailSpecInfo.h"

@interface ValuesCommonViewCell()

@end

@implementation ValuesCommonViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _valuesNameLabel.font = [UIFont fontWithName:MainFontName size:13];
}


- (void)configureCellWithModel:(WMGoodDetailSpecInfo *)model{
    
    self.specInfo = model;
    
    WeakSelf(self);
    
    _valuesListView.sizeHeight = 28.0;
    
    _valuesListView.tagCornerRadius = 10.0;
    
    _valuesListView.tagSelectedBackgroundColor = WMRedColor;
    
    [_valuesListView setup];
    
    [_valuesListView setTags:model.titlesArr];
    
    _valuesNameLabel.text = model.specInfoName;
    
    _valuesListView.canSeletedTags = YES;
    
    _valuesListView.lastSelectRow = model.selectIndex;
    
    _valuesListView.type = StyleTypeText;
    
    [_valuesListView setCompletionBlockWithSeleted:^(NSInteger index) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(textSpecValueSelectWithProductID:)]) {
            
            WMGoodDetailSpecValueInfo *valueInfo = [weakSelf.specInfo.specValueInfosArr objectAtIndex:index];
            
            [self.delegate textSpecValueSelectWithProductID:valueInfo.valueProductID];
        }
    }];
    
//    [_valuesListView.collectionView reloadData];
}









@end
