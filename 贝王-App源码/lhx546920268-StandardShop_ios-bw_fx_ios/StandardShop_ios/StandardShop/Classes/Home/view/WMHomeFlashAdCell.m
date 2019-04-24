//
//  WMHomeFlashAdCell.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/18.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "WMHomeFlashAdCell.h"
#import "WMHomeAdInfo.h"


/**滚动广告栏 cell
 */
@interface WMHomeRollCell : UICollectionViewCell

/**图片
 */
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation WMHomeRollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

//小广告tag
#define _smallAdTag_ 1500

@interface WMHomeFlashAdCell ()<SeaAutoScrollViewDelegate>

@end

@implementation WMHomeFlashAdCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //滚动广告
        SeaAutoScrollView *scrollView = [[SeaAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, frame.size.height)];
        scrollView.delegate = self;
        scrollView.showPageControl = YES;
        scrollView.pageControl.currentPageIndicatorTintColor = _appMainColor_;
        scrollView.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [scrollView.collectionView registerClass:[WMHomeRollCell class] forCellWithReuseIdentifier:@"WMHomeRollCell"];
        [self.contentView addSubview:scrollView];
        self.adScrollView = scrollView;
    }
    
    return self;
}

- (void)dealloc
{
    [self.adScrollView stopAnimate];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.adScrollView.frame = self.contentView.bounds;
}

/**重新加载数据
 */
- (void)reloadData
{

    [self.adScrollView reloadData];
   
    if(_rollInfos.count > 1)
    {
         [self.adScrollView startAnimate];
    }
}

- (void)setRollInfos:(NSArray *)rollInfos
{
    if(_rollInfos != rollInfos)
    {
        _rollInfos = rollInfos;
        [self reloadData];
    }
}


#pragma mark- SeaAutoScrollView delegate

- (NSInteger)numberOfCellsInScrollView:(SeaAutoScrollView *)scrollView
{
    return _rollInfos.count;
}

- (id)scrollView:(SeaAutoScrollView *)scrollView cellForIndexPath:(NSIndexPath *)indexPath atIndex:(NSInteger)index
{
    WMHomeRollCell *cell = [scrollView.collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeRollCell" forIndexPath:indexPath];
   
    WMHomeAdInfo *info = [self.rollInfos objectAtIndex:index];
    [cell.imageView sea_setImageWithURL:info.imageURL];
    
    return cell;
}

- (void)scrollView:(SeaAutoScrollView *)scrollView didSelectCellAtIndex:(NSInteger)index
{
    WMHomeAdInfo *info = [self.rollInfos objectAtIndex:index];
    UIViewController *vc = info.viewController;
    if(vc)
    {
        [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self.navigationController];
    }
}

@end
