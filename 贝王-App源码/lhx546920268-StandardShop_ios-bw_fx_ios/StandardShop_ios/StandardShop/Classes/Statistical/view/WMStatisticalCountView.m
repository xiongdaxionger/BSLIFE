//
//  WMStatisticalCountView.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/3.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "WMStatisticalCountView.h"
#import "WMStatisticalInfo.h"

@implementation WMStatisticalCountViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        CGFloat pointWidth = 7.0;
        
        UIFont *countFont = [UIFont fontWithName:MainNumberFontName size:20.0];
        UIFont *titleFont = [UIFont fontWithName:MainFontName size:14.0];
        
        CGFloat margin = (frame.size.height - countFont.lineHeight - titleFont.lineHeight) / 3.0;
        
        ///点
        _point = [[UIView alloc] initWithFrame:CGRectMake(0, margin * 2 + countFont.lineHeight + (titleFont.lineHeight - pointWidth) / 2.0, pointWidth, pointWidth)];
        _point.layer.cornerRadius = pointWidth / 2.0;
        _point.layer.masksToBounds = YES;
        [self addSubview:_point];

        ///数字
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, margin, frame.size.width, countFont.lineHeight)];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = countFont;
        [self addSubview:_countLabel];
        
        ///标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_point.right, _countLabel.bottom + margin, 0, titleFont.lineHeight)];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat interval = 10.0;
    _countLabel.width = self.width;
    
    CGFloat width = [_titleLabel.text stringSizeWithFont:_titleLabel.font contraintWith:self.width - _point.width - interval].width;
    
    CGFloat x = (self.width - interval - width - _point.width) / 2.0;
    _point.left = x;
    
    frame = _titleLabel.frame;
    frame.origin.x = _point.right + interval;
    frame.size.width = width;
    _titleLabel.frame = frame;
}

@end

@interface WMStatisticalCountView ()



@end

#define WMStatisticalCountViewCellStartTag 1000

@implementation WMStatisticalCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        for(int i = 0;i < 3;i ++)
        {
            WMStatisticalCountViewCell *cell = [[WMStatisticalCountViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
            cell.tag = i + WMStatisticalCountViewCellStartTag;
        
            switch (i)
            {
                case 0 :
                {
                    cell.point.backgroundColor = WMStatisticalRed;
                }
                    break;
                case 1 :
                {
                    cell.point.backgroundColor = WMStatisticalBlue;
                }
                    break;
                case 2 :
                {
                    cell.point.backgroundColor = WMStatisticalGreen;
                }
                    break;
            }
            
            [self addSubview:cell];
        }
        
        self.layer.borderColor = _separatorLineColor_.CGColor;
        self.layer.borderWidth = _separatorLineWidth_;
    }
    return self;
}


///获取cell
- (WMStatisticalCountViewCell*)cellForIndex:(NSInteger) index
{
    return (WMStatisticalCountViewCell*)[self viewWithTag:index + WMStatisticalCountViewCellStartTag];
}

///统计信息
- (void)setInfo:(WMStatisticalInfo *)info
{
    _info = info;
    
    NSInteger count = _info.infos.count;
    CGFloat margin = 5.0;
    CGFloat width = (self.width - margin * (count + 1)) / count;
    
    for(NSInteger i = 0;i < count; i ++)
    {
        WMStatisticalDataInfo *data = [_info.infos objectAtIndex:i];
        
        WMStatisticalCountViewCell *cell = [self cellForIndex:i];
        cell.hidden = NO;
        
        cell.titleLabel.text = data.sumTitle;
        cell.countLabel.text = data.sum;
        CGRect frame = cell.frame;
        frame.origin.x = margin + (width + margin) * i;
        frame.size.width = width;
        cell.frame = frame;
    }
    
    for(NSInteger i = count; i < 3;i ++)
    {
        WMStatisticalCountViewCell *cell = [self cellForIndex:i];
        cell.hidden = YES;
    }
}


@end
