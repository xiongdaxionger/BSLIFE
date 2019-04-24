//
//  WMFoundHomeAdCell.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/29.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMFoundHomeAdCell.h"
#import "WMHomeAdInfo.h"


/**滚动广告栏 cell
 */
@interface WMFoundHomeRollCell : UICollectionViewCell

/**图片
 */
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation WMFoundHomeRollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.sea_originContentMode = UIViewContentModeScaleAspectFit;
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


@interface WMFoundHomeAdCell ()<SeaAutoScrollViewDelegate>



@end

@implementation WMFoundHomeAdCell

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
        [scrollView.collectionView registerClass:[WMFoundHomeRollCell class] forCellWithReuseIdentifier:@"WMFoundHomeRollCell"];
        [self.contentView addSubview:scrollView];
        self.adScrollView = scrollView;
    }
    
    return self;
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


#pragma mark- SeaScrollView delegate

- (NSInteger)numberOfCellsInScrollView:(SeaAutoScrollView *)scrollView
{
    return _rollInfos.count;
}

- (id)scrollView:(SeaAutoScrollView *)scrollView cellForIndexPath:(NSIndexPath *)indexPath atIndex:(NSInteger)index
{
    WMFoundHomeRollCell *cell = [scrollView.collectionView dequeueReusableCellWithReuseIdentifier:@"WMFoundHomeRollCell" forIndexPath:indexPath];
    
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
