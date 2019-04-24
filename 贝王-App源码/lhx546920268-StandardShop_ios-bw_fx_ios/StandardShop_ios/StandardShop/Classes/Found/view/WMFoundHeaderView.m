//
//  WMFoundHeaderView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/22.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMFoundHeaderView.h"
#import "WMFoundHeaderCollectionViewCell.h"
#import "WMFoundCategoryInfo.h"

///每行的类目数量
#define WMFoundHeaderViewCountPerRow 4

@interface WMFoundHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>

///集合视图
@property(nonatomic,strong) UICollectionView *collectionView;

///选中的分类信息
@property(nonatomic,copy) NSIndexPath *selectedIndexPath;

@end

@implementation WMFoundHeaderView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, 90.0)];
    if(self)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.width / WMFoundHeaderViewCountPerRow, self.height);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerNib:[UINib nibWithNibName:@"WMFoundHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WMFoundHeaderCollectionViewCell"];
        [self addSubview:self.collectionView];
        
        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        line.userInteractionEnabled = NO;
        [self addSubview:line];
    }
    
    return self;
}

- (void)setInfos:(NSArray *)infos
{
    if(_infos != infos)
    {
        _infos = infos;
        self.selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView reloadData];
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMFoundHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMFoundHeaderCollectionViewCell" forIndexPath:indexPath];
    
    WMFoundCategoryInfo *info = [self.infos objectAtIndex:indexPath.item];
    [cell.icon_imageView sea_setImageWithURL:info.imageURL];
    cell.name_label.text = info.name;
    cell.sea_selected = info.selected;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMFoundCategoryInfo *info = [self.infos objectAtIndex:indexPath.item];
    
    if (info.selected)
    {
        return;
    }
    
    info.selected = YES;
    WMFoundHeaderCollectionViewCell *cell = (WMFoundHeaderCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.sea_selected = YES;
    
    if(self.selectedIndexPath)
    {
        WMFoundCategoryInfo *selectedCategoryInfo = [self.infos objectAtIndex:self.selectedIndexPath.item];
        selectedCategoryInfo.selected = NO;
        cell = (WMFoundHeaderCollectionViewCell*)[collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        cell.sea_selected = NO;
    }
    
    self.selectedIndexPath = indexPath;
    
    if([self.delegate respondsToSelector:@selector(foundHeaderView:didSelctedCategoryInfo:)])
    {
        [self.delegate foundHeaderView:self didSelctedCategoryInfo:info];
    }
    
    [self scrollToVisibleRect];
}

///滚动到可见位置
- (void)scrollToVisibleRect
{
    if(self.collectionView.contentSize.width <= self.collectionView.width)
        return;
    
    NSArray *visibles = [self.collectionView indexPathsForVisibleItems];
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
        if(self.selectedIndexPath.row == indexPath.row)
        {
            [self.collectionView scrollToItemAtIndexPath:[visibles lastObject] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        else
        {
            indexPath = [visibles objectAtIndex:1];
            if(self.selectedIndexPath.row == indexPath.row)
            {
                [self.collectionView scrollToItemAtIndexPath:[visibles firstObject] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
            else
            {
                indexPath = [visibles lastObject];
                if(self.selectedIndexPath.row == indexPath.row)
                {
                    if(indexPath.row + 1 < self.infos.count)
                    {
                        indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
                    }
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
                else
                {
                    indexPath = [visibles firstObject];
                    
                    if(self.selectedIndexPath.row == indexPath.row)
                    {
                        if(indexPath.row - 1 >= 0)
                        {
                            indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
                        }
                        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                    }
                }
            }
        }
    }
    else
    {
        NSIndexPath *indexPath = [visibles lastObject];
        if(self.selectedIndexPath.row == indexPath.row)
        {
            if(indexPath.row + 1 < self.infos.count)
            {
                indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
            }
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        else
        {
            indexPath = [visibles firstObject];
            
            if(self.selectedIndexPath.row == indexPath.row)
            {
                if(indexPath.row - 1 >= 0)
                {
                    indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
                }
                
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

@end
