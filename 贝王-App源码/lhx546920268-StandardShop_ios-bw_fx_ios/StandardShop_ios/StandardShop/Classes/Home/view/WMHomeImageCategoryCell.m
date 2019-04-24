//
//  WMHomeImageCategoryCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/13.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMHomeImageCategoryCell.h"
#import "WMHomeInfo.h"
#import "WMHomeImageCategoryGoodListCell.h"
#import "WMGoodInfo.h"

@implementation WMHomeImageCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.triangle_imageView.tintColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.layout.minimumInteritemSpacing = WMHomeImageCategoryGoodListCellMargin;
    self.layout.itemSize = WMHomeImageCategoryGoodListCellSize;
    self.layout.sectionInset = UIEdgeInsetsMake(0, WMHomeImageCategoryGoodListCellMargin, 0, WMHomeImageCategoryGoodListCellMargin);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.category_imageView.userInteractionEnabled = YES;
    [self.category_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMHomeImageCategoryGoodListCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeImageCategoryGoodListCell"];
}

- (void)setInfo:(WMHomeImageCategoryInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        [self.category_imageView sea_setImageWithURL:_info.adInfo.imageURL];
        [self.collectionView reloadData];
    }
}

///点击广告图片
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    UIViewController *vc = self.info.adInfo.viewController;
    if(vc)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.info.goodInfos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeImageCategoryGoodListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeImageCategoryGoodListCell" forIndexPath:indexPath];
    cell.info = [_info.goodInfos objectAtIndex:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    WMGoodInfo *info = [_info.goodInfos objectAtIndex:indexPath.item];
}

@end
