//
//  WMShakeWinnerView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/8/7.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMShakeWinnerView.h"
#import "WMShakeWinnerInfo.h"

///高度
#define WMShakeWinnerCellHeight 20.0

///获奖名单cell
@interface WMShakeWinnerCell : UICollectionViewCell

///内容
@property (readonly, nonatomic) UILabel *text_label;

@end

@implementation WMShakeWinnerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _text_label = [[UILabel alloc] initWithFrame:self.bounds];
        _text_label.textColor = [UIColor whiteColor];
        _text_label.font = [UIFont fontWithName:MainFontName size:13.0];
        _text_label.numberOfLines = 0;
        [self.contentView addSubview:_text_label];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _text_label.frame = self.contentView.frame;
}

@end

@interface WMShakeWinnerView ()

///自动滚动计时器
@property(nonatomic,strong) NSTimer *timer;

///是否需要自动滚动
@property(nonatomic,assign) BOOL needScrollAutomatically;

///
@property(nonatomic,assign) NSInteger countPerPage;


@end

@implementation WMShakeWinnerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initlization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
        
        
        
        [self initlization];
    }
    
    return self;
}

///初始化
- (void)initlization
{
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat width = _width_ - 15.0 * 2 - 20.0 - 48.0;
    
    ///商品列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(width, WMShakeWinnerCellHeight);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 0) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundView = nil;
  //  _collectionView.scrollEnabled = NO;
   // _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WMShakeWinnerCell class] forCellWithReuseIdentifier:@"WMShakeWinnerCell"];
    [self addSubview:_collectionView];
}

- (void)setWinners:(NSMutableArray *)winners
{
    if(winners != _winners)
    {
        _winners = winners;
        
        if(_winners.count <= 1 || is3_5Inch)
        {
            self.countPerPage = 1;
        }
        else
        {
            self.countPerPage = _width_ == 320.0 ? 1 : MIN(_winners.count, 3);
        }
        
        CGFloat height =  WMShakeWinnerCellHeight * [self countPerPage];
        self.sea_heightLayoutConstraint.constant = height;
        self.collectionView.height = height;
        
        self.needScrollAutomatically = _winners.count > self.countPerPage;
        
        
        
        [self.collectionView reloadData];
        
        if(self.needScrollAutomatically)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self countPerPage] inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            [self startTimer];
        }
        else
        {
            [self stopTimer];
        }
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _winners.count == 1 ? 1 : _winners.count + 2 * [self countPerPage];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    WMShakeWinnerInfo *info = [self infoForIndexPath:indexPath];
//    if(info.textHeight == 0)
//    {
//        info.textHeight = [info.text stringSizeWithFont:[UIFont fontWithName:MainFontName size:13.0] contraintWith:collectionView.width].height + 1.0;
//        if(info.textHeight < 20.0)
//            info.textHeight = 20.0;
//    }
//    
//    return CGSizeMake(collectionView.width, info.textHeight);
//}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMShakeWinnerInfo *info = [self infoForIndexPath:indexPath];
    
    WMShakeWinnerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMShakeWinnerCell" forIndexPath:indexPath];
    cell.text_label.text = info.text;
    
    return cell;
}

///获取当前info
- (WMShakeWinnerInfo*)infoForIndexPath:(NSIndexPath*) indexPath
{    
    if(indexPath.item < [self countPerPage])
    {
        
        return [self.winners objectAtIndex:self.winners.count + indexPath.item - [self countPerPage]];
    }
    else if (indexPath.item - [self countPerPage] >= self.winners.count)
    {
        
        return [self.winners objectAtIndex:indexPath.item - [self countPerPage]  - self.winners.count];
    }
    else
    {
        
        return [self.winners objectAtIndex:indexPath.item - [self countPerPage]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.needScrollAutomatically)
    {
        NSArray *infos = self.winners;
        int page = floorf(scrollView.contentOffset.y / WMShakeWinnerCellHeight) + [self countPerPage] - 1;
        if(page == 0)
        {
            [self.collectionView setContentOffset:CGPointMake(0, ([self countPerPage] - 1 + infos.count - 1) * WMShakeWinnerCellHeight)];// 最后+1,循环到第1页
        }
        else if (page == infos.count + [self countPerPage])
        {
            [self.collectionView setContentOffset:CGPointMake(0, WMShakeWinnerCellHeight)]; // 最后+1,循环第1页
        }
        else if (!self.loading && self.willLoadNextWinnersHandler && (page >= infos.count + [self countPerPage] - 5))
        {
            !self.willLoadNextWinnersHandler ?: self.willLoadNextWinnersHandler();
        }
    }
}

///自动滚动
- (void)scrollAutomatically
{
    CGFloat pageHeight = WMShakeWinnerCellHeight;
    int page = floor(self.collectionView.contentOffset.y / pageHeight);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionLayoutSubviews animations:^(void){
//        
//        
//    }completion:nil];
}

#pragma mark- timer

///启动计时器
- (void)startTimer
{
    if(!self.timer)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0] interval:1.0 target:self selector:@selector(scrollAutomatically) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

///停止倒计时
- (void)stopTimer
{
    if(self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
