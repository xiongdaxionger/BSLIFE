//
//  GoodValuesImageViewCell.m
//  WuMei
//
//  Created by qsit on 15/7/21.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "GoodValuesImageViewCell.h"

#import "WMGoodDetailSpecInfo.h"
#import "ImageSelectCollectionViewCell.h"

@interface GoodValuesImageViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
/**当前选中的下标
 */
@property (assign,nonatomic) NSInteger lastSelectRow;
@end

@implementation GoodValuesImageViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _valuesNameLabel.font = [UIFont fontWithName:MainFontName size:15.0];
    
    UINib *nib = [UINib nibWithNibName:@"ImageSelectCollectionViewCell" bundle:nil];
    
    [_imageCollectionView registerNib:nib forCellWithReuseIdentifier:kImageSelectCollectionViewCellIden];
    
    _imageCollectionView.delegate = self;
    
    _imageCollectionView.dataSource = self;
    
    _imageCollectionView.showsHorizontalScrollIndicator = NO;
}

- (void)configureCellWithModel:(WMGoodDetailSpecInfo *)model{
    
    self.valuesNameLabel.text = model.specInfoName;
    
    self.lastSelectRow = model.selectIndex;
    
    self.specInfo = model;
    
//    [self.imageCollectionView reloadData];
    
    [self scrollToVisibleRect];
}

- (void)setSpecInfo:(WMGoodDetailSpecInfo *)specInfo{
    
    if (_specInfo != specInfo) {
        
        _specInfo = specInfo;
        
        [self.imageCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.specInfo.specValueInfosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageSelectCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageSelectCollectionViewCellIden forIndexPath:indexPath];
    
    WMGoodDetailSpecValueInfo *valueInfo = [self.specInfo.specValueInfosArr objectAtIndex:indexPath.row];
    
    [imageCell layoutIfNeeded];

    if (indexPath.row == _lastSelectRow) {
        
        [imageCell.imageBackImage makeBorderWidth:1.0 Color:_appMainColor_ CornerRadius:imageCell.imageBackImage.frame.size.height / 2];
    }
    else{
        
        [imageCell.imageBackImage makeBorderWidth:1.0 Color:[UIColor colorWithR:204 G:204 B:204 a:1.0] CornerRadius:imageCell.imageBackImage.frame.size.height / 2];
    }
    
    [imageCell configureWithModel:valueInfo];
    
    return imageCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectRow == indexPath.row) {
        
        return;
    }
    else{
        
        [self selectCellIndexPath:indexPath isSelect:YES];
        
        [self selectCellIndexPath:[NSIndexPath indexPathForRow:self.lastSelectRow inSection:indexPath.section] isSelect:NO];
        
        self.lastSelectRow = indexPath.row;
    }
    
    [self scrollToVisibleRect];
    
    if ([self.delegate respondsToSelector:@selector(imageSpecValueSelectWithProductID:)]) {
        
        WMGoodDetailSpecValueInfo *valueInfo = [self.specInfo.specValueInfosArr objectAtIndex:indexPath.row];
        
        [self.delegate imageSpecValueSelectWithProductID:valueInfo.valueProductID];
    }
}


- (void)selectCellIndexPath:(NSIndexPath *)indexPath isSelect:(BOOL)isSelect{
    
    ImageSelectCollectionViewCell *cell = (ImageSelectCollectionViewCell *)[self.imageCollectionView cellForItemAtIndexPath:indexPath];
    
    if (isSelect) {
        
        [cell.imageBackImage makeBorderWidth:1.0 Color:_appMainColor_ CornerRadius:cell.imageBackImage.frame.size.height / 2];
    }
    else{
        
        [cell.imageBackImage makeBorderWidth:1.0 Color:[UIColor colorWithR:204 G:204 B:204 a:1.0] CornerRadius:cell.imageBackImage.frame.size.height / 2];
    }
}

- (void)scrollToVisibleRect
{
    if(self.imageCollectionView.contentSize.width <= self.imageCollectionView.width)
        return;
    
    NSArray *visibles = [self.imageCollectionView indexPathsForVisibleItems];
    
    visibles = [visibles sortedArrayUsingComparator:^(id obj1, id obj2){
        
        NSIndexPath *indexPath1 = obj1;
        NSIndexPath *indexPath2 = obj2;
        
        if(indexPath1.item > indexPath2.item)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    
    if(visibles.count > 2)
    {
        NSIndexPath *indexPath = [visibles objectAtIndex:visibles.count - 2];
        if(_lastSelectRow == indexPath.row)
        {
            [self.imageCollectionView scrollToItemAtIndexPath:[visibles lastObject] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        else
        {
            indexPath = [visibles objectAtIndex:1];
            if(_lastSelectRow == indexPath.row)
            {
                [self.imageCollectionView scrollToItemAtIndexPath:[visibles firstObject] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
            else
            {
                indexPath = [visibles lastObject];
                if(_lastSelectRow == indexPath.row)
                {
                    if(indexPath.row + 1 < self.specInfo.specValueInfosArr.count)
                    {
                        indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
                    }
                    [self.imageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
                else
                {
                    indexPath = [visibles firstObject];
                    
                    if(_lastSelectRow == indexPath.row)
                    {
                        if(indexPath.row - 1 >= 0)
                        {
                            indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
                        }
                        [self.imageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    }
                }
            }
        }
    }
    else
    {
        NSIndexPath *indexPath = [visibles lastObject];
        if(_lastSelectRow == indexPath.row)
        {
            if(indexPath.row + 1 < self.specInfo.specValueInfosArr.count)
            {
                indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
            }
            [self.imageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        else
        {
            indexPath = [visibles firstObject];
            
            if(_lastSelectRow == indexPath.row)
            {
                if(indexPath.row - 1 >= 0)
                {
                    indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
                }
                
                [self.imageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

@end
