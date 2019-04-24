//
//  JCTagListView.m
//  JCTagListView
//
//  Created by Tbxark on 15/7/3.
//  Copyright (c) 2015年 Tbxark. All rights reserved.
//

#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) JCTagListViewBlock seletedBlock;
@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
                
//        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    self.lastSelectRow = 0;
    
    self.tags = [NSMutableArray array];
    
    _tagStrokeColor = self.tagStrokeColor == nil ?  [UIColor lightGrayColor] : self.tagStrokeColor;
    _tagBackgroundColor = self.tagBackgroundColor == nil ? [UIColor clearColor] : self.tagBackgroundColor;
    _tagTextColor = self.tagTextColor == nil ? [UIColor darkGrayColor] : self.tagTextColor;
    _tagSelectedBackgroundColor = self.tagSelectedBackgroundColor == nil ? [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1] : self.tagSelectedBackgroundColor;
    _tagSelectedTextColor = self.tagSelectedTextColor == nil ? [UIColor whiteColor] : self.tagSelectedTextColor;
    _tagCornerRadius = self.tagCornerRadius;
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    layout.sizeHeight = self.sizeHeight;
    
    [layout setup];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.scrollEnabled = NO;
    
    [self addSubview:self.collectionView];
}

- (void)setCompletionBlockWithSeleted:(JCTagListViewBlock)completionBlock
{
    self.seletedBlock = completionBlock;
}

- (void)setTags:(NSArray *)tags{
    
    if (_tags != tags) {
        
        _tags = tags;
        
        [self.collectionView reloadData];
    }
}


#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    NSString *titleString = [self.tags objectAtIndex:indexPath.item];
    
    CGRect frame = [titleString boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    if (self.type == StyleTypeImageText) {
        
        return CGSizeMake(frame.size.width + 20.0f + 20.0f, layout.itemSize.height);
    }
    else{
        
        return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.cellHeight = self.sizeHeight;
    
    cell.type = self.type;
    
    cell.backgroundColor = self.tagBackgroundColor;
    
    cell.layer.cornerRadius = self.tagCornerRadius;
    
    cell.titleLabel.text = self.tags[indexPath.item];
    
    cell.titleLabel.textColor = self.tagTextColor;
    
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    
    if (self.type == StyleTypeImageText) {
        
        cell.titleLabel.layer.borderColor = WMRedColor.CGColor;
        
        cell.titleLabel.layer.borderWidth = 1.0;
    }
    
    if (self.canSeletedTags) {
        
        cell.backgroundColor = indexPath.item == self.lastSelectRow ? self.tagSelectedBackgroundColor : self.tagBackgroundColor;
        
        cell.titleLabel.textColor = indexPath.item == self.lastSelectRow ? self.tagSelectedTextColor : self.tagTextColor;
        
        cell.layer.borderColor = indexPath.item == self.lastSelectRow ? [UIColor clearColor].CGColor : self.tagStrokeColor.CGColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.canSeletedTags) {
        
        if (self.lastSelectRow == indexPath.row) {
            
            return;
        }
        else{
            
            [self selectCellIndexPath:indexPath isSelect:YES];
            
            [self selectCellIndexPath:[NSIndexPath indexPathForRow:self.lastSelectRow inSection:indexPath.section] isSelect:NO];
            
            self.lastSelectRow = indexPath.row;
        }
    }
    
    if (self.seletedBlock) {
        
        self.seletedBlock(indexPath.item);
    }
}


- (void)selectCellIndexPath:(NSIndexPath *)indexPath isSelect:(BOOL)isSelect{
    
    JCTagCell *cell = (JCTagCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = isSelect ? self.tagSelectedBackgroundColor : self.tagBackgroundColor;
    
    cell.titleLabel.textColor = isSelect ? self.tagSelectedTextColor : self.tagTextColor;
    
    cell.layer.borderColor = isSelect ? [UIColor clearColor].CGColor : self.tagStrokeColor.CGColor;
}

@end
