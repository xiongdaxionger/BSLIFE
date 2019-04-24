//
//  WMGoodPromotionWayView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/6/3.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMGoodPromotionWayView.h"
#import "WMGoodPromotionWayInfo.h"

@implementation WMGoodPromotionWayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _title_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_title_btn setImage:[UIImage imageNamed:@"tick_small"] forState:UIControlStateSelected];
        [_title_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_title_btn setTitleColor:WMRedColor forState:UIControlStateSelected];
        [_title_btn setTintColor:WMRedColor];
        _title_btn.frame = self.bounds;
        [self.contentView addSubview:_title_btn];
    }

    return self;
}

- (void)setSea_selected:(BOOL)sea_selected
{
    _sea_selected = sea_selected;
    _title_btn.selected = _sea_selected;
    if(_sea_selected)
    {
        [_title_btn setButtonIconToRightWithInterval:2.0];
    }
    else
    {
        [_title_btn setImageEdgeInsets:UIEdgeInsetsZero];
        [_title_btn setTitleEdgeInsets:UIEdgeInsetsZero];
    }
}

@end

@interface WMGoodPromotionWayView ()<UICollectionViewDelegate,UICollectionViewDataSource>

///列表
@property(nonatomic,readonly) UICollectionView *collectionView;

///促销方式信息
@property(nonatomic,strong) NSArray *infos;

@end

@implementation WMGoodPromotionWayView

/**构造方法
 *@param frame 位置大小
 *@param infos 数组元素是 WMGoodPromotionWayInfo
 *@return 一个实例
 */
- (instancetype)initWithFrame:(CGRect)frame infos:(NSArray*) infos
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.infos = infos;
        CGFloat interval = 5.0;
        int  countPerScreen = 4;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = interval;
        layout.sectionInset = UIEdgeInsetsMake(interval, interval, interval, interval);
        layout.itemSize = CGSizeMake((self.width - interval * (countPerScreen + 1)) / countPerScreen, self.height - interval * 2);

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[WMGoodPromotionWayCell class] forCellWithReuseIdentifier:@"WMGoodPromotionWayCell"];
        [self addSubview:_collectionView];


        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
    }

    return self;
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMGoodPromotionWayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];

    WMGoodPromotionWayInfo *info = [self.infos objectAtIndex:indexPath.item];

    [cell.title_btn setTitle:info.name forState:UIControlStateNormal];
    cell.sea_selected = info.selected;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WMGoodPromotionWayInfo *info = [self.infos objectAtIndex:indexPath.item];
    info.selected = !info.selected;

    WMGoodPromotionWayCell *cell = (WMGoodPromotionWayCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.sea_selected = info.selected;

    !self.selectHandler ?: self.selectHandler();
}

@end
