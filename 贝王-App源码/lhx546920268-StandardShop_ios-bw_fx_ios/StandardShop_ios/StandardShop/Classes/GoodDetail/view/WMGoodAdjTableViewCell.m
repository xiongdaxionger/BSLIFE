//
//  WMGoodAdjTableViewCell.m
//  StandardShop
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodAdjTableViewCell.h"
#import "WMGoodListCollectionViewCell.h"
#import "WMGoodDetailInfoViewController.h"
#import "WMGoodDetailContainViewController.h"
#import "JCTagListView.h"

#import "WMGoodDetailInfo.h"
#import "WMGoodDetailAdjGroupInfo.h"

@interface WMGoodAdjTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**商品数组
 */
@property (strong,nonatomic) NSArray *adjGoodsArr;
/**配件数组
 */
@property (strong,nonatomic) NSArray *adjGroupsArr;
/**商品详情
 */
@property (weak,nonatomic) WMGoodDetailInfoViewController *goodDetailController;
@end

@implementation WMGoodAdjTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    CGFloat sectionInset = 5.0;
    
    CGFloat imageMargin = 4.0;
    
    CGFloat topMargin = 8.0;
    
    CGFloat cellWidth = (_width_ - sectionInset * 4) / 3.0;
    
    CGFloat cellHeight = topMargin + (cellWidth - imageMargin * 2) + 75;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    self.flowLayOut.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    self.flowLayOut.minimumLineSpacing = sectionInset;
    
    self.flowLayOut.minimumInteritemSpacing = CGFLOAT_MIN;
    
    self.flowLayOut.sectionInset = UIEdgeInsetsMake(CGFLOAT_MIN, sectionInset, CGFLOAT_MIN, sectionInset);
    
    self.flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionViewHeight.constant = cellHeight;
    
    self.collectionView.pagingEnabled = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WMGoodListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WMGoodListCollectionViewCellIden];
    
    self.tagListView.sizeHeight = 28.0;
    
    self.tagListView.canSeletedTags = YES;
    
    self.tagListView.tagSelectedBackgroundColor = WMRedColor;
    
    self.tagListView.tagSelectedTextColor = [UIColor whiteColor];
    
    self.tagListView.tagCornerRadius = 10.0;
    
    [self.tagListView setup];
    
    self.tagListView.type = StyleTypeText;
    
    WeakSelf(self);
    
    [self.tagListView setCompletionBlockWithSeleted:^(NSInteger index) {
        
        for (NSInteger i = 0; i < weakSelf.adjGroupsArr.count; i++) {
            
            WMGoodDetailAdjGroupInfo *groupInfo = [weakSelf.adjGroupsArr objectAtIndex:i];
            
            groupInfo.groupIsSelect = index == i ? YES : NO;
            
            weakSelf.adjGoodsArr = index == i ? groupInfo.groupGoodInfoArr : weakSelf.adjGoodsArr;
        }
        
        [weakSelf.collectionView reloadData];
    }];
}

- (void)configureCellWithModel:(id)model{
    
    self.contentView.hidden = NO;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    WMGoodDetailInfo *info = [model objectForKey:@"model"];
    
    self.goodDetailController = [model objectForKey:@"controller"];
    
    self.adjGroupsArr = info.goodAdjGroupsArr;
    
    NSMutableArray *titlesArr = [NSMutableArray new];
    
    for (WMGoodDetailAdjGroupInfo *groupInfo in self.adjGroupsArr) {
        
        [titlesArr addObject:groupInfo.groupName];
        
        if (groupInfo.groupIsSelect) {
            
            self.adjGoodsArr = groupInfo.groupGoodInfoArr;
        }
    }
    
    [self.tagListView setTags:titlesArr];
}

#pragma mark - UICollectionView协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.adjGoodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    WMGoodListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WMGoodListCollectionViewCellIden forIndexPath:indexPath];
    
    [cell configureCellWithAdjGoodInfoWith:[self.adjGoodsArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *productID = [NSString new];
    
    for (WMGoodDetailAdjGroupInfo *groupInfo in self.adjGroupsArr) {
        
        if (groupInfo.groupIsSelect) {
            
            WMGoodDetailAdjGoodInfo *goodInfo = [groupInfo.groupGoodInfoArr objectAtIndex:indexPath.row];
            
            productID = goodInfo.productID;
            
            break;
        }
    }

    WMGoodDetailContainViewController *contain = [[WMGoodDetailContainViewController alloc] init];
    
    contain.productID = productID;
    
    [self.goodDetailController.navigation pushViewController:contain animated:YES];
}




@end
