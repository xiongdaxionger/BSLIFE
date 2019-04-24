//
//  WMSecondKillSectionHeaderView.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "WMSecondKillSectionHeaderView.h"
#import "WMCountDownView.h"
#import "WMSecondKillInfo.h"

@class WMSecondKillSectionHeaderCell;

///秒杀专区按钮代理
@protocol WMSecondKillSectionHeaderCellDelegate <NSObject>

///订阅时间已过
- (void)secondKillSectionHeaderCellDidEndSubscrible:(WMSecondKillSectionHeaderCell*) cell;

@end

///秒杀专区按钮
@interface WMSecondKillSectionHeaderCell : UICollectionViewCell<WMCountDownViewDelegate>

///日期
@property(nonatomic,readonly) UILabel *dateLabel;

///时间
@property(nonatomic,readonly) UILabel *timeLabel;

///状态
@property(nonatomic,readonly) UILabel *statusLabel;

///是否选中
@property(nonatomic,assign) BOOL sea_selected;

///倒计时 用来刷新状态
@property(nonatomic,readonly) WMCountDownView *countDownView;

///秒杀时间段信息
@property(nonatomic,strong) WMSecondKillInfo *info;

@property(nonatomic,weak) id<WMSecondKillSectionHeaderCellDelegate> delegate;

@end

@implementation WMSecondKillSectionHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat margin = 5.0;
        UIFont *font1 = [UIFont fontWithName:MainFontName size:12.0];
        UIFont *font2 = [UIFont boldSystemFontOfSize:17.0];
        CGFloat y = (frame.size.height - margin - font1.lineHeight - font2.lineHeight) / 2.0;
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, frame.size.width, font1.lineHeight)];
        _dateLabel.font = font1;
        _dateLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dateLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dateLabel.bottom + margin, frame.size.width, font2.lineHeight)];
        _timeLabel.font = font2;
        _timeLabel.textColor = _dateLabel.textColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
//        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _timeLabel.bottom, frame.size.width, height)];
//        _statusLabel.font = [UIFont fontWithName:MainFontName size:12.0];
//        _statusLabel.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_statusLabel];
//        
//        _statusLabel.textColor = _timeLabel.textColor;
        
        _countDownView = [[WMCountDownView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        [_countDownView initlization];
        _countDownView.delegate = self;
    }
    
    return self;
}

- (void)setSea_selected:(BOOL)sea_selected
{
    if(_sea_selected != sea_selected)
    {
        _sea_selected = sea_selected;
        _timeLabel.textColor = _sea_selected ? [UIColor whiteColor] : [UIColor blackColor];
       // _statusLabel.textColor = _timeLabel.textColor;
        _dateLabel.textColor = _timeLabel.textColor;
        self.contentView.backgroundColor = _sea_selected ? WMRedColor : [UIColor clearColor];
    }
}

- (void)setInfo:(WMSecondKillInfo *)info
{
    if(_info != info)
    {
        _info = info;
        [self reloadData];
    }
}

///刷新数据
- (void)reloadData
{
    self.dateLabel.text = _info.date;
    self.timeLabel.text = _info.time;
    self.statusLabel.text = _info.statusString;
    
    switch (_info.status)
    {
        case WMSecondKillStatusEnableSubscrible :
        {
            self.countDownView.timeInterval = _info.remindTime;
            [self.countDownView startTimer];
        }
            break;
        case WMSecondKillStatusNotBegan :
        {
            self.countDownView.timeInterval = _info.beginTime;
            [self.countDownView startTimer];
        }
            break;
        case WMSecondKillStatusBuying :
        {
            self.countDownView.timeInterval = _info.endTime;
            [self.countDownView startTimer];
        }
            break;
        case WMSecondKillStatusEnd :
        {
            self.countDownView.timeInterval = 0;
            [self.countDownView timerEnd];
        }
            break;
    }
}

- (void)countDownViewDidEnd:(WMCountDownView *)view
{
    ///订阅时间已过
    if(self.info.status == WMSecondKillStatusNotBegan && [self.delegate respondsToSelector:@selector(secondKillSectionHeaderCellDidEndSubscrible:)])
    {
        [self.delegate secondKillSectionHeaderCellDidEndSubscrible:self];
    }
    
    [self reloadData];
}

@end

@interface WMSecondKillSectionHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,WMCountDownViewDelegate,WMSecondKillSectionHeaderCellDelegate>

///秒杀时间集合
@property(nonatomic,strong) UICollectionView *collectionView;

///倒计时
@property(nonatomic,strong) WMCountDownView *countDownView;

/**红色1
 */
@property(nonatomic,readonly) UIView *redView;

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

///秒杀时区信息 数组元素是 WMTimeZoneInfo
@property(nonatomic,strong) NSArray *infos;

@end

@implementation WMSecondKillSectionHeaderView

/**构造方法 
 *@param infos 秒杀时区信息 数组元素是 WMSecondKillInfo
 */
- (instancetype)initWithInfos:(NSArray*) infos
{
    self = [super initWithFrame:CGRectMake(0, 0, _width_, WMSecondKillSectionHeaderViewHeight)];
    if(self)
    {
        self.infos = infos;
        self.backgroundColor = _SeaViewControllerBackgroundColor_;
        CGFloat height = WMSecondKillSectionHeaderViewHeight - _separatorLineWidth_ - 40.0;
        CGFloat margin = 10.0;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(_width_ / 4, height);
        
        ///秒杀时间集合
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, height) collectionViewLayout:layout];
        collectionView.backgroundView = nil;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[WMSecondKillSectionHeaderCell class] forCellWithReuseIdentifier:@"WMSecondKillSectionHeaderCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        ///分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, collectionView.bottom, self.width, _separatorLineWidth_)];
        line.backgroundColor = _separatorLineColor_;
        [self addSubview:line];
        
        UIFont *font = [UIFont fontWithName:MainFontName size:17.0];
        
        ///倒计时
        CGFloat width = 140.0;
        
        height = 40.0;
        self.countDownView = [[WMCountDownView alloc] initWithFrame:CGRectMake(self.width - width - margin, line.bottom + (height - 20.0) / 2.0, width, 20.0)];
        self.countDownView.numberBackgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [self.countDownView initlization];
        self.countDownView.contentAlignment = WMCountDownContentAlignmentRight;
        [self.countDownView setIcon:[UIImage imageNamed:@"count_down_icon"]];
        self.countDownView.delegate = self;
        [self addSubview:self.countDownView];
        
        ///红色视图
        _redView = [[UIView alloc] initWithFrame:CGRectMake(margin, line.bottom + (height - font.lineHeight) / 2.0, 2.0, font.lineHeight)];
        _redView.backgroundColor = WMRedColor;
        [self addSubview:_redView];
        
        ///标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_redView.right + 5.0, line.bottom, self.countDownView.left - _redView.right, height)];
        _titleLabel.font = font;
        _titleLabel.textColor = MainGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont fontWithName:MainFontName size:14.0];
        _titleLabel.text = @"限量好货 限时疯抢";
        [self addSubview:_titleLabel];
        
        _selectedIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc
{
    [_countDownView stopTimer];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        self.info = [self.infos objectAtIndex:_selectedIndex];
        [self.collectionView reloadData];
    }
}

- (void)setInfo:(WMSecondKillInfo *)info
{
    if(_info != info)
    {
        _info = info;
        
        [self reloadData];
    }
}

- (void)reloadData
{
    self.titleLabel.text = _info.name;
    switch (_info.status)
    {
        case WMSecondKillStatusNotBegan :
        case WMSecondKillStatusEnableSubscrible :
        {
            [self.countDownView setText:@" 距开始"];
            self.countDownView.timeInterval = _info.beginTime;
            [self.countDownView startTimer];
        }
            break;
        case WMSecondKillStatusBuying :
        {
            [self.countDownView setText:@" 距结束"];
            self.countDownView.timeInterval = _info.endTime;
            [self.countDownView startTimer];
        }
            break;
        case WMSecondKillStatusEnd :
        {
            self.countDownView.timeInterval = 0;
            [self.countDownView timerEnd];
        }
            break;
    }
}


#pragma mark- WMCountDownView delegate

- (void)countDownViewDidEnd:(WMCountDownView *)view
{
    [self reloadData];
    
    if([self.delegate respondsToSelector:@selector(secondKillSectionHeaderViewCountDownDidEnd:)])
    {
        [self.delegate secondKillSectionHeaderViewCountDownDidEnd:self];
    }
}

#pragma mark- UIColelctionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMSecondKillSectionHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMSecondKillSectionHeaderCell" forIndexPath:indexPath];
    
    WMSecondKillInfo *info = [self.infos objectAtIndex:indexPath.item];
    cell.delegate = self;
    cell.info = info;
    
    cell.sea_selected = self.selectedIndex == indexPath.item;
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if(indexPath.item == self.selectedIndex)
        return;
    
    WMSecondKillSectionHeaderCell *cell = (WMSecondKillSectionHeaderCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    cell.sea_selected = NO;
    self.selectedIndex = indexPath.item;
    cell = (WMSecondKillSectionHeaderCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.sea_selected = YES;
    
    WMSecondKillInfo *info = [self.infos objectAtIndex:indexPath.item];
    
    self.info = info;
    if([self.delegate respondsToSelector:@selector(secondKillSectionHeaderView:didSelectInfo:)])
    {
        [self.delegate secondKillSectionHeaderView:self didSelectInfo:info];
    }
}

#pragma mark- WMSecondKillSectionHeaderCell delegate

- (void)secondKillSectionHeaderCellDidEndSubscrible:(WMSecondKillSectionHeaderCell *)cell
{
    if([self.delegate respondsToSelector:@selector(secondKillSectionHeaderViewCountDownDidEnd:)])
    {
        [self.delegate secondKillSectionHeaderViewCountDownDidEnd:self];
    }
}

@end
