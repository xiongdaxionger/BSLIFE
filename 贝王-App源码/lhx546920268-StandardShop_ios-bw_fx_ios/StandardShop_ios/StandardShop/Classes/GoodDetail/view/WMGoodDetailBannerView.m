//
//  GoodDetailBannerView.m
//  WuMei
//
//  Created by qsit on 15/8/4.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMGoodDetailBannerView.h"

/**滚动广告栏 cell
 */
@interface GoodDetailImageCell : UICollectionViewCell

/**图片
 */
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation GoodDetailImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.imageView.frame = self.contentView.bounds;
}

@end

@interface WMGoodDetailBannerView ()<SeaAutoScrollViewDelegate>

@end

@implementation WMGoodDetailBannerView

- (instancetype)initWithImageArr:(NSArray *)imageArr{
    
    self = [super initWithFrame:CGRectMake(0, 0, _width_, _width_)];
    
    if(self)
    {
        self.imageArr = imageArr;
        //滚动广告
        SeaAutoScrollView *scrollView = [[SeaAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        scrollView.delegate = self;
        scrollView.showPageControl = YES;
        scrollView.enableAutoScroll = NO;
        scrollView.enableScrollCircularly = NO;
        scrollView.pageControl.currentPageIndicatorTintColor = WMButtonBackgroundColor;
        scrollView.pageControl.pageIndicatorTintColor = MainDefaultBackColor;
        [scrollView.collectionView registerClass:[GoodDetailImageCell class] forCellWithReuseIdentifier:@"GoodDetailImageCell"];
        [self addSubview:scrollView];
        self.autoScrollView = scrollView;
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData
{
    [self.autoScrollView reloadData];
}

#pragma mark- SeaAutoScrollView delegate

- (NSInteger)numberOfCellsInScrollView:(SeaAutoScrollView *)scrollView
{
    return _imageArr.count;
}

- (id)scrollView:(SeaAutoScrollView *)scrollView cellForIndexPath:(NSIndexPath *)indexPath atIndex:(NSInteger)index
{
    GoodDetailImageCell *cell = [scrollView.collectionView dequeueReusableCellWithReuseIdentifier:@"GoodDetailImageCell" forIndexPath:indexPath];
    
    NSURL *imageUrl = [self.imageArr objectAtIndex:index];
    
    [cell.imageView sea_setImageWithURL:[NSString stringWithFormat:@"%@",imageUrl]];
    
    return cell;
}

- (void)scrollViewDraggingLastPage:(SeaAutoScrollView *)scrollView{

    if (self.draggingLastPage) {
        
        self.draggingLastPage();
    }
}


- (void)dealloc
{
    [_autoScrollView stopAnimate];
}

@end
