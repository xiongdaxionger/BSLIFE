//
//  WMGoodLinkTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodLinkTableViewCell.h"
#import "WMGoodListCollectionViewCell.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodSimilarInfo.h"

@interface WMGoodLinkTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**相似商品数组
 */
@property (strong,nonatomic) NSArray *similarInfosArr;
@end

@implementation WMGoodLinkTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat sectionInset = 5.0;
    
    CGFloat imageMargin = 4.0;
    
    CGFloat topMargin = 8.0;
    
    CGFloat cellWidth = (_width_ - sectionInset * 4) / 3.0;
    
    CGFloat cellHeight = topMargin + (cellWidth - imageMargin * 2) + 80;
    
    self.flowLayOut.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    self.flowLayOut.minimumLineSpacing = sectionInset;
    
    self.flowLayOut.minimumInteritemSpacing = CGFLOAT_MIN;
    
    self.flowLayOut.sectionInset = UIEdgeInsetsMake(CGFLOAT_MIN, sectionInset, CGFLOAT_MIN, sectionInset);
    
    self.flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMGoodListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WMGoodListCollectionViewCellIden];
    
    self.pageControl.hidesForSinglePage = YES;
    
    self.pageControl.currentPageIndicatorTintColor = WMRedColor;
    
    self.pageControl.pageIndicatorTintColor = MainDefaultBackColor;
}


- (void)configureCellWithModel:(id)model{
    
    self.contentView.hidden = NO;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    WMGoodDetailInfo *info = (WMGoodDetailInfo *)model;
    
    self.similarInfosArr = info.goodSimilarGoodsArr;
    
    self.pageControl.numberOfPages = self.similarInfosArr.count % 3 ? self.similarInfosArr.count / 3 + 1 : self.similarInfosArr.count / 3;
    
    self.collectionViewBottom.constant = self.similarInfosArr.count > 3 ? 50.0 : 0.0;
}

#pragma mark - UICollectionView协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.similarInfosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WMGoodListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WMGoodListCollectionViewCellIden forIndexPath:indexPath];
    
    [cell configureCellWithSimilarInfoWith:[self.similarInfosArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectCallBack) {
        
        WMGoodSimilarInfo *goodInfo = [self.similarInfosArr objectAtIndex:indexPath.row];
        
        self.selectCallBack(goodInfo.similarProductID);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_collectionView.contentOffset.x + 5.0 < _collectionView.width) {
        
        if (_collectionView.contentOffset.x == 0.0) {
            
            self.pageControl.currentPage = 0;
        }
        
        return;
    }
    
    self.pageControl.currentPage = (_collectionView.contentOffset.x + 5.0) / _collectionView.width;
}










@end
