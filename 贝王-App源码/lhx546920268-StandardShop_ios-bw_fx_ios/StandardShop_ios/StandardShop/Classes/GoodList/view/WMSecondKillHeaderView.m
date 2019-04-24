//
//  WMSecondKillHeaderView.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSecondKillHeaderView.h"
#import "WMHomeAdInfo.h"
#import "WMGoodListOperation.h"

/**滚动广告栏 cell
 */
@interface WMSecondKillRollCell : UICollectionViewCell

/**图片
 */
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation WMSecondKillRollCell

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

@interface WMSecondKillHeaderView ()<SeaAutoScrollViewDelegate>

/**滚动广告
 */
@property(nonatomic,strong) SeaAutoScrollView *adScrollView;

@end

@implementation WMSecondKillHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(frame.size.height <= 0)
        frame.size.height = WMSecondKillHeaderViewHeight;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //滚动广告
        SeaAutoScrollView *scrollView = [[SeaAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        scrollView.delegate = self;
        scrollView.showPageControl = YES;
        scrollView.pageControl.currentPageIndicatorTintColor = _appMainColor_;
        scrollView.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [scrollView.collectionView registerClass:[WMSecondKillRollCell class] forCellWithReuseIdentifier:@"WMSecondKillRollCell"];
        [self addSubview:scrollView];
        self.adScrollView = scrollView;
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, _width_, WMSecondKillHeaderViewHeight)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.adScrollView.frame = self.bounds;
}

- (void)dealloc
{
    [self.adScrollView stopAnimate];
}

/**重新加载数据
 */
- (void)reloadData
{
    if(_rollInfos.count <= 1)
    {
        self.adScrollView.enableScrollCircularly = NO;
    }
    else
    {
        self.adScrollView.enableScrollCircularly = YES;
    }
    
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
    WMSecondKillRollCell *cell = [scrollView.collectionView dequeueReusableCellWithReuseIdentifier:@"WMSecondKillRollCell" forIndexPath:indexPath];
    
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
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
