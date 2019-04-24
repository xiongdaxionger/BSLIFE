//
//  WMHomeLettersView.m
//  WanShoes
//
//  Created by 罗海雄 on 16/3/14.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import "WMHomeLettersView.h"
#import "WMHomeLettersCell.h"
#import "WMHomeInfo.h"
#import "WMHomeAdInfo.h"

@interface WMHomeLettersView ()

///自动滚动计时器
@property(nonatomic,strong) NSTimer *timer;

///是否需要自动滚动
@property(nonatomic,assign) BOOL needScrollAutomatically;

///内容视图
@property(nonatomic,strong) UIView *cView;

@end

@implementation WMHomeLettersView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        CGFloat margin = 5.0;
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _separatorLineWidth_)];
//        line.backgroundColor = _separatorLineColor_;
//        [self.contentView addSubview:line];
  
        CGFloat interval = 10.0;
        self.cView = [[UIView alloc] initWithFrame:CGRectMake(interval, 0, self.width - interval * 2, self.height)];
        self.cView.backgroundColor = [UIColor whiteColor];
        self.cView.layer.cornerRadius = 8.0;
        self.cView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.cView];
        
        
        UIImage *logo = [UIImage imageNamed:@"home_letters_icon"];
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, logo.size.width, frame.size.height)];
        _logoImageView.image = logo;
        _logoImageView.contentMode = UIViewContentModeCenter;
        [self.cView addSubview:_logoImageView];
        
        CGSize size = CGSizeMake(self.cView.width - _logoImageView.right - margin, self.cView.height);
        
        ///商品列表
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_logoImageView.right + margin, 0, size.width, self.cView.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundView = nil;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"WMHomeLettersCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeLettersCell"];
        [self.cView addSubview:_collectionView];
        
//        line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, frame.size.width, _separatorLineWidth_)];
//        line.backgroundColor = _separatorLineColor_;
//        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setInfo:(WMHomeInfo *)info
{
    if(info != _info)
    {
        _info = info;
        self.needScrollAutomatically = _info.infos.count > 1;
        
        [self.collectionView reloadData];
        
        if(self.needScrollAutomatically)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
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
    return self.info.infos.count == 1 ? 1 : self.info.infos.count + 2;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeAdInfo *info = [self infoForIndexPath:indexPath];
    
    WMHomeLettersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeLettersCell" forIndexPath:indexPath];
    cell.text_label.text = info.text;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    WMHomeAdInfo *info = [self infoForIndexPath:indexPath];
    UIViewController *vc = info.viewController;
    if(vc)
    {
        [SeaPresentTransitionDelegate pushViewController:vc useNavigationBar:YES parentedViewConttroller:self.navigationController];
    }
}

///获取当前info
- (WMHomeAdInfo*)infoForIndexPath:(NSIndexPath*) indexPath
{
    if(indexPath.item == 0)
    {
        return [self.info.infos lastObject];
    }
    else if (indexPath.item > self.info.infos.count)
    {
        return [self.info.infos firstObject];
    }
    else
    {
        return [self.info.infos objectAtIndex:indexPath.item - 1];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.needScrollAutomatically)
    {
        NSArray *infos = self.info.infos;
        CGFloat pageHeight = scrollView.height;
        int page = floor(scrollView.contentOffset.y / pageHeight);
        if(page == 0)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:infos.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];// 最后+1,循环到第1页
        }
        else if (page == (infos.count + 1))
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO]; // 最后+1,循环第1页
        }
    }
}

///自动滚动
- (void)scrollAutomatically
{
    CGFloat pageHeight = self.collectionView.height;
    int page = floor(self.collectionView.contentOffset.y / pageHeight);
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
}

#pragma mark- timer

///启动计时器
- (void)startTimer
{
    if(!self.timer)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0] interval:3.0 target:self selector:@selector(scrollAutomatically) userInfo:nil repeats:YES];
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
