//
//  WMHomeGoodSecondKillView.m
//  MoblieFX
//
//  Created by 罗海雄 on 15/11/16.
//  Copyright © 2015年 qianseit. All rights reserved.
//

#import "WMHomeGoodSecondKillView.h"
#import "WMHomeGoodSecondKillCell.h"
#import "WMCountDownView.h"
#import "WMHomeInfo.h"
#import "WMSecondKillViewController.h"
#import "WMGoodInfo.h"
#import "WMGoodDetailContainViewController.h"
#import "WMHomeViewController.h"

///最大显示数量
#define WMHomeGoodSecondKillViewMaxCount 3

@interface WMHomeGoodSecondKillView ()<WMCountDownViewDelegate>

///箭头
@property(nonatomic,readonly) SeaButton *arrowButton;

@end

@implementation WMHomeGoodSecondKillView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _separatorLineWidth_)];
//        line.backgroundColor = _separatorLineColor_;
//        [self.contentView addSubview:line];
//        
        self.contentView.backgroundColor = [UIColor whiteColor];
        CGFloat margin = 5.0;
        
        UIFont *font = [UIFont fontWithName:MainFontName size:16.0];
        CGFloat height = 40.0;
        
        ///图标
        CGSize size = CGSizeMake(109, 25.0);
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, (height - size.height) / 2.0, size.width, size.height)];
        [self.contentView addSubview:_imageView];

        ///秒杀倒计时
        _countDownView = [[WMCountDownView alloc] initWithFrame:CGRectMake(_imageView.right, _imageView.top + (_imageView.height - height) / 2.0, 90, height)];
        _countDownView.numberTextColor = WMRedColor;
        _countDownView.numberSize = CGSizeMake(22.0, 22.0);
        _countDownView.numberBackgroundColor = [UIColor clearColor];
        _countDownView.numberBorderColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _countDownView.numberBorderWidth = 1.0;
        _countDownView.numberFont = [UIFont fontWithName:MainFontName size:14.0];
        _countDownView.pointFont = [UIFont fontWithName:MainFontName size:14.0];
        _countDownView.numberTextColor = [UIColor blackColor];
        [_countDownView initlization];
        [self.contentView addSubview:_countDownView];
        
        ///副标题
        
        ///箭头
        CGFloat arrowSize = 15.0;
        
        font = [UIFont fontWithName:MainFontName size:13.0];
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_countDownView.right + margin, 0, self.width - margin * 3 - _countDownView.right - arrowSize, height)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = [UIColor blackColor];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.font = font;
        _subtitleLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_subtitleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_subtitleLabel addGestureRecognizer:tap];
        
        
        
        _arrowButton = [[SeaButton alloc] initWithFrame:CGRectMake(_subtitleLabel.right + margin, (height - arrowSize) / 2.0, arrowSize, arrowSize) buttonType:SeaButtonTypeRightArrow];
        _arrowButton.lineColor = [UIColor whiteColor];
        _arrowButton.backgroundColor = WMRedColor;
        _arrowButton.layer.cornerRadius = 3.0;
        _arrowButton.layer.masksToBounds = YES;
        _arrowButton.contentBounds = CGRectMake(0, 0, 10.0, 10.0);
        [_arrowButton addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_arrowButton];

        
        ///商品列表
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, WMHomeGoodSecondKillViewMargin, 0, WMHomeGoodSecondKillViewMargin);
        layout.itemSize = WMHomeGoodSecondKillCellSize;
        layout.minimumLineSpacing = WMHomeGoodSecondKillViewMargin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, height, frame.size.width, frame.size.height - height) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"WMHomeGoodSecondKillCell" bundle:nil] forCellWithReuseIdentifier:@"WMHomeGoodSecondKillCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_collectionView];
        
//        line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, frame.size.width, _separatorLineWidth_)];
//        line.backgroundColor = _separatorLineColor_;
//        [self.contentView addSubview:line];
    }
    return self;
}

///去秒杀专区
- (void)handleTap:(id) sender
{
    WMSecondKillViewController *secondKill = [[WMSecondKillViewController alloc] init];
    secondKill.secondKillImageURL = [WMHomeViewController secondKillImageURL];
   // secondKill.secondKillId = self.info.Id;
    [SeaPresentTransitionDelegate pushViewController:secondKill useNavigationBar:YES parentedViewConttroller:self.navigationController];
}

- (void)setInfo:(WMHomeSecondKillInfo *)info
{
    if(info != _info)
    {
        _info = info;
        
        [_imageView sea_setImageWithURL:info.imageURL];
        _subtitleLabel.text = info.subtitle;
        _subtitleLabel.textColor = info.subTitleColor;

        [self.collectionView reloadData];
        
        [self reloadTimer];
    }
}

///刷新倒计时
- (void)reloadTimer
{
    if(!_info.isSecondKillBegan)
    {
        _countDownView.timeInterval = _info.beginTime;
        [_countDownView startTimer];
    }
    else if (!_info.isSecondKillEnded)
    {
        _countDownView.timeInterval = _info.endTime;
        [_countDownView startTimer];
    }
    else
    {
        _countDownView.timeInterval = 0;
        [_countDownView timerEnd];
    }
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.info.infos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMHomeGoodSecondKillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMHomeGoodSecondKillCell" forIndexPath:indexPath];
    cell.info = [self.info.infos objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WMGoodInfo *info = [self.info.infos objectAtIndex:indexPath.item];
    WMGoodDetailContainViewController *detail = [[WMGoodDetailContainViewController alloc] init];
    detail.productID = info.productId;
    detail.goodID = info.goodId;
    [SeaPresentTransitionDelegate pushViewController:detail useNavigationBar:YES parentedViewConttroller:self.navigationController];
}

- (void)countDownViewDidEnd:(WMCountDownView *)view
{
    [self reloadTimer];
//    if([self.delegate respondsToSelector:@selector(homeGoodSecondKillViewDidEnd:)])
//    {
//        [self.delegate homeGoodSecondKillViewDidEnd:self];
//    }
}

@end
